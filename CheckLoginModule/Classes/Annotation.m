//
//  Annotation.m
//  MetaJoy
//
//  Created by 印聪 on 2023/2/3.
//

#import "Annotation.h"
#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <mach-o/dyld.h>
#include <dlfcn.h>
#import <objc/runtime.h>
#import <objc/message.h>
#include <mach-o/ldsyms.h>
#import <Aspects/Aspects.h>

NSArray<NSString *>* MTReadConfiguration(char *sectionName,const struct mach_header *mhp);
static void dyld_callback(const struct mach_header *mhp, intptr_t vmaddr_slide) {
    NSArray<NSString *> *services = MTReadConfiguration(SectionName, mhp);
    for (NSString *jsonString in services) {
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (!error) {
            if ([json isKindOfClass:[NSDictionary class]] && [json allKeys].count > 0) {
                NSString *className = json[@"cls"];
                NSString *selName = json[@"sel"];
                NSString *namespace = json[@"namespace"];
                if (namespace != nil && namespace.length > 0) {
                    className = [NSString stringWithFormat:@"%@.%@",namespace,className];
                }
                NSLog(@"className: %@  sel: %@", className, selName);
                //获取到注解的类以及其方法后对该方法进行hook
                Class clazz = NSClassFromString(className);
                SEL selector = NSSelectorFromString(selName);
                if ([clazz instancesRespondToSelector:selector]) {
//                    clazz = [clazz class];
                } else if ([clazz respondsToSelector:selector]){
                    clazz = object_getClass(clazz);
                } else {
                    return;
                }
                
                [clazz aspect_hookSelector:selector withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aspectInfo) {
                    Annotation *annotation = [Annotation sharedInstance];
                    BOOL isAccess = NO;
                    if (annotation.delegate != nil && [annotation.delegate respondsToSelector:@selector(authorizeAccess)]) {
                        isAccess = [annotation.delegate authorizeAccess];
                    }
                    if (isAccess) {
                        [aspectInfo.originalInvocation invoke];
                    } else {
                        if (annotation.delegate != nil && [annotation.delegate respondsToSelector:@selector(requestAuthorizeAccess:)]) {
                            [annotation.delegate requestAuthorizeAccess: ^(void) {
                                if (annotation.autoNext) {
                                    [aspectInfo.originalInvocation invoke];
                                }
                            }];
                        }
                    }
                } error: nil];                
            }
        }
    }
}

__attribute__((constructor))
void initProphet(void) {
    _dyld_register_func_for_add_image(dyld_callback);
}


NSArray<NSString *>* MTReadConfiguration(char *sectionName,const struct mach_header *mhp)
{
    NSMutableArray *configs = [NSMutableArray array];
    unsigned long size = 0;
#ifndef __LP64__
    uintptr_t *memory = (uintptr_t*)getsectiondata(mhp, SEG_DATA, sectionName, &size);
#else
    const struct mach_header_64 *mhp64 = (const struct mach_header_64 *)mhp;
    uintptr_t *memory = (uintptr_t*)getsectiondata(mhp64, SEG_DATA, sectionName, &size);
#endif
    
    unsigned long counter = size/sizeof(void*);
    for(int idx = 0; idx < counter; ++idx){
        char *string = (char*)memory[idx];
        NSString *str = [NSString stringWithUTF8String:string];
        if(!str)continue;
        if(str) [configs addObject:str];
    }
    
    return configs;
}

//单例类的静态实例对象，因对象需要唯一性，故只能是static类型
static Annotation *shared = nil;

@implementation Annotation


/**单例模式对外的唯一接口，用到的dispatch_once函数在一个应用程序内只会执行一次，且dispatch_once能确保线程安全
*/
+ (Annotation *)sharedInstance {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if(shared == nil){
            shared = [[self alloc] init];
        }
    });
    return shared;
}

/**覆盖该方法主要确保当用户通过[[Singleton alloc] init]创建对象时对象的唯一性，alloc方法会调用该方法，只不过zone参数默认为nil，因该类覆盖了allocWithZone方法，所以只能通过其父类分配内存，即[super allocWithZone:zone]
 */
+ (id)allocWithZone:(struct _NSZone *)zone
{
   static dispatch_once_t token;
    dispatch_once(&token, ^{
        if(shared == nil) {
            shared = [super allocWithZone:zone];
        }
    });
    return shared;
}
//自定义初始化方法
- (instancetype)init
{
    self = [super init];
    if(self) {
        self.autoNext = NO;
    }
    return self;
}

//覆盖该方法主要确保当用户通过copy方法产生对象时对象的唯一性
- (id)copy {
    return self;
}

//覆盖该方法主要确保当用户通过mutableCopy方法产生对象时对象的唯一性
- (id)mutableCopy{
    return self;
}

//自定义描述信息，用于log详细打印
- (NSString *)description {
    return [NSString stringWithFormat:@"memeory address:%p",self];
}



@end
