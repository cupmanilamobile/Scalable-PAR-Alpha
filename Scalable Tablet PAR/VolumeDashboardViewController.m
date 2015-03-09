//
//  VolumeDashboardViewController.m
//  Scalable Tablet PAR
//
//  Created by cvflores on 2/20/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "VolumeDashboardViewController.h"
#import "Misc.h"
#import "VolumeCover.h"
#import "ArticleAggregatorViewController.h"

#define API_GET_JOURNAL_DETAILS_URL @"http://192.168.242.119:8080/release-15.1.PAR/journal/PAR"
#define API_GET_ISSUES_BY_VOLUME_ID_URL @"http://192.168.242.119:8080/release-15.1.PAR/journal/PAR/%@"

@interface VolumeDashboardViewController ()

@end

@implementation VolumeDashboardViewController {
    BOOL pageControlBeingUsed;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.volumeContainerScrollView setDelegate:self];
    
    [Misc downloadingServerImageFromUrl:self.latestVolumeCover AndUrl:@"http://journals.cambridge.org/cover_images/PAR/PAR.jpg"];
    // Do any additional setup after loading the view.
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:API_GET_JOURNAL_DETAILS_URL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError* jsonError = nil;
        NSDictionary *journalDetailsDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        NSDictionary *volumeDictionary = [journalDetailsDictionary objectForKey:@"volumes"][0];
        NSString *latestVolumeId = [volumeDictionary objectForKey:@"volumeId"];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:API_GET_ISSUES_BY_VOLUME_ID_URL, latestVolumeId]];
        NSData *issueData = [NSData dataWithContentsOfURL:url];
        _issueList = [NSJSONSerialization JSONObjectWithData:issueData options:0 error:&jsonError];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // self.description.text =[self.journalDetails objectForKey:@"description"];
            [self setVolumesInContainer];
        });
    }] resume];
    
    
//    VolumeCover* volumeCoverTry = [[VolumeCover alloc] initWithFrame:CGRectMake(0, 0, 300,300)];
//    [self.view addSubview:volumeCoverTry];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setVolumesInContainer {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(issueTap:)];
    self.latestVolumeLabel.text   = [NSString stringWithFormat:@"Issue %@",[[_issueList lastObject] objectForKey:@"issueId"]];

    int volumeIndex= 0;
    for (int i = 0; i < _issueList.count; i++) {
        volumeIndex = volumeIndex - (volumeIndex >= 8 ? 8 : 0);
        [self.volumeContainerScrollView addSubview:[self createVolumeCover:i volumeIndex:volumeIndex]];
        volumeIndex++;
    }
    
    self.volumeContainerScrollView.contentSize  = CGSizeMake(self.volumeContainerScrollView.frame.size.width * (int)roundf(_issueList.count/8.0f), self.volumeContainerScrollView.frame.size.height );
    self.volumePageControl.numberOfPages =self.volumeContainerScrollView.contentSize.width  / self.volumeContainerScrollView.frame.size.width;
    [self loadVolumesForPage:0];
}

- (VolumeCover *)createVolumeCover:(int)i volumeIndex:(int)volumeIndex {
    CGFloat volumeX = 10, volumeY = 10;
    VolumeCover* volumeCover;

    volumeY = (volumeIndex/4) * 300;
    volumeX = 24+((i-1)/8) * self.volumeContainerScrollView.frame.size.width + (volumeIndex %4) * 180;
    volumeCover = [[VolumeCover alloc] initWithFrame:CGRectMake(volumeX, volumeY, 160, 275)];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(issueTap:)];
    [volumeCover addGestureRecognizer:singleTap];
    
    volumeCover.tag  = [[_issueList[i] objectForKey:@"issueId"] integerValue];
    volumeCover.volumeLabel.text = [NSString stringWithFormat:@"Volume %ld",(long)volumeCover.tag];
    return volumeCover;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.volumeContainerScrollView.frame.size.width;
    int page = floor((self.volumeContainerScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.volumePageControl.currentPage = page;
    [self loadVolumesForPage:(int)self.volumePageControl.currentPage+1];

}

// update the scroll view to the appropriate page
- (IBAction)changePage {
    CGRect frame;
    frame.origin.x = self.volumeContainerScrollView.frame.size.width * self.volumePageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.volumeContainerScrollView.frame.size;
    [self.volumeContainerScrollView scrollRectToVisible:frame animated:YES];
}

- (void)loadVolumesForPage:(int) page{
    NSArray* volumes = self.issueList;
    
    
    NSMutableString *url =[[NSMutableString alloc] initWithString: @"http://cjotest-2.uat.cambridge.org/cover_images/PAR/PARxxx_yyy.jpg"];
    int end = page * 8 + 9;
    if(self.issueList.count < end){
        end = self.issueList.count;
    }
    VolumeCover* volumeCover;
    
    NSDictionary* volume;
    NSInteger volumeTag;
 
    for(int i = page*8; i<end;i++){
        
        
        
        volume = [volumes objectAtIndex:i];
        volumeTag = [[volume objectForKey:@"volumeId"] integerValue];
        volumeCover =  (VolumeCover*) [self.volumeContainerScrollView viewWithTag: volumeTag];

        [Misc downloadingServerImageFromUrl:volumeCover.CoverImage  AndUrl:[[NSString alloc] initWithFormat:@"http://cjotest-2.uat.cambridge.org/cover_images/PAR/PAR%ld_%@.jpg",self.volumeId,[volume objectForKey:@"issueId"]]];
        

        
    }
    
    
    
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}
-(void)issueTap:(id) sender{
    NSLog(@"single Tap on imageview");
   
    //volumeSearchString = @"displayIssue?iid=9260343";
    //selectedVolume = 141;
    
    [self performSegueWithIdentifier:@"articleAggregator" sender:sender];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"articleAggregator"])
    {
        
        ArticleAggregatorViewController* nextVC = [segue destinationViewController];
        VolumeCover* volumeCover = (VolumeCover*) [(UIGestureRecognizer *)sender view];
        nextVC.volumeId = self.volumeId;
        nextVC.issueId = volumeCover.tag;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
