//
//  ViewController.m
//  HTMLDemo
//
//  Created by Klaus on 2019/8/13.
//  Copyright © 2019 Klaus. All rights reserved.
//

#import "FirstViewController.h"

#import "KSAdaptiveHtmlView.h"
#import <Masonry.h>




@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)dealloc {
    NSLog(@"%@--dealloc",self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Adaptive html view";
    self.view.backgroundColor = [UIColor whiteColor];
    
    KSAdaptiveHtmlView *html = [KSAdaptiveHtmlView new];
    [self.view addSubview:html];
    
    
    UILabel *lab = [UILabel new];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"原生label";
    [self.view addSubview:lab];
    
    
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(html);
        make.top.mas_equalTo(html.mas_bottom);
    }];
    
    [html mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
    }];
    
    
    
    
    [html loadWithUrlStr:@"https://time.geekbang.org/comment/nice-module/30359"];

}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = NO;
}

@end
