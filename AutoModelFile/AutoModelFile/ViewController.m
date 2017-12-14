//
//  ViewController.m
//  test2
//
//  Created by sunwf on 2017/9/19.
//  Copyright © 2017年 sunwf. All rights reserved.
//

#import "ViewController.h"
#import "UIAlertController+AttibuteText.h"
#import "AutoModelFileManager.h"
#import "PlistFileReadAndWrite.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"hello" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"清空私信内容" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"将他拉黑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];;
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"将他拉黑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction * action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    action3.detaiMessage = @"双方不再可以互发私信";
    action1.titleColor = UIColorFromRGB(0x333333);
    action2.titleColor = UIColorFromRGB(0xff5e5e);
    action3.titleColor = UIColorFromRGB(0x16ca4e);
    action4.titleColor = UIColorFromRGB(0x16ca4e);

    [alertVC addAction:action1];
    [alertVC addAction:action2];
//    [alertVC addAction:action3];
//    [alertVC addAction:action4];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:alertVC animated:YES completion:nil];
        
    });

    NSDictionary * testDic = @{@"name":@"zhangsan",
                               @"sex":@"男",
                               @"age":@18
                               };
    NSArray * testArr = @[testDic];
    
    NSDictionary * newDic = @{@"number":testArr,
                              @"address":@""
                              };
    
    
    
    NSString * path = [NSString stringWithFormat:@"%s",__FILE__];
    [AutoModelFileManager autoModelFileWithName:@"People" ClassName:@"Student" superModelName:@"Manager" dictionary:newDic currentPath:path remarkBlock:^NSDictionary *{
        
        NSDictionary * remakDic = @{@"number":@{@"name":@"姓名",
                                                @"sex2":@"性别",
                                                @"age":@"年龄"
                                                },
                                    @"address":@"家庭住址",
                                    @"number_remark":@"一个随意的🤠😜😙数字"
                                    };
        return remakDic;
        
    }];
    
   
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
