//
//  KSMultistageScrollViewHelper.m
//  HTMLDemo
//
//  Created by Klaus on 2019/8/15.
//  Copyright © 2019 Klaus. All rights reserved.
//

#import "KSMultistageScrollViewHelper.h"
#import "KSMultistageScrollViewProxy.h"

@interface  KSMultistageScrollViewHelper ()
//需要处理的两个scrollView
@property (nonatomic) UIScrollView *baseScrollView;
@property (nonatomic) UIScrollView *subScrollView;

//对于cell，webView与tableView之间隔着个UITableViewCell。用于确定联动的临界点
@property (nonatomic) UIView *baseScrollSubView;

//事件转发
@property (nonatomic) KSMultistageScrollViewProxy *baseScrollViewProxy;
@property (nonatomic) KSMultistageScrollViewProxy *subScrollViewProxy;

@property (nonatomic, assign,getter=baseViewScrolling) BOOL baseViewScroll;
@end

@implementation KSMultistageScrollViewHelper

- (instancetype)initWithBaseScrollView:(UIScrollView *)baseScrollView subScrollView:(UIScrollView *)subScrollView
{
    self = [super init];
    if (self) {
        self.baseScrollView = baseScrollView;
        self.subScrollView = subScrollView;
    }
    return self;
}

#pragma mark - core method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /**
        对于`self.baseScrollSubView.hidden`
        (当reload后该cell的位置需要发生变化,比如上面的cell高度增加)tableview对于只load了但是未确定展示位置的cell，似乎对设置成hiiden。
        此时frame不一定准确,会导致滑动动作卡在某个错误的位置
     **/
    if (self.baseScrollSubView.superview != self.baseScrollView || self.baseScrollSubView.hidden) {  //如果二者还没有联系，不要轻举妄动
        return;
    }
    CGFloat lockOffset = self.baseScrollSubView.frame.origin.y; //baseScrollView将要被锁定的偏移量
    if (self.baseScrollView == scrollView) {
        if (self.baseScrollView.contentOffset.y >= lockOffset) { //baseScrollView自己超过了锁定距离
            self.baseScrollView.contentOffset = CGPointMake(0, lockOffset);
            self.baseViewScroll = NO;
        }else{
            if (!self.baseViewScrolling  && self.subScrollView.contentOffset.y > 0) {//subScrollView正在滚动
                self.baseScrollView.contentOffset = CGPointMake(0, lockOffset);
            }
        }
        self.baseScrollView.showsVerticalScrollIndicator = self.baseViewScrolling?YES:NO;
    }
    if (self.subScrollView == scrollView) {
        if (self.baseScrollView.contentOffset.y != lockOffset) { //如果baseScrollView处在锁定位置，都要去滚动父ScrollView
            self.baseViewScroll = YES;
        }
        if (self.baseViewScrolling) {
            self.subScrollView.contentOffset = CGPointZero;
        }
        if (self.subScrollView.contentOffset.y <= 0) { //subScrollView到顶后屏蔽下拉动作
            self.subScrollView.contentOffset = CGPointZero;
            self.baseViewScroll = YES;
        }
        self.subScrollView.showsVerticalScrollIndicator = self.baseViewScrolling?NO:YES;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        //没有减速动画的时候，UIScrollView真正停止在这
        if (self.subScrollView == scrollView) {
            if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height) {
                scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y-1);
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView{
    //有减速动画的时候，UIScrollView真正停止在这
    if (self.subScrollView == scrollView) {
        if (scrollView.contentOffset.y + scrollView.frame.size.height >= floor(scrollView.contentSize.height)) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y-1);
        }
    }
}


#pragma mark - setter && getter

- (void)setBaseViewScroll:(BOOL)baseViewScroll
{
    _baseViewScroll = baseViewScroll;
    if (baseViewScroll) {//如果将要滚动baseScrollView，将SubScrollView锁定在顶部
        self.subScrollView.contentOffset = CGPointZero;
    }
}

- (void)setBaseScrollView:(UIScrollView *)baseScrollView {
    _baseScrollView = baseScrollView;
    [self.baseScrollViewProxy configWithScrollView:baseScrollView];
}

- (void)setSubScrollView:(UIScrollView *)subScrollView {
    _subScrollView = subScrollView;
    [self.subScrollViewProxy configWithScrollView:subScrollView];
}

- (UIView *)baseScrollSubView {
    if (!_baseScrollSubView) {
        UIView *view = self.subScrollView;
        while (view && view!=self.baseScrollView) {
            _baseScrollSubView = view;
            view = view.superview;
        }
    }
    return _baseScrollSubView;
}

- (KSMultistageScrollViewProxy *)baseScrollViewProxy {
    if (!_baseScrollViewProxy) {
        _baseScrollViewProxy = [KSMultistageScrollViewProxy alloc];
        _baseScrollViewProxy.helperTarget = self;
    }
    return _baseScrollViewProxy;
}

- (KSMultistageScrollViewProxy *)subScrollViewProxy {
    if (!_subScrollViewProxy) {
        _subScrollViewProxy = [KSMultistageScrollViewProxy alloc];
        _subScrollViewProxy.helperTarget = self;
    }
    return _subScrollViewProxy;
}

@end
