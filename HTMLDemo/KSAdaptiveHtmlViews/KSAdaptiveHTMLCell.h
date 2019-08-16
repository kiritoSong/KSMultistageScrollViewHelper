//
//  KSAdaptiveHTMLCell.h
//  Zeus
//
//  Created by Klaus on 2019/6/18.
//  Copyright © 2019 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN
@class KSAdaptiveHTMLCell;
@protocol KSAdaptiveHTMLCellDelegate <NSObject>

- (void)htmlCellDidFinishLoad:(CGFloat)height cell:(KSAdaptiveHTMLCell *)cell;

@end

/**
    自适应webView的cell，需要手动在代理后调用talebiew.loadData
 */
@interface KSAdaptiveHTMLCell : UITableViewCell
@property (nonatomic ,weak) id<KSAdaptiveHTMLCellDelegate> delegate;
@property (nonatomic) WKWebView *webView;
@property (nonatomic) UIEdgeInsets webViewEdgeInsets;

+ (instancetype)cellForTableView:(UITableView *)tableView;

- (void)configCellWithUrlStr:(NSString *)urlStr tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;


@end

NS_ASSUME_NONNULL_END
