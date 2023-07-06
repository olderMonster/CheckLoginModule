//
//  MTViewController.m
//  CheckLoginModule
//
//  Created by 印聪 on 02/07/2023.
//  Copyright (c) 2023 印聪. All rights reserved.
//

#import "MTViewController.h"
#import <Masonry/Masonry.h>
#import "CheckLoginModule_Example-Swift.h"
#import <CheckLoginModule/Annotation.h>

@interface MTViewController ()

@property (nonatomic , strong)UIButton *detailButton;

@property (nonatomic , strong)UIButton *buyButton;

@end

@implementation MTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.detailButton];
    [self.view addSubview:self.buyButton];
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(100);
    }];
    
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.detailButton.mas_bottom).offset(40);
    }];
}

- (void)jumpToDetailAction {
    [self.navigationController pushViewController:[[DetailViewController alloc] init] animated:YES];
}

@CheckLoginOC(MTViewController,buyGoodsAction)
- (void)buyGoodsAction {
    [User createOrderAlertWithViewController:self];
}


- (UIButton *)detailButton {
    if (_detailButton == nil) {
        _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_detailButton setTitle:@"查看详情" forState:UIControlStateNormal];
        [_detailButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_detailButton addTarget:self action:@selector(jumpToDetailAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailButton;
}

- (UIButton *)buyButton {
    if (_buyButton == nil) {
        _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyButton setTitle:@"购买" forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_buyButton addTarget:self action:@selector(buyGoodsAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyButton;
}


@end
