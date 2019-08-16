//
//  KSAdaptiveHtmlView.m
//  Zeus
//
//  Created by Klaus on 2019/6/19.
//  Copyright © 2019 infoq. All rights reserved.
//

#import "KSAdaptiveHtmlView.h"
#import <WebKit/WebKit.h>

@interface KSAdaptiveHtmlView () <WKNavigationDelegate, UIScrollViewDelegate>

@property (nonatomic) CGFloat HtmlHeight;
@property (nonatomic) NSString *htmlStr;
@property (nonatomic) NSString *urlStr;
@property (nonatomic) BOOL loading;

@end

@implementation KSAdaptiveHtmlView

- (void)dealloc {
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)layoutSubviews {
    self.webView.frame = self.bounds;
}

- (void)setupViews {
    [self addSubview:self.webView];
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 20);
    self.loading = YES;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

    self.loading = NO;
}


- (void)loadWithUrlStr:(NSString *)urlStr {
    if ([self.urlStr isEqualToString:urlStr]) {
        return;
    }
    [self loadUrlStr:urlStr];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (self.loading) {
        return;
    }
    CGFloat height = self.webView.scrollView.contentSize.height;
    if (self.HtmlHeight != height) {
        self.HtmlHeight = height;
        
        //这里加了一个延时，因为最开始`height`会频繁刷新。最后才稳定成最终值
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.HtmlHeight == height) {
                [self invalidateIntrinsicContentSize];
                NSLog(@"更新HTMLView高度");
                if ([self.delegate respondsToSelector:@selector(htmlViewDidFinishLoad:)]) {
                    [self.delegate htmlViewDidFinishLoad:self.HtmlHeight];
                }
            }
        });
    }
}

- (void)loadUrlStr:(NSString *)urlStr {
    self.webView.frame = self.bounds;
    self.webView.scrollView.contentSize = self.bounds.size;
    self.HtmlHeight = 0;
    self.urlStr = urlStr;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    req.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [self.webView loadRequest:req];
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [WKWebView new];
        _webView.navigationDelegate = self;
        _webView.scrollView.scrollEnabled = NO;
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {

    return nil;
}

//- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority {
//    return CGSizeMake(self.frame.size.width, self.HtmlHeight);
//}

//- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize {
//    return CGSizeMake(self.frame.size.width, self.HtmlHeight);
//}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(self.frame.size.width, self.HtmlHeight);
}
@end
