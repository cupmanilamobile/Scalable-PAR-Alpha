//
//  ArticleType.h
//  TutorialBase
//
//  Created by Julius Lundang on 3/6/15.
//
//

#import <Parse/Parse.h>

@interface ArticleType : PFObject<PFSubclassing>
+ (NSString *)parseClassName;

@property (retain) NSString *description;
@property (retain) NSString *category;
@property (retain) NSString *articleTypeId;

@end
