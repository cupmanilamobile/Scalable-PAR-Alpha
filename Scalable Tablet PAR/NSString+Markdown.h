//
//  NSString+ReplaceRegEx.h
//  Scalable-Table-PAR
//
//  Created by Julius Lundang on 3/26/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Markdown)

- (NSString *)stringByReplacingOccurencesOfRegEx:(NSString *)regex;
- (NSString *)stringByStrippingHTML;
@end