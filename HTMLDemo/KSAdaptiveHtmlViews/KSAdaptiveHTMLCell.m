//
//  KSAdaptiveHTMLCell.m
//  Zeus
//
//  Created by Klaus on 2019/6/18.
//  Copyright © 2019 Klaus. All rights reserved.
//

#import "KSAdaptiveHTMLCell.h"
#import "KSAdaptiveHtmlView.h"
#import <Masonry.h>

@interface KSAdaptiveHTMLCell () <KSAdaptiveHtmlViewDelegate>

@property (nonatomic) KSAdaptiveHtmlView *htmlView;
@property (nonatomic) CGFloat HtmlHeight;

@end

@implementation KSAdaptiveHTMLCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellForTableView:(UITableView *)tableView {
    static NSString *cellID1 = @"KSAdaptiveHTMLCellID";
    KSAdaptiveHTMLCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID1];
    if (cell == nil) {
        cell = [[KSAdaptiveHTMLCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self.contentView addSubview:self.htmlView];
    self.webViewEdgeInsets = UIEdgeInsetsZero;
}

#pragma mark - KSAdaptiveHtmlViewDelegate
- (void)htmlViewDidFinishLoad:(CGFloat)height {
    if ([self.delegate respondsToSelector:@selector(htmlCellDidFinishLoad:cell:)]) {
        self.HtmlHeight = height;
        [self.delegate htmlCellDidFinishLoad:height cell:self];
    }
}

- (void)configCellWithUrlStr:(NSString *)urlStr tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    [self.htmlView loadWithUrlStr:urlStr];
}

- (KSAdaptiveHtmlView *)htmlView {
    if (!_htmlView) {
        _htmlView = [KSAdaptiveHtmlView new];
        _htmlView.delegate = self;
    }
    return _htmlView;
}

-(WKWebView *)webView {
    return self.htmlView.webView;
}

- (void)setWebViewEdgeInsets:(UIEdgeInsets)webViewEdgeInsets {
    _webViewEdgeInsets = webViewEdgeInsets;
    [self.htmlView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(webViewEdgeInsets);
    }];
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority {
    return CGSizeMake(self.contentView.bounds.size.width, self.HtmlHeight+self.webViewEdgeInsets.top+self.webViewEdgeInsets.bottom);
}

@end
