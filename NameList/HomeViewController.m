//
//  HomeViewController.m
//  NameList
//
//  Created by wanghuiyong on 06/11/2016.
//  Copyright © 2016 wanghuiyong. All rights reserved.
//

#import "HomeViewController.h"
#import "StudentModel.h"
#import "SQLManager.h"

@interface HomeViewController ()
@property (strong, nonatomic) NSMutableArray *studentArray;	// 属性, 指定 table 的数据源是可变数组, 每个元素是 StudentModel 对象, 对应 table 的一行
@end

@implementation HomeViewController

#define HomeCellIdentifier (@"StudentCell")		// cell 对象的标识符

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.studentArray = [[NSMutableArray alloc] init];		// table 加载后初始化可变数组
    NSLog(@"init........");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;										// table 的 section 的数量只有1个
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@".........%lu", (unsigned long)_studentArray.count);
    return _studentArray.count;						// table 的 section 的行数即是可变数组的元素个数
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath	// 提供 table 的 cell 对象
{
	// 根据 cell 对象的标识符和位置初始化可重用的 cell 对象
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeCellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    if (self.studentArray.count > 0)
    {
		// 从 table 的数据源中获取数据, 赋给 cell 对象的内容以供显示
        StudentModel *model = [self.studentArray objectAtIndex:indexPath.row];
        cell.textLabel.text = model.idNum;
        cell.detailTextLabel.text = model.name;
    }
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;			// table 的该行可编辑或删除
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.f;		// table 的该行的高度
}

/// 点击 done 按钮后的动作
/// (输入完成并将数据存入数据库后)从数据库中检索数据, 赋给 table 的数据源, 并更新 table 的 cell, 以在主视图中进行显示
- (IBAction)addUserDone:(UIStoryboardSegue *)sender
{
    StudentModel *model = [[StudentModel alloc] init];
    model.idNum = @"100";
    NSLog(@"aaa");
    StudentModel *result = [[SQLManager shareManager] searchWithIdNum:model];	// 初始化数据库, 并从数据库中按键搜索 StudentModel 对象
    NSLog(@"%@ %@", result.idNum, result.name);
    [self.studentArray addObject:result];
//    [_studentArray addObject:result];		// 将得到的 StudentModeld 对象添加到 table 的数据源中
    NSLog(@"reload");
    [self.tableView reloadData];			// table 重新加载数据, 应该会执行上面定义的那些方法, 以初始化 cell
}

@end
