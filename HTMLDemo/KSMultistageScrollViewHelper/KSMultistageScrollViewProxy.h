//
//  KSMultistageScrollViewProxy.h
//  HTMLDemo
//
//  Created by Klaus on 2019/8/15.
//  Copyright © 2019 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/**
    负责将事件转发给helper与原有target
 */
@interface KSMultistageScrollViewProxy : NSProxy<UIScrollViewDelegate>
@property (nonatomic,weak) id scrollViewDelegate; 
@property (nonatomic,weak) id helperTarget;

- (void)configWithScrollView:(UIScrollView *)scrollView;
@end

NS_ASSUME_NONNULL_END
