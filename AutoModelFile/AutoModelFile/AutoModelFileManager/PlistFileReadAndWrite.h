//
//  PlistFileReadAndWrite.h
//  test2
//
//  Created by sunwf on 2017/11/27.
//  Copyright © 2017年 sunwf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlistFileReadAndWrite : NSObject

-(void)savePlistFileWithName:(NSString*)name hFilePath:(NSString*)hFilePath mFilePath:(NSString*)mFilePath;

@end
