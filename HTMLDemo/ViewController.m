//
//  ViewController.m
//  HTMLDemo
//
//  Created by Klaus on 2019/8/13.
//  Copyright © 2019 Klaus. All rights reserved.
//

#import "ViewController.h"


#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"
#import "FifthViewController.h"
#import "ScrollViewViewController.h"



@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *cellTitleArr;
@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    self.title = @"Root";
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger )section {
    return self.cellTitleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellTableIndentifier = @"CellTableIdentifier";


    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIndentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellTableIndentifier];
        
    }
    cell.textLabel.text = self.cellTitleArr[indexPath.row];
    cell.textLabel.numberOfLines = 0;

    return cell;
}

+ (UIColor*)RandomColor {
    NSInteger aRedValue =arc4random() %255;
    NSInteger aGreenValue =arc4random() %255;
    NSInteger aBlueValue =arc4random() %255;
    UIColor*randColor = [UIColor colorWithRed:aRedValue /255.0f green:aGreenValue /255.0f blue:aBlueValue /255.0f alpha:1.0f];
    return randColor;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            [self.navigationController pushViewController:[FirstViewController new] animated:YES];
        }
            break;
        case 1:
        {
            [self.navigationController pushViewController:[SecondViewController new] animated:YES];
        }
            break;
        case 2:
        {
            [self.navigationController pushViewController:[ScrollViewViewController new] animated:YES];
        }
            break;
        case 3:
        {
            [self.navigationController pushViewController:[ThirdViewController new] animated:YES];
        }
            break;
        case 4:
        {
            [self.navigationController pushViewController:[FourthViewController new] animated:YES];
        }
            break;
        case 5:
        {
            [self.navigationController pushViewController:[FifthViewController new] animated:YES];
        }
            break;
            
            
        default:
            break;
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray *)cellTitleArr {
    if (!_cellTitleArr) {
        _cellTitleArr = @[@"Adaptive html view",//自适应的网页view
                          @"Adaptive html cell",//任意位置自适应，全部展开的网页cell
                          @"Multistage scrollView",//两个scrollView联动,html加载更多的原理
                          @"Full screen load more html cell", //位于最后一个可以加载更多，直接设置成全屏的普通网页cell。如果能接受满屏cell，这个方案是最稳妥的
                          @"Adaptive load more html cell", //位于最后一个可以加载更多，内容过短时也可以自适应高度的网页cell。
                          @"Plural html cell",//复数网页cell
                          ];
    }
    return _cellTitleArr;
}
@end
