//
//  LZTFlowerPassword.h
//  FlowerPassword
//
//  Created by xLsDg on 14-8-16.
//  Copyright (c) 2014年 Xiao Lu Software Development Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZTFlowerPassword : NSObject

- (NSString *)calcWithPassword:(NSString *)password
                           key:(NSString *)key;

- (NSString *)getCode;

- (id)initWithPassword:(NSString *)password
                   key:(NSString *)key;

@property (nonatomic, copy)NSString *password;
@property (nonatomic, copy)NSString *key;
@property (nonatomic, copy)NSString *code;

@end
