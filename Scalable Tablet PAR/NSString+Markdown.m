//
//  NSString+ReplaceRegEx.m
//  Scalable-Table-PAR
//
//  Created by Julius Lundang on 3/26/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "NSString+Markdown.h"

@implementation NSString (Markdown)

/**
 * Replaces tags to replace with Markdown syntax
 * @param regex Regular expression pattern
 * @returns NSString
 */
- (NSString *)stringByReplacingOccurencesOfRegEx:(NSString *)regexPattern
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPattern options:NSRegularExpressionCaseInsensitive error:&error];

    __block NSString *template = @"";

    void (^selectedCase)() = @{
                               @"<(/)?italic>" : ^{
                                   template = @"*";
                               },
                               @"bar" : ^{
                                   NSLog(@"bar");
                               },
                               @"baz" : ^{
                                   NSLog(@"baz");
                               },
                               }[regexPattern];
    
    selectedCase();
    NSString *modifiedString = [regex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:template];
    return modifiedString;
}

/**
 * Replaces tags to empty string
 * @param regex Regular expression pattern
 * @returns NSString
 */
- (NSString *)stringByStrippingHTML {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<[^>]*[^(italic)]>" options:NSRegularExpressionCaseInsensitive error:&error];
    return [regex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:@""];
}

@end
