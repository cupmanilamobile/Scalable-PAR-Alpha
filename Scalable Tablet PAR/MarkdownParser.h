//
//  MarkdownParser.h
//  Scalable-Table-PAR
//
//  Created by Julius Lundang on 3/26/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarkdownParser : NSObject

- (NSAttributedString *)parseMarkdown:(NSString *)md;

@end
