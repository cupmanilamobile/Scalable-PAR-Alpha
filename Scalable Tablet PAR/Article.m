//
//  Article.m
//  TutorialBase
//
//  Created by Julius Lundang on 3/6/15.
//
//

#import "Article.h"

@implementation Article
@dynamic status;
@dynamic componentId;
@dynamic journalId;
@dynamic title;
@dynamic volumeId;
@dynamic issueId;
@dynamic seriesId;
@dynamic fileId;
@dynamic dispart;
@dynamic doi;
@dynamic publishedOnlineDate;
@dynamic itemNo;
@dynamic firstPage;
@dynamic lastPage;
@dynamic topic;
@dynamic copyrightStatement;
@dynamic pageCount;
@dynamic displayOrder;
@dynamic published;
@dynamic approved;
@dynamic articleType;
@dynamic authors;

+ (void)load
{
    [self registerSubclass];
}
+ (NSString *)parseClassName
{
    return @"Article";
}
@end
