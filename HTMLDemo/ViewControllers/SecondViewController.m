//
//  ViewController.m
//  HTMLDemo
//
//  Created by Klaus on 2019/8/13.
//  Copyright © 2019 Klaus. All rights reserved.
//

#import "SecondViewController.h"

#import "KSAdaptiveHTMLCell.h"



@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource,KSAdaptiveHTMLCellDelegate>
@property (nonatomic) UITableView *tableView;
@end

@implementation SecondViewController

- (void)dealloc {
    NSLog(@"%@--dealloc",self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    self.title = @"Adaptive html cell";
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger )section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 3) {
        return UITableViewAutomaticDimension;
    } else {
        return indexPath.row * 50 + 100;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIndentifier = @"CellTableIdentifier";
    UITableViewCell *cell_x;
    
    if (indexPath.row == 3 ) {
        KSAdaptiveHTMLCell *cell = [KSAdaptiveHTMLCell cellForTableView:tableView];
        [cell configCellWithUrlStr:@"https://time.geekbang.org/" tableView:tableView indexPath:indexPath];
        cell.delegate = self;
        cell_x = cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIndentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellTableIndentifier];
            
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row];
        cell_x = cell;
    }
    return cell_x;
}


#pragma mark KSAdaptiveHTMLCellDelegate
- (void)htmlCellDidFinishLoad:(CGFloat)height cell:(KSAdaptiveHTMLCell *)cell{
    NSLog(@"htmlCellDidFinishLoad");
    [self.tableView reloadData];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = CGFLOAT_MIN;
    }
    return _tableView;
}

@end
