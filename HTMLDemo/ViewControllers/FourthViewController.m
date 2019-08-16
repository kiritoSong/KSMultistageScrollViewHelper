//
//  ViewController.m
//  HTMLDemo
//
//  Created by Klaus on 2019/8/13.
//  Copyright © 2019 Klaus. All rights reserved.
//

#import "FourthViewController.h"
#import "ScrollViewViewController.h"

#import "KSMultistageSuperTableView.h"
#import "HtmlTableViewCell.h"
#import "KSAdaptiveHTMLCell.h"
#import "KSMultistageScrollViewHelper.h"


@interface FourthViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,KSAdaptiveHTMLCellDelegate>
@property (nonatomic) KSMultistageSuperTableView *tableView;
@property (nonatomic) KSAdaptiveHTMLCell *cell;
@property (nonatomic) KSMultistageScrollViewHelper *scrollHelper;
@property (nonatomic) CGFloat cellHeight;
@end

@implementation FourthViewController

- (void)dealloc {
    NSLog(@"%@--dealloc",self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self scrollHelper];
    self.cellHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    self.title = @"Adaptive load more html cell";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger )section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 6) {
        return self.cellHeight;
    }else {
        return indexPath.row * 50 + 100;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIndentifier2 = @"CellTableIdentifier2";
    UITableViewCell *cell_x;
    
    if (indexPath.row == 6) {
        [self.cell configCellWithUrlStr:@"https://time.geekbang.org/library?category=1" tableView:tableView indexPath:indexPath];
        //        [self.cell configCellWithUrlStr:@"https://time.geekbang.org/comment/nice-module/30359" tableView:tableView indexPath:indexPath];
        self.cell.delegate = self;
        cell_x = self.cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIndentifier2];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellTableIndentifier2];
            
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row];
        cell_x = cell;
    }
    return cell_x;
}


#pragma mark KSAdaptiveHTMLCellDelegate
- (void)htmlCellDidFinishLoad:(CGFloat)height cell:(KSAdaptiveHTMLCell *)cell{
    if (height >= self.tableView.bounds.size.height) {
        self.cellHeight = self.tableView.bounds.size.height;
        self.cell.webView.scrollView.scrollEnabled = YES;
    }else {
        //这里、如果改变了就刷新的话。如果html那边也做了屏幕高度适应去尝试充满整个屏幕，会导致连续刷新tableView，直到cell满屏。
        //如果直接是一个固定高度的html，不会有什么问题只刷新一次tableView
        self.cellHeight = height;
        self.cell.webView.scrollView.scrollEnabled = NO;
    }
}


- (KSMultistageSuperTableView *)tableView {
    if (!_tableView) {
        _tableView = [KSMultistageSuperTableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (KSAdaptiveHTMLCell *)cell {
    if (!_cell) {
        static NSString *CellTableIndentifier = @"KSAdaptiveHTMLCellID";
        _cell = [[KSAdaptiveHTMLCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIndentifier];
    }
    return _cell;
}

- (void)setCellHeight:(CGFloat)cellHeight {
    if (_cellHeight != cellHeight) {
        NSLog(@"setCellHeight==%lf",cellHeight);
        [self.cell removeFromSuperview];
        [self.tableView reloadData];
    }
    _cellHeight = cellHeight;
}

- (KSMultistageScrollViewHelper *)scrollHelper {
    if (!_scrollHelper) {
        _scrollHelper = [[KSMultistageScrollViewHelper alloc]initWithBaseScrollView:self.tableView subScrollView:self.cell.webView.scrollView];
    }
    return _scrollHelper;
}
@end
