//
//  AutoModelFileManager.m
//  test2
//
//  Created by sunwf on 2017/11/8.
//  Copyright © 2017年 sunwf. All rights reserved.
//

#import "AutoModelFileManager.h"
#import <CoreGraphics/CoreGraphics.h>
#import <unistd.h>

@interface NSMutableString (Safe)
-(void)appendStringSafe:(NSString *)aString;
@end

@implementation NSMutableString (Safe)
-(void)appendStringSafe:(NSString *)aString
{
    if (aString) {
        [self appendString:aString];
    }
}
@end


@implementation AutoModelFileManager



+(void)autoModelFileWithName:(NSString *)fileName ClassName:(NSString *)className superModelName:(NSString *)superModelName dictionary:(NSDictionary *)dictionary currentPath:(NSString *)path remarkBlock:(NSDictionary * (^)(void) )remarkBlock;
{
    
#if DEBUG
    NSDictionary * remarkDic ;
    if (remarkBlock) {
     remarkDic  =  remarkBlock();
    }
    //.h .m
    ClassFileInfo * modelFile_h = [[ClassFileInfo alloc]init];
    ClassFileInfo * modelFile_m = [[ClassFileInfo alloc]init];
    modelFile_h.fileName = [fileName stringByAppendingString:@".h"];
    modelFile_m.fileName = [fileName stringByAppendingString:@".m"];
    modelFile_h.className = className;
    modelFile_m.className = className;
    
    //import
    modelFile_h.importStr =  [NSMutableString stringWithFormat:@"\n#import <Foundation/Foundation.h>"];
    if (superModelName) {
        [modelFile_h.importStr appendStringSafe:[NSString stringWithFormat:@"\n#import \"%@.h\"",superModelName]];
    }
    
    modelFile_m.importStr = [NSMutableString stringWithFormat:@"\n#import \"%@.h\" ",fileName];
    
    //define
    modelFile_h.define =  [NSMutableString stringWithFormat:@"@interface %@ : NSObject%@\n",className,@"<NSCoding>"];
    if (superModelName) {
        modelFile_h.define =  [NSMutableString stringWithFormat:@"@interface %@:%@%@\n",className,superModelName,@"<NSCoding>"];
    }
    modelFile_m.define =  [NSMutableString stringWithFormat:@"\n@implementation %@",className];
    
    //methodStr
    modelFile_h.methodStr = [NSMutableString string];
    modelFile_m.methodStr = [NSMutableString stringWithFormat:@"\n-(instancetype)init{\n"];
    [modelFile_m.methodStr appendString:@"\tself = [super init];\n\tif(self){\n\n\t}\n\treturn self;\n}\n"];
    
    //headStr
    modelFile_h.headStr =  [NSMutableString stringWithFormat:@"//\n//%@ \n//\n//\n//Create by ",modelFile_h.fileName];
    modelFile_m.headStr =  [NSMutableString stringWithFormat:@"//\n//%@ \n//\n//\n//Create by ",modelFile_m.fileName];
    
    NSString *userName = @"AutoModelFileManager";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yy/M/d";
    NSString *dateStr = [formatter stringFromDate:[NSDate new]];
    
    NSString *cpy = [NSString stringWithFormat:@"%@ on %@ \n//Copyright (c)",userName,dateStr];
    [modelFile_h.headStr appendStringSafe:cpy];
    formatter.dateFormat = @"yyyy年";
    [modelFile_h.headStr appendStringSafe:[NSString stringWithFormat:@" %@ %@. All rights reserved.\n//\n//",[formatter stringFromDate:[NSDate new]],userName]];
    
    [modelFile_m.headStr appendStringSafe:cpy];
    formatter.dateFormat = @"yyyy年";
    [modelFile_m.headStr appendStringSafe:[NSString stringWithFormat:@" %@ %@. All rights reserved.\n//\n//",[formatter stringFromDate:[NSDate new]],userName]];
    
    NSString * descrip = @"此文件由有代码自动生成，不要手动修改";
    [modelFile_h.headStr appendStringSafe:descrip];
    [modelFile_m.headStr appendStringSafe:descrip];
    
    //propertyStr
    modelFile_h.propertyStr = [NSMutableString new];
    modelFile_m.propertyStr = [NSMutableString new];
    
    NSMutableString *decodeStr = [NSMutableString stringWithFormat:@"\n-(instancetype)initWithCoder:(NSCoder *)aDecoder\n{\n"];
    [decodeStr appendStringSafe:@"\tself = [super init];\n\tif(self){"];
    NSMutableString *encodeStr = [NSMutableString stringWithFormat:@"\n-(void)encodeWithCoder:(NSCoder *)aCoder\n{"];
    
    NSMutableString *descrptionHead = [NSMutableString stringWithFormat:@"\n-(NSString *)description{\n\treturn [NSString stringWithFormat:@\"{"];
    NSMutableString *descrptionTail = [NSMutableString stringWithFormat:@""];
    
    NSMutableString *mjArrayStr = nil;
    
    NSArray *allKeys = [dictionary allKeys];
    for (NSString *key in allKeys) {
        id  value = [dictionary objectForKey:key];
        PropertyInfo *inf = [[PropertyInfo alloc]init];
        if ([value isKindOfClass:[NSNull class]]) {
            [inf setType:PropertyTypeString key:key];
        }
        else if ([value isKindOfClass:[NSNumber class]]) {
            NSNumber *nValue = value;
            if (strcmp([nValue objCType], @encode(int)) == 0||strcmp([nValue objCType], @encode(long)) == 0) {
                //整形
                [inf setType:PropertyTypeInteger key:key];
            }
            else if (strcmp([nValue objCType], @encode(float)) == 0)
            {
                [inf setType:PropertyTypeFloat key:key];
            }
            else if (strcmp([nValue objCType], @encode(double)) == 0 )
            {
                [inf setType:PropertyTypeDouble key:key];
            }
        }
        else if([value isKindOfClass:[NSString class]])
        {
            [inf setType:PropertyTypeString key:key];
        }
        else if([value isKindOfClass:[NSArray class]])
        {
            NSArray *array = value;
            if (array.count > 0) {
                if ([array[0] isKindOfClass:[NSDictionary class]]) {
                    NSString *largeKey = [self lagerKeyWithKey:key];
                    [self autoModelFileWithName:largeKey ClassName:largeKey superModelName:superModelName dictionary:array[0] currentPath:path remarkBlock:^NSDictionary *{
                        
                        NSDictionary * dict = remarkDic[key];
                        if (!dict) {
                            dict = [NSDictionary dictionary];
                        }
                        return dict;
                    }];
                    
                    if (!mjArrayStr) {
                        mjArrayStr = [NSMutableString stringWithFormat:@"\n+(NSDictionary *)objectClassInArray\n{\n\treturn @{"];
                    }
                    if ([mjArrayStr rangeOfString:key].location == NSNotFound) {
                        [mjArrayStr appendFormat:@"@\"%@\":@\"%@\",",key,largeKey];
                    }
                }
            }
            [inf setType:PropertyTypeArray key:key];
        }
        else if([value isKindOfClass:[NSDictionary class]])
        {
            NSString *largeKey = [self lagerKeyWithKey:key];
            [modelFile_h.importStr appendFormat:@"#import \"%@.h\"",largeKey];
            [self autoModelFileWithName:largeKey ClassName:largeKey superModelName:superModelName dictionary:value currentPath:path remarkBlock:^NSDictionary *{
                
                NSDictionary * dict = remarkDic[key];
                if (!dict) {
                    dict = [NSDictionary dictionary];
                }
                return dict;
            }];
            [inf setPropertyWithClassName:largeKey key:key];
        }
        
        NSString * remark = @"";
        if (remarkDic) {
            
            if (![remarkDic[key] isKindOfClass:[NSString class]])
            {
                remark = remarkDic[[key stringByAppendingString:@"_remark"]];

            }else
            {
                remark = remarkDic[key];
            }
            
            if (remark) {
                if ([inf.propertyStr hasSuffix:@"\n"]) {
                  inf.propertyStr =  [inf.propertyStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                }
                NSString * propertyStr = [NSString stringWithFormat:@"%@//%@\n",inf.propertyStr,remark];
                [modelFile_h.propertyStr appendStringSafe:propertyStr] ;
            }else
            {
                [modelFile_h.propertyStr  appendStringSafe:inf.propertyStr];
            }
        }else
        {
            [modelFile_h.propertyStr  appendStringSafe:inf.propertyStr];
        }
    
        [descrptionHead appendStringSafe:inf.descriptionHead];
        [descrptionTail appendStringSafe:inf.descriptionTail];
        
        [decodeStr appendStringSafe:inf.decodeStr];
        [encodeStr appendStringSafe:inf.encodeStr];
        if ([allKeys indexOfObject:key]!=allKeys.count-1) {
            [descrptionHead appendFormat:@","];
            [descrptionTail appendFormat:@","];
        }
    }
    
    [encodeStr appendFormat:@"\n}\n"];
    [decodeStr appendFormat:@"\n\t}\n\treturn self;\n}\n"];
    
    [descrptionHead appendFormat:@"}\","];
    [descrptionTail appendFormat:@"];\n}\n"];
    
    [mjArrayStr deleteCharactersInRange:NSMakeRange(mjArrayStr.length-1, 1)];
    [mjArrayStr appendString:@"};\n}\n"];
    
    //coding
    [modelFile_m.methodStr appendStringSafe:decodeStr];
    [modelFile_m.methodStr appendStringSafe:encodeStr];
    [modelFile_m.methodStr appendString:@"\n-(void)setValue:(id)value forUndefinedKey:(NSString *)key \n{ \n\n}"];
    
    
    //descprtoins
    [modelFile_m.methodStr appendFormat:@"\n%@%@",descrptionHead,descrptionTail];
    
    //mjArray
    if (mjArrayStr) {
        [modelFile_m.methodStr appendStringSafe:mjArrayStr];
    }
    
    [self saveWithName:fileName forModel_h:modelFile_h forModel_m:modelFile_m path:path];
#endif
}



+(NSData *)dataContentForModel_h:(ClassFileInfo*)model_h;
{
    NSString *string = [NSString stringWithFormat:@"%@\n%@\n%@\n%@%@\n@end",model_h.headStr,model_h.importStr,model_h.define,model_h.methodStr,model_h.propertyStr];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

+(NSData *)dataContentForModel_m:(ClassFileInfo*)model_m;
{
    NSString *string = [NSString stringWithFormat:@"%@%@%@%@%@\n@end",model_m.headStr,model_m.importStr,model_m.define,model_m.methodStr,model_m.propertyStr];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

+(void)saveWithName:(NSString *)name forModel_h:(ClassFileInfo*)model_h forModel_m:(ClassFileInfo*)model_m path:(NSString*)path
{
    NSData *data_h = [self dataContentForModel_h:model_h];
    NSData *data_m = [self dataContentForModel_h:model_m];

    NSString * currentPath_h = [self currentModel_hPathWithName:name path:path];
    NSString * currentPath_m = [self currentModel_mPathWithName:name path:path];

    [self fileWriteWithData:data_h path:currentPath_h];
    [self fileWriteWithData:data_m path:currentPath_m];
}


+(void)fileWriteWithData:(NSData*)data path:(NSString*)path
{
    BOOL has =  [[NSFileManager defaultManager]fileExistsAtPath:path isDirectory:nil];
    if (has==NO) {
        [[NSFileManager defaultManager]createFileAtPath:path contents:nil attributes:nil];
    }else
    {
        [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
        [[NSFileManager defaultManager]createFileAtPath:path contents:nil attributes:nil];
    }
    
    [data writeToFile:path atomically:YES];
}


+(NSString*)currentModel_hPathWithName:(NSString*)name path:(NSString*)path
{
    if (path==nil) {
        return [NSString stringWithFormat:@"%s",__FILE__];
    }
    NSString * currentPath = path;
    NSArray * pathArr = [currentPath componentsSeparatedByString:@"/"] ;
    NSString * lastName = [pathArr lastObject]?[pathArr lastObject]:@"";
    NSString * modelGroup_Path = [currentPath stringByReplacingOccurrencesOfString:lastName withString:@"Model"];
    
   BOOL has = [[NSFileManager defaultManager]fileExistsAtPath:modelGroup_Path];
    if (has==NO) {
        [[NSFileManager defaultManager]createDirectoryAtPath:modelGroup_Path withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    currentPath = [currentPath stringByReplacingOccurrencesOfString:lastName withString:@""];
    NSString * newPath_h =   [currentPath stringByAppendingString:[NSString stringWithFormat:@"Model/%@.h",name]] ;

    NSLog(@"newPath_h----%@",newPath_h);
    return newPath_h;
}

+(NSString*)currentModel_mPathWithName:(NSString*)name path:(NSString*)path
{
    if (path==nil) {
        return [NSString stringWithFormat:@"%s",__FILE__];
    }
    NSString * currentPath = path;
    NSArray * pathArr = [currentPath componentsSeparatedByString:@"/"] ;
    NSString * lastName = [pathArr lastObject]?[pathArr lastObject]:@"";
    NSString * modelGroup_Path = [currentPath stringByReplacingOccurrencesOfString:lastName withString:@"Model"];
    
    BOOL has = [[NSFileManager defaultManager]fileExistsAtPath:modelGroup_Path];
    if (has==NO) {
        [[NSFileManager defaultManager]createDirectoryAtPath:modelGroup_Path withIntermediateDirectories:NO attributes:nil error:nil];
    }
   currentPath = [currentPath stringByReplacingOccurrencesOfString:lastName withString:@""];
    NSString * newPath_m =   [currentPath stringByAppendingString:[NSString stringWithFormat:@"Model/%@.m",name]] ;
    
    NSLog(@"newPath_m----%@",newPath_m);
    return newPath_m;
}

+(NSString *)lagerKeyWithKey:(NSString *)key
{
    char p = [key characterAtIndex:0];
    char P = p;
    if (p >= 97) {
        P = p - 32;
    }
    NSString *largeKey = [key stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c",p] withString:[NSString stringWithFormat:@"%c",P] options:0 range:NSMakeRange(0, 1)];
    return largeKey;
}

@end

@implementation ClassFileInfo



@end;

@implementation PropertyInfo
-(void)setPropertyWithClassName:(NSString *)className key:(NSString *)key
{
    NSString * propertyStr = [NSString stringWithFormat:@"@property (nonatomic,strong) %@ *%@;\n",className,key];
    NSString * formatKey = @"%@";
    NSString * decodeMethod = @"decodeObjectForKey:";
    NSString * encodeMethod = @"encodeObject:";
    
    NSString *desHead = [NSString stringWithFormat:@"%@:%@",key,formatKey];
    NSString *desTail = [NSString stringWithFormat:@"_%@",key];
    NSString *decodeStr = [NSString stringWithFormat:@"\n\t\tself.%@ = [aDecoder %@@\"%@\"];",key,decodeMethod,key];
    NSString *encodeStr = [NSString stringWithFormat:@"\n\t[aCoder %@_%@ forKey:@\"%@\"];",encodeMethod,key,key];
    
    self.descriptionHead = desHead;
    self.descriptionTail = desTail;
    self.decodeStr = decodeStr;
    self.encodeStr = encodeStr;
    self.propertyStr = propertyStr;
}

-(void)setType:(PropertyType)type key:(NSString *)key
{
    NSString *propertyStr = nil;
    NSString *formatKey = nil;
    NSString *encodeMethod = nil;
    NSString *decodeMethod = nil;
    switch (type) {
        case PropertyTypeInteger: {
            propertyStr = [NSString stringWithFormat:@"@property (nonatomic,assign) NSInteger %@;\n",key];
            formatKey = @"%ld";
            decodeMethod = @"decodeIntegerForKey:";
            encodeMethod = @"encodeInteger:";
            break;
        }
        case PropertyTypeFloat: {
            propertyStr = [NSString stringWithFormat:@"@property (nonatomic,assign) CGFloat %@;\n",key];
            formatKey = @"%lf";
            decodeMethod = @"decodeFloatForKey:";
            encodeMethod = @"encodeFloat:";
            break;
        }
        case PropertyTypeDouble: {
            propertyStr = [NSString stringWithFormat:@"@property (nonatomic,assign) CGFloat %@;\n",key];
            formatKey = @"%lf";
            decodeMethod = @"decodeDoubleForKey:";
            encodeMethod = @"encodeDouble:";
            break;
        }
        case PropertyTypeString: {
            propertyStr = [NSString stringWithFormat:@"@property (nonatomic,copy  ) NSString *%@;\n",key];
            formatKey = @"%@";
            decodeMethod = @"decodeObjectForKey:";
            encodeMethod = @"encodeObject:";
            break;
        }
        case PropertyTypeArray: {
            propertyStr = [NSString stringWithFormat:@"@property (nonatomic,copy  ) NSArray *%@;\n",key];
            formatKey = @"%@";
            decodeMethod = @"decodeObjectForKey:";
            encodeMethod = @"encodeObject:";
            break;
        }
        case PropertyTypeDictionary: {
            break;
        }
        default: {
            break;
        }
    }
    NSString *desHead = [NSString stringWithFormat:@"%@:%@",key,formatKey];
    NSString *desTail = [NSString stringWithFormat:@"_%@",key];
    NSString *decodeStr = [NSString stringWithFormat:@"\n\t\tself.%@ = [aDecoder %@@\"%@\"];",key,decodeMethod,key];
    NSString *encodeStr = [NSString stringWithFormat:@"\n\t[aCoder %@_%@ forKey:@\"%@\"];",encodeMethod,key,key];
    
    self.descriptionHead = desHead;
    self.descriptionTail = desTail;
    self.decodeStr = decodeStr;
    self.encodeStr = encodeStr;
    self.propertyStr = propertyStr;
}

@end

