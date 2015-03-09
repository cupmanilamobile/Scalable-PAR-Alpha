//
//  Author.h
//  TutorialBase
//
//  Created by Julius Lundang on 3/6/15.
//
//

#import <Parse/Parse.h>

@interface Author : PFObject<PFSubclassing>
+ (NSString *)parseClassName;

@property (retain) NSString *surname;
@property (retain) NSString *forename;

@end
