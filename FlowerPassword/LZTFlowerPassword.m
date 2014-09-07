//
//  LZTFlowerPassword.m
//  FlowerPassword
//
//  Created by xLsDg on 14-8-16.
//  Copyright (c) 2014年 Xiao Lu Software Development Group. All rights reserved.
//

#import "LZTFlowerPassword.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation LZTFlowerPassword


- (NSString *)calcHmacWithMessage:(NSString *)message
                              key:(NSString *)key
                         encoding:(NSStringEncoding)encoding
                        algorithm:(CCHmacAlgorithm)algorithm
                     digestLength:(NSInteger)digestLength
{
    const char *cKey = [key cStringUsingEncoding:encoding];
    const char *cMessage = [message cStringUsingEncoding:encoding];
    unsigned char result[digestLength];

    CCHmac(algorithm, cKey, strlen(cKey), cMessage, strlen(cMessage), result);

    NSMutableString *ret = [NSMutableString stringWithCapacity:digestLength * 2];

    for (NSInteger i = 0; i < digestLength; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }

    return ret;
}

- (NSString *)calcHmacMD5WithPassword:(NSString *)password
                                  key:(NSString *)key
                             encoding:(NSStringEncoding)encoding
{
    return [self calcHmacWithMessage:password
                                 key:key
                            encoding:encoding
                           algorithm:kCCHmacAlgMD5
                        digestLength:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)calcHmacMD5WithPassword:(NSString *)password
                                  key:(NSString*)key
{
    return [self calcHmacMD5WithPassword:password
                                     key:key
                                encoding:NSUTF8StringEncoding];
}

- (NSString *)calcWithPassword:(NSString *)password
                           key:(NSString *)key
{
    NSString *md5one = [self calcHmacMD5WithPassword:password
                                                 key:key];

    NSString *md5two = [self calcHmacMD5WithPassword:md5one
                                                 key:@"snow"];

    NSString *md5three = [self calcHmacMD5WithPassword:md5one
                                                   key:@"kise"];

    NSString *rule = [NSString stringWithString:md5three];
    NSMutableString *source = [NSMutableString stringWithString:md5two];

    for (NSUInteger i = 0; i < 32; i++) {
        unichar chSource = [source characterAtIndex:i];

        if (chSource < '0' || '9' < chSource) {
            NSString *str = @"sunlovesnow1990090127xykab";
            unichar chRule = [rule characterAtIndex:i];
            NSString *strRule = [NSString stringWithCharacters:&chRule
                                                        length:1];

            if ([str rangeOfString:strRule
                           options:NSLiteralSearch].location != NSNotFound) {
                NSString *strSource = [NSString stringWithCharacters:&chSource
                                                              length:1];

                [source replaceCharactersInRange:NSMakeRange(i, 1)
                                      withString:[strSource uppercaseString]];
            }
        }
    }

    unichar ch0Source = [source characterAtIndex:0];

    if ('0' <= ch0Source && ch0Source <= '9') {
        [source replaceCharactersInRange:NSMakeRange(0, 1)
                              withString:@"K"];
    }

    self.code = [source substringToIndex:16];
    return self.code;
}

- (NSString *)getCode {
    return [self calcWithPassword:self.password key:self.key];
}

- (id)initWithPassword:(NSString *)password
                   key:(NSString *)key
{
    if (self = [super init]) {
        self.password = password;
        self.key = key;
        self.code = [self getCode];
    }
    
    return self;
}

@end
