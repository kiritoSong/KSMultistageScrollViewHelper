//
//  HtmlTableViewCell.h
//  HTMLDemo
//
//  Created by Klaus on 2019/8/15.
//  Copyright © 2019 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN


/**
 最简单的HTML容器cell，啥也别管直接满屏就完事儿了
 */
@interface HtmlTableViewCell : UITableViewCell

@property (nonatomic) WKWebView *webView;

@end

NS_ASSUME_NONNULL_END
