//
//  AddViewController.m
//  NameList
//
//  Created by wanghuiyong on 06/11/2016.
//  Copyright © 2016 wanghuiyong. All rights reserved.
//

#import "AddViewController.h"
#import "StudentModel.h"
#import "SQLManager.h"

@interface AddViewController ()

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"AddUser"])
    {
        NSLog(@"write");
        // 从文本输入框中获取数据并写入数据库
        StudentModel *model = [[StudentModel alloc] init];
        model.idNum = self.idNumTextField.text;
        model.name = self.nameTextField.text;
        NSLog(@"read text field %@, %@", model.idNum, model.name);
        [[SQLManager shareManager] insert:model];
    }
}

@end
