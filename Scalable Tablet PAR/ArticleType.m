//
//  ArticleType.m
//  TutorialBase
//
//  Created by Julius Lundang on 3/6/15.
//
//

#import "ArticleType.h"

@implementation ArticleType

@dynamic description;
@dynamic category;
@dynamic articleTypeId;

+ (void)load
{
    [self registerSubclass];
}
+ (NSString *)parseClassName
{
    return @"ArticleType";
}
@end
