//
//  Author.m
//  TutorialBase
//
//  Created by Julius Lundang on 3/6/15.
//
//

#import "Author.h"

@implementation Author

@dynamic surname;
@dynamic forename;

+(void)load
{
    [self registerSubclass];
}

+(NSString *)parseClassName
{
    return @"Author";
}

@end
