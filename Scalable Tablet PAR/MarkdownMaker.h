//
//  MarkdownMaker.h
//  Scalable-Table-PAR
//
//  Created by Julius Lundang on 3/26/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface MarkdownMaker : NSObject

@property (nonatomic, strong) GDataXMLDocument *document;
@property (nonatomic, strong) NSDictionary *affiliations;

+ (id)sharedManager;
- (NSString *)convertAbstractDataToMarkdown:(NSData *)data;

@end
