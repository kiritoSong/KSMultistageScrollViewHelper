//
//  ViewController.m
//  HTMLDemo
//
//  Created by Klaus on 2019/8/13.
//  Copyright © 2019 Klaus. All rights reserved.
//

#import "ThirdViewController.h"

#import "KSMultistageSuperTableView.h"
#import "HtmlTableViewCell.h"
#import "KSMultistageScrollViewHelper.h"


@interface ThirdViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic) KSMultistageSuperTableView *tableView;
@property (nonatomic) HtmlTableViewCell *cell;
@property (nonatomic) KSMultistageScrollViewHelper *scrollHelper;
@end

@implementation ThirdViewController

- (void)dealloc {
    NSLog(@"%@--dealloc",self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self scrollHelper];
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    self.title = @"Full screen load more html cell";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger )section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 6) {
        return self.tableView.bounds.size.height;
    }else {
        return indexPath.row * 50 + 100;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIndentifier2 = @"CellTableIdentifier2";
    UITableViewCell *cell_x;
    
    if (indexPath.row == 6) {
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



- (KSMultistageSuperTableView *)tableView {
    if (!_tableView) {
        _tableView = [KSMultistageSuperTableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (HtmlTableViewCell *)cell {
    if (!_cell) {
        static NSString *CellTableIndentifier = @"HtmlTableViewCellID";
        _cell = [[HtmlTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIndentifier];
    }
    return _cell;
}

- (KSMultistageScrollViewHelper *)scrollHelper {
    if (!_scrollHelper) {
        _scrollHelper = [[KSMultistageScrollViewHelper alloc]initWithBaseScrollView:self.tableView subScrollView:self.cell.webView.scrollView];
    }
    return _scrollHelper;
}
@end
