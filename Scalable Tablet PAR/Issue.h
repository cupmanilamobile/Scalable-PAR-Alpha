//
//  Issue.h
//  TutorialBase
//
//  Created by Julius Lundang on 3/6/15.
//
//

#import <Parse/Parse.h>

@interface Issue : PFObject<PFSubclassing>
+ (NSString *)parseClassName;

@property int componentId;
@property (retain) NSString *journalId;
@property (retain) NSString *title;
@property (retain) NSString *volumeId;
@property (retain) NSString *issueId;
@property (retain) NSString *seriesId;
@property (retain) NSString *displayOrder;
@property BOOL approved;
@property (retain) NSDate *circulationDate;
@property (retain) NSString *issueTitle;
@property (retain) NSString *displayText;
@property (retain) NSString *isbn;

@end
