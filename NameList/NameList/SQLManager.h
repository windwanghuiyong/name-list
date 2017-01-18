//
//  SQLManager.h
//  NameList
//
//  Created by wanghuiyong on 06/11/2016.
//  Copyright © 2016 wanghuiyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "StudentModel.h"

@interface SQLManager : NSObject
{
    sqlite3 *db;	// 成员变量是数据库本身
}
+ (SQLManager *)shareManager;
- (StudentModel *)searchWithIdNum:(StudentModel *) model;
- (int)insert: (StudentModel *) model;

@end
