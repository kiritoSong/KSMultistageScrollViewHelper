//
//  HtmlTableViewCell.m
//  HTMLDemo
//
//  Created by Klaus on 2019/8/15.
//  Copyright © 2019 Klaus. All rights reserved.
//

#import "HtmlTableViewCell.h"

@interface HtmlTableViewCell ()



@end

@implementation HtmlTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    self.webView.frame = self.contentView.bounds;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:self.webView];
    }
    return self;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc]init];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://time.geekbang.org/library?category=1"]];
        [_webView loadRequest:request];
    }
    return _webView;
}
@end
