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

@interface VolumeDashboardViewController ()

@end


@implementation VolumeDashboardViewController

BOOL pageControlBeingUsed;
- (void)viewDidLoad {
    [super viewDidLoad];

    [Misc downloadingServerImageFromUrl:self.latestVolumeCover AndUrl:@"http://journals.cambridge.org/cover_images/PAR/PAR.jpg"];
    // Do any additional setup after loading the view.
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:    [NSString stringWithFormat:@"http://localhost:8080/release-15.1.PAR/journal/PAR/%ld/",self.volumeId ]]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                NSError* jsonError = nil;
                self.issueList = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError] ;
                NSLog(@"obj: %@ ; error: %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], error);
                // Log the decoded object, and the error if any
               // [self.journalDetails objectForKey:@"description"];
//                NSLog(@"done loading");
//                NSLog(@"%@",[self.volumeDetails objectForKey:@"description"]);
                dispatch_async(dispatch_get_main_queue(), ^{
                  //  self.description.text =[self.journalDetails objectForKey:@"description"];
                    ;
                    
                    [self setVolumesInContainer];
                });
            }] resume];
    
  //  VolumeCover* volumeCoverTry = [[VolumeCover alloc] initWithFrame:CGRectMake(0, 0, 300,300)];
 //   [self.view addSubview:volumeCoverTry];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setVolumesInContainer{
      
    NSArray* volumes = self.issueList;
    CGFloat volumeX = 10;
    CGFloat volumeY = 10;
    int volumeIndex= 0;
    NSDictionary* volume;
    VolumeCover* volumeCover;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(issueTap:)];
    self.latestVolumeLabel.text   = [NSString stringWithFormat:@"Issue %ld",(long)[[[volumes lastObject] objectForKey:@"issueId"] integerValue]];
    for(int i = 0 ; i>volumes.count;i++){
        if(volumeIndex>=8){
            volumeIndex-=8;
        }
        volumeX = 24+((i-1)/8) * self.volumeContainerScrollView.frame.size.width + (volumeIndex %4) * 180;
        volumeY = (volumeIndex/4) * 300;

     
        volume = [volumes objectAtIndex:i];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(issueTap:)];
        
        
         volumeCover = [[VolumeCover alloc] initWithFrame:CGRectMake(volumeX, volumeY, 160, 275)];
        [volumeCover addGestureRecognizer:singleTap];
         volume = [volumes objectAtIndex:i];
        
//        [url replaceOccurrencesOfString:@"xxx" withString:[volume objectForKey:@"volumeId"] options:NSLiteralSearch range: NSMakeRange(0, [url length])];
//        [Misc downloadingServerImageFromUrl:volumeCover  AndUrl:url];
//        
//        NSLog(@"url:%@",url);
//        [url replaceOccurrencesOfString:[volume objectForKey:@"volumeId"] withString: @"xxx" options:NSLiteralSearch range: NSMakeRange(0, [url length])];
//        NSLog(@"url:%@",url);
        volumeCover.tag  = [[volume objectForKey:@"issueId"] integerValue];

        volumeCover.volumeLabel.text = [NSString stringWithFormat:@"Volume %ld",(long)volumeCover.tag];
        
        
        [self.volumeContainerScrollView addSubview:volumeCover];
        volumeIndex++;
        
}
    
   
    
    self.volumeContainerScrollView.contentSize  = CGSizeMake(self.volumeContainerScrollView.frame.size.width * (int)roundf(volumes.count/8.0f), self.volumeContainerScrollView.frame.size.height );
    NSLog(@"%d",160 * 4 * (int)roundf(volumes.count/8.0f));
    
    self.volumePageControl.numberOfPages =self.volumeContainerScrollView.contentSize.width  / self.volumeContainerScrollView.frame.size.width;
    [self loadVolumesForPage:0];
    [self.volumeContainerScrollView setDelegate:self];


}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.volumeContainerScrollView.frame.size.width;
    int page = floor((self.volumeContainerScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.volumePageControl.currentPage = page;
    [self loadVolumesForPage:(int)self.volumePageControl.currentPage+1];

}
- (IBAction)changePage {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.volumeContainerScrollView.frame.size.width * self.volumePageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.volumeContainerScrollView.frame.size;
    [self.volumeContainerScrollView scrollRectToVisible:frame animated:YES];
    
   // [self loadVolumesForPage:(int)self.volumePageControl.currentPage+1];
    
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
