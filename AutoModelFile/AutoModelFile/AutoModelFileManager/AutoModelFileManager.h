//
//  AutoModelFileManager.h
//  test2
//
//  Created by sunwf on 2017/11/8.
//  Copyright © 2017年 sunwf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AutoModelFileManager : NSObject

/**
 自动生成模型类文件并添加属性注释

 @param fileName 文件名
 @param className 类名
 @param superModelName 模型基类，可以为空，默认NSObject
 @param dictionary  接口返回的模型字典、jsonDic
 @param path  __file__ 当前执行代码所在类的路径
 @param remarkBlock 属性注释 如： dic = @{@"name" :@"姓名"} ， 支持嵌套结构 如：dic = @{@"people" :@[@{@"name":@"姓名" }],@"people_remark":@"某人" } 。 注意：加_remark 为嵌套结构添加注释。
 */
+(void)autoModelFileWithName:(NSString *)fileName ClassName:(NSString *)className superModelName:(NSString *)superModelName dictionary:(NSDictionary *)dictionary currentPath:(NSString *)path remarkBlock:(NSDictionary * (^)(void) )remarkBlock;


@end



/**
 类文件相关内容
 */
@interface ClassFileInfo : NSObject

@property(nonatomic,strong) NSMutableString *headStr;      //文件头部描述
@property(nonatomic,strong) NSMutableString *importStr;    //文件引用
@property(nonatomic,strong) NSMutableString *define;       //文件声明
@property(nonatomic,copy  ) NSString        *className;    //文件类名
@property(nonatomic,copy  ) NSString        *fileName;     //文件名
@property(nonatomic,strong) NSMutableString *propertyStr;  //属性内容
@property(nonatomic,strong) NSMutableString *methodStr;    //方法内容

@end


typedef NS_ENUM(int, PropertyType)
{
    PropertyTypeInteger,
    PropertyTypeFloat,
    PropertyTypeDouble,
    PropertyTypeString,
    PropertyTypeArray,
    PropertyTypeDictionary
};



/**
 属性相关内容
 */
@interface PropertyInfo : NSObject

@property(nonatomic,copy) NSString *propertyStr;
@property(nonatomic,copy) NSString *descriptionHead;
@property(nonatomic,copy) NSString *descriptionTail;
@property(nonatomic,copy) NSString *decodeStr;
@property(nonatomic,copy) NSString *encodeStr;

-(void)setType:(PropertyType)type key:(NSString *)key;
-(void)setPropertyWithClassName:(NSString *)className key:(NSString *)key;

@end
