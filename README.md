# AutoModelFile
可以自动解析字典并且生成 model .h 和.m文件,支持嵌套结构字典，并且可以通过block设置属性的注释，只支持模拟器运行

使用事例：


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
