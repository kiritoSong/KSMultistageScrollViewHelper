//
//  ScrollViewViewController.m
//  HTMLDemo
//
//  Created by Klaus on 2019/8/15.
//  Copyright © 2019 Klaus. All rights reserved.
//

#import "ScrollViewViewController.h"
#import "KSMultistageScrollViewHelper.h"
#import "KSMultistageSuperScrollView.h"

@interface ScrollViewViewController ()<UIScrollViewDelegate>

@property (nonatomic) KSMultistageSuperScrollView *firstScrollView;
@property (nonatomic) UIScrollView *secondScrollView;
@property (nonatomic) KSMultistageScrollViewHelper *scrollHelper;
@end

@implementation ScrollViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"UIScrollView";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self scrollHelper];
    
    [self.view addSubview:self.firstScrollView];
    [self.firstScrollView addSubview:self.secondScrollView];
    UIView *line  = [[UIView alloc]initWithFrame:CGRectMake(0, 400, 400, 100)];
    line.backgroundColor = [UIColor greenColor];
    [self.secondScrollView addSubview:line];
}

-(void)viewDidLayoutSubviews {
    self.firstScrollView.frame = self.view.bounds;
    self.firstScrollView.contentSize = CGSizeMake(self.firstScrollView.bounds.size.width, self.firstScrollView.bounds.size.height + 300);
    self.secondScrollView.frame = CGRectMake(0, 300, self.firstScrollView.bounds.size.width, self.firstScrollView.bounds.size.height);
    self.secondScrollView.contentSize = CGSizeMake(self.secondScrollView.bounds.size.width, self.secondScrollView.bounds.size.height*2);
}

-(KSMultistageSuperScrollView *)firstScrollView {
    if (!_firstScrollView) {
        _firstScrollView = [KSMultistageSuperScrollView new];
        _firstScrollView.delegate = self;
        _firstScrollView.backgroundColor = [UIColor orangeColor];
    }
    return _firstScrollView;
}


-(UIScrollView *)secondScrollView {
    if (!_secondScrollView) {
        _secondScrollView = [UIScrollView new];
        _secondScrollView.delegate = self;
        _secondScrollView.backgroundColor = [UIColor grayColor];
    }
    return _secondScrollView;
}

- (KSMultistageScrollViewHelper *)scrollHelper {
    if (!_scrollHelper) {
        _scrollHelper = [[KSMultistageScrollViewHelper alloc]initWithBaseScrollView:self.firstScrollView subScrollView:self.secondScrollView];
    }
    return _scrollHelper;
}
@end
