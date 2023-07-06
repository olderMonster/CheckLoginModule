//
//  Annotation.h
//  MetaJoy
//
//  Created by 印聪 on 2023/2/3.
//

#import <Foundation/Foundation.h>

#define SectionName "MTLoginService"

//因為 ## 的特性 ( 阻止另一个宏的展开 )，需要中间层：
#define AnnotationService(cls) COMBINE(cls, __LINE__, __COUNTER__)
#define COMBINE_(X, Y, Z) X ## Y ## Z
#define COMBINE(X, Y, Z) COMBINE_(X, Y, Z)

//数据段，MTLogin节处保存数据
#define DATASection(name) __attribute__((used,section("__DATA,"#name" ")))

#define CheckLogin(cls,sel,namespace) \
class CheckLoginAnnotation; char *const AnnotationService(cls) DATASection(MTLoginService) = "{\"cls\":\""#cls"\",\"sel\":\""#sel"\",\"namespace\":\""#namespace"\"}";

#define CheckLoginOC(cls,sel) \
class CheckLoginAnnotation; char *const AnnotationService(cls) DATASection(MTLoginService) = "{\"cls\":\""#cls"\",\"sel\":\""#sel"\"}";

NS_ASSUME_NONNULL_BEGIN

@protocol AnnotationDelegate <NSObject>


/// 获取授权。
/// - Parameter status: 授权状态
- (BOOL)authorizeAccess;


/// 前往授权
- (void)requestAuthorizeAccess:(void(^)(void))authoried;

@end


@interface Annotation : NSObject

@property (nonatomic, assign)BOOL autoNext;

@property (nonatomic , weak)id<AnnotationDelegate> delegate;

+ (Annotation *)sharedInstance;

@end

NS_ASSUME_NONNULL_END
