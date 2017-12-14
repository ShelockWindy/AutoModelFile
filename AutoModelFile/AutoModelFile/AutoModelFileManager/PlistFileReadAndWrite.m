
//
//  PlistFileReadAndWrite.m
//  test2
//
//  Created by sunwf on 2017/11/27.
//  Copyright © 2017年 sunwf. All rights reserved.
//

#import "PlistFileReadAndWrite.h"

@implementation PlistFileReadAndWrite

-(void)savePlistFileWithName:(NSString *)name hFilePath:(NSString *)hFilePath mFilePath:(NSString *)mFilePath
{
    //获取路径对象
    NSString *path = [NSString stringWithFormat:@"%s",__FILE__];

    NSArray *pathArray = [path componentsSeparatedByString:@"/"];
    //获取文件的完整路径
    NSString *filePatch = [path stringByReplacingOccurrencesOfString:[pathArray lastObject] withString:@"autoModel.plist"];
    
    NSLog(@"%@",filePatch);
    
    //写入数据到plist文件
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    [dic1 setValue:name forKey:@"name"];
    [dic1 setValue:hFilePath forKey:@"hFilePath"];
    [dic1 setValue:mFilePath forKey:@"mFilePath"];

    //将上面2个小字典保存到大字典里面
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePatch];
    if (dataDic==nil) {
        dataDic = [NSMutableDictionary dictionary];
    }
    [dataDic setObject:dic1 forKey:name];
    //写入plist里面
    [dataDic writeToFile:filePatch atomically:YES];
    //读取plist文件的内容
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePatch];
    NSLog(@"---plist一开始保存时候的内容---%@",dataDictionary);
    
    NSString * txtFiePath = [[NSString stringWithFormat:@"%s",__FILE__] stringByDeletingLastPathComponent];
;
    txtFiePath = [txtFiePath stringByAppendingPathComponent:@"autoModel.txt"];
    
    NSString * txtContent = @"";
    
    for (NSDictionary * dic in [dataDictionary allValues]) {
        
        NSString * name = [dic valueForKey:@"name"];
        NSString * h_filePath = [dic valueForKey:@"hFilePath"];
        NSString * m_filePath = [dic valueForKey:@"mFilePath"];
        txtContent =   [txtContent stringByAppendingString:[NSString stringWithFormat:@"%@|%@|%@\n",name,h_filePath,m_filePath]];

    }
    NSLog(@"txtContent ----%@",txtContent);
    [txtContent writeToFile:@"" atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [txtContent writeToFile:txtFiePath atomically:YES encoding:NSUTF8StringEncoding error:nil];

}


@end
