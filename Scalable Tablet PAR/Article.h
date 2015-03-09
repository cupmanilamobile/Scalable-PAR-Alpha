//
//  Article.h
//  TutorialBase
//
//  Created by Julius Lundang on 3/6/15.
//
//

#import <Parse/Parse.h>
#import "ArticleType.h"

@interface Article : PFObject<PFSubclassing>
+(NSString *)parseClassName;

@property (retain) NSString *status;
@property int componentId;
@property (retain) NSString *journalId;
@property (retain) NSString *title;
@property (retain) NSString *volumeId;
@property (retain) NSString *issueId;
@property (retain) NSString *seriesId;
@property (retain) NSString *fileId;
@property (retain) NSString *dispart;
@property (retain) NSString *doi;
@property (retain) NSDate *publishedOnlineDate;
@property (retain) NSString *itemNo;
@property int firstPage;
@property int lastPage;
@property (retain) NSString *topic;
@property (retain) NSString *copyrightStatement;
@property int pageCount;
@property (retain) NSString *displayOrder;
@property BOOL published;
@property BOOL approved;
@property (retain) ArticleType *articleType;
@property (retain) NSMutableArray *authors;

@end
