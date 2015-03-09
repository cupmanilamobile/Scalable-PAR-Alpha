//
//  Volume.m
//  TutorialBase
//
//  Created by Julius Lundang on 3/6/15.
//
//

#import "Volume.h"

@implementation Volume

@dynamic inUse;
@dynamic circulationDate;
@dynamic componentId;
@dynamic journalID;
@dynamic approved;
@dynamic volumeId;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"Volume";
}

@end
//PFQuery *query = [Volume query];
//__block Volume *vol = (Volume *) [query getObjectWithId:@"mlyqJzoc1i"];
//AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//NSString *apiUrl = [NSString stringWithFormat:@"http://192.168.242.119:8080/release-15.1.PAR/journal/PAR/%@", @1];
//[manager GET:apiUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//    NSMutableArray *issues = [NSMutableArray array];
//    [responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
//        Issue *issue = [Issue object];
//        issue.componentId = [[obj objectForKey:@"componentId"] intValue];
//        issue.journalId = [obj objectForKey:@"journalId"];
//        issue.title = [obj objectForKey:@"title"];
//        issue.volumeId = [obj objectForKey:@"volumeId"];
//        issue.issueId = [obj objectForKey:@"issueId"];
//        issue.seriesId = [obj objectForKey:@"seriesId"];
//        issue.displayOrder = [obj objectForKey:@"displayOrder"];
//        issue.approved = [[obj objectForKey:@"approved"] isEqualToString:@"Y"] ? YES : NO;
//        NSString *strDate = [obj objectForKey:@"circulationDate"];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];
//        NSDate *circulationDate = [formatter dateFromString:strDate];
//        issue.circulationDate = circulationDate;
//        issue.issueTitle = [obj objectForKey:@"issueTitle"];
//        issue.isbn = [obj objectForKey:@"isbn"];
//        [issues addObject:issue];
//    }];
//    [PFObject saveAllInBackground:issues block:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//            PFRelation *relation = [vol relationForKey:@"issues"];
//            [issues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
//                [relation addObject:obj];
//            }];
//            [vol saveInBackground];
//        }
//    }];
//} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    NSLog(@"Error %@", error);
//}];