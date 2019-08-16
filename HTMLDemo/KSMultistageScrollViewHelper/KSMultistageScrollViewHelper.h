//
//  KSMultistageScrollViewHelper.h
//  HTMLDemo
//
//  Created by Klaus on 2019/8/15.
//  Copyright © 2019 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
    对联动事件进行处理
 */
@interface KSMultistageScrollViewHelper : NSObject
@property (nonatomic,readonly) UIScrollView *baseScrollView;
@property (nonatomic,readonly) UIScrollView *subScrollView;


/**
 绑定需要联动的两个scrollView
 一定要在他们开始滚动之前，否者我也不知道有啥bug。——。——

 @param baseScrollView 下方scrollView
 @param subScrollView 上方scrollView
 @return helper需要被持有，不然就释放了
 */
- (instancetype)initWithBaseScrollView:(UIScrollView *)baseScrollView subScrollView:(UIScrollView *)subScrollView;
@end

