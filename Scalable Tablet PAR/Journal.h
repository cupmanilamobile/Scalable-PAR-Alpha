//
//  Journal.h
//  TutorialBase
//
//  Created by Julius Lundang on 3/6/15.
//
//

#import <Parse/Parse.h>

@interface Journal : PFObject<PFSubclassing>
+ (NSString *)parseClassName;

@property (retain) NSString *description;
@property int componentId;
@property (retain) NSString *journalId;
@property (retain) NSString *title;
@property (retain) NSString *editor;

@end
