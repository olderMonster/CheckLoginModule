//
//  CheckLoginImp.m
//  CheckLoginModule_Example
//
//  Created by 印聪 on 2023/2/7.
//  Copyright © 2023 印聪. All rights reserved.
//

#import "CheckLoginImp.h"
#import <CheckLoginModule/Annotation.h>
#import "CheckLoginModule_Example-Swift.h"

@interface CheckLoginImp()

@end

@implementation CheckLoginImp

@CheckLogin(DetailViewController,buyAction,CheckLoginModule_Example)
@CheckLogin(DetailViewController,jumpToMessagePage,CheckLoginModule_Example)


@end
