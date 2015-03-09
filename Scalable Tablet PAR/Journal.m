//
//  Journal.m
//  TutorialBase
//
//  Created by Julius Lundang on 3/6/15.
//
//

#import "Journal.h"
#import <Parse/PFObject+Subclass.h>

@implementation Journal

@dynamic description;
@dynamic componentId;
@dynamic journalId;
@dynamic title;
@dynamic editor;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"Journal";
}

@end