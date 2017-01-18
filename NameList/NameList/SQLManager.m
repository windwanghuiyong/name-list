//
//  SQLManager.m
//  NameList
//
//  Created by wanghuiyong on 06/11/2016.
//  Copyright © 2016 wanghuiyong. All rights reserved.
//

#import "SQLManager.h"

@implementation SQLManager

#define NameFile (@"student.sqlite")	// 数据库名称

static SQLManager *manager = nil;		// SQLManager 对象

/// 实例化对象
+ (SQLManager *)shareManager
{
    static dispatch_once_t once;

    dispatch_once(&once, ^{
        manager = [[self alloc] init];	// 初始化单例模式的 SQLManager 对象
    });
    return manager;
}
/// 沙盒中 Documents 目录下的数据库文件
-(NSString *)applicationDocumentsDirectoryFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	// Documents 目录的路径
    NSString *documentDirectory = [paths firstObject];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent: NameFile];					// 数据库完整路径
    return filePath;
}

-(void)createDataBaseTableIfNeeeded
{
	// 数据库所在文件完整路径, 数据库 database 对象
    NSString *writeTablePath  = [self applicationDocumentsDirectoryFile];
    NSLog(@"database address: %@", writeTablePath);

    if (sqlite3_open([writeTablePath UTF8String], &db) != SQLITE_OK)		// 打开数据库
    {
        sqlite3_close(db);
        NSAssert(NO, @"open database fail");
    }
    else
    {
        char *err;
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS StudentName (idNum TEXT PRIMARYKEY, name TEXT)"];
        if (sqlite3_exec(db, [createSQL UTF8String], NULL, NULL, &err) != SQLITE_OK)	// 创建键值对
        {
            sqlite3_close(db);
            NSAssert(NO, @"create table fail");
        }
        sqlite3_close(db);
    }
}

/// 按键查找数据库对象
- (StudentModel *)searchWithIdNum:(StudentModel *) model
{
	// 数据库所在文件完整路径, 数据库 database 对象
    NSString *path = [self applicationDocumentsDirectoryFile];
	NSLog(@"database address: %@", path);

    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK)		// 打开数据库
    {
        sqlite3_close(db);
        NSAssert(NO, @"open database fail");
    }
    else
    {
        NSString *qsql = @"SELECT idNum, name FROM StudentName Where idNum = ?";
        sqlite3_stmt *statement;

        // 函数参数: 数据库对象, SQL 语句, 执行语句的长度, 语句对象, 没有执行的语句部分
        if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statement, NULL) != SQLITE_OK)
        {
            // 按主键查询数据库
            NSString *idNum = model.idNum;
            // 语句对象, 参数开始执行的序号, 要绑定的值, 绑定的字符串的长度, 指针
            sqlite3_bind_text(statement, 1, [idNum UTF8String], -1, NULL);
            // 遍历
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                // 提取: 语句对象, 字段索引
                char *idNum = (char *)sqlite3_column_text(statement, 0);
                NSString *idNumStr = [[NSString alloc] initWithUTF8String:idNum];
                char *name = (char *)sqlite3_column_text(statement, 1);
                NSString *nameStr = [[NSString alloc] initWithUTF8String:name];

                StudentModel *model = [[StudentModel alloc] init];
                model.idNum = idNumStr;
                model.name = nameStr;
                sqlite3_finalize(statement);
                sqlite3_close(db);
                return model;
            }
        }
        sqlite3_finalize(statement);		// 释放语句
        sqlite3_close(db);
    }
    return nil;
}

// 插入或修改数据到数据库
- (int)insert: (StudentModel *) model
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK)
    {
        sqlite3_close(db);
        NSAssert(NO, @"open database fail");
    }
    else
    {
        NSString *sql = @"INSERT OR REPLACE INTO StudentName (idNum, name) VALUES (?, ?)";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text(statement, 1, [model.idNum UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [model.name UTF8String], -1, NULL);
            if (sqlite3_step(statement) != SQLITE_DONE)
            {
                NSAssert(NO, @"insert fail");
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
        }
    }
    return 0;
}

@end
