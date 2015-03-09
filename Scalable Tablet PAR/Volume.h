//
//  Volume.h
//  TutorialBase
//
//  Created by Julius Lundang on 3/6/15.
//
//

#import <Parse/Parse.h>

@interface Volume : PFObject<PFSubclassing>
+ (NSString *)parseClassName;

@property int inUse;
@property (retain) NSDate *circulationDate;
@property int componentId;
@property (retain) NSString *journalID;
@property BOOL approved;
@property (retain) NSString *volumeId;

@end
