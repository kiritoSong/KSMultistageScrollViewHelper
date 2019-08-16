//
//  KSAdaptiveHtmlView.h
//  Zeus
//
//  Created by Klaus on 2019/6/19.
//  Copyright © 2019 infoq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WKWebView;
NS_ASSUME_NONNULL_BEGIN

@protocol KSAdaptiveHtmlViewDelegate <NSObject>

- (void)htmlViewDidFinishLoad:(CGFloat)height;

@end

/**
    能够自适应的WebView，展示文本页面用.如果给cell，需要承接代理然后reload
 */
@interface KSAdaptiveHtmlView : UIView

@property (nonatomic ,weak) id<KSAdaptiveHtmlViewDelegate> delegate;

@property (nonatomic) WKWebView *webView;
- (void)loadWithUrlStr:(NSString *)urlStr;

@end

NS_ASSUME_NONNULL_END
