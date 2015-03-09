//
//  Issue.m
//  TutorialBase
//
//  Created by Julius Lundang on 3/6/15.
//
//

#import "Issue.h"

@implementation Issue

@dynamic componentId;
@dynamic journalId;
@dynamic title;
@dynamic volumeId;
@dynamic issueId;
@dynamic seriesId;
@dynamic displayOrder;
@dynamic approved;
@dynamic circulationDate;
@dynamic issueTitle;
@dynamic displayText;
@dynamic isbn;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"Issue";
}

@end
