//
//  ArticleAggregatorViewController.m
//  Scalable Tablet App
//
//  Created by cvflores on 1/23/15.
//  Copyright (c) 2015 cvflores. All rights reserved.
//

#import "ArticleAggregatorViewController.h"
#import "AggregatorLayoutView.h"
#import "ArticleViewController.h"
#import "ArticleAggregatorItemView.h"
#import "FullScreenView.h"
#import "Misc.h"
#import "Article.h"


@interface ArticleAggregatorViewController ()

@end
@implementation ArticleAggregatorViewController
@synthesize articleDetails;
UIActivityIndicatorView* loadingActivityView;
int indexOfArticle = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    

    // Do any additional setup after loading the view.
    
  //  self.articleDetails = [NSJSONSerialization JSONObjectWithData:[[self json] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil] ;
    flipper = [[AFKPageFlipper alloc] initWithFrame:self.flipperContainerView.bounds];
    flipper.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//
    // flipper.dataSource = self;
   //   Misc* misc = [[Misc alloc]init];
    //loadingActivityView = [Misc loadActivityView:self.view.bounds.size];
    [self.flipperContainerView addSubview:loadingActivityView];
    [loadingActivityView startAnimating];
    
    //Test
//    self.volumeId = 139;
//    self.issueId = 01;
//
    NSString *pageDetailText = self.pageDetail.text;
    if (!([_pageHeaderText isEqualToString:@"First View"] ||
          [_pageHeaderText isEqualToString:@"Open Access"])) {
        self.pageDetail.text = [NSString stringWithFormat:@"Parasitology Volume %02ld - Issue %02ld" ,self.volumeId,self.issueId];
    } else {
        self.pageDetail.text = _pageHeaderText;
    }
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"registrationbg.jpg"]]];
[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery* articleQuery = [Article query];
    [articleQuery whereKey:@"issueId" equalTo:[NSString stringWithFormat: @"%02ld", (long)self.issueId]];
    [articleQuery whereKey:@"volumeId" equalTo:[NSString stringWithFormat: @"%02ld", (long)self.volumeId]];
    [articleQuery orderByAscending:@"firstPage"];
    [articleQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.articleDetails = objects;
        NSLog(@"done loading");

        dispatch_async(dispatch_get_main_queue(), ^{
            
           //
            // [self.backgroundView removeFromSuperview];
           //  [self.view addSubview: self.backgroundView];
            flipper.dataSource = self;
            [self.flipperContainerView addSubview:flipper];
           [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[self.view addSubview:self.backgroundView ];
            
           
            

            
            
                                       });
    }];
//    NSURLSession *session = [NSURLSession sharedSession];
//    [[session dataTaskWithURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://localhost:8080/release-15.1.PAR/journal/PAR/%02ld/%02ld",(long)self.volumeId,(long)self.issueId]]
//            completionHandler:^(NSData *data,
//                                NSURLResponse *response,
//                                NSError *error) {
//             self.articleDetails = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil] ;
//                NSLog(@"done loading");
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    flipper.dataSource = self;
//
//                    [self.view addSubview:flipper];
//
//                });
//               [loadingActivityView stopAnimating];
//               [loadingActivityView removeFromSuperview];
//                
//            }] resume];
//    
   // flipper.layer.zPosition = 20;
   [ flipper setBackgroundColor:[UIColor clearColor]];
    NSLog(@"http://localhost:8080/release-15.1.PAR/journal/PAR/%02ld/%02ld",(long)self.volumeId,(long)self.issueId);
    [self.flipperContainerView addSubview:flipper];

       }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfPagesForPageFlipper:(AFKPageFlipper *)pageFlipper {
    self.pageNumberLabel.text = [NSString stringWithFormat:@"page 1 of %ld",[self.articleDetails count]/6];
    return [self.articleDetails count]/6;
}


- (UIView *) viewForPage:(NSInteger) page inFlipper:(AFKPageFlipper *) pageFlipper {
 //   PDFRendererView *result = [[[PDFRendererView alloc] initWithFrame:pageFlipper.bounds] autorelease];
 //   result.pdfDocument = pdfDocument;
 //   result.pageNumber = page;
    
    
    self.pageNumberLabel.text = [NSString stringWithFormat:@"page %ld of %ld",page,[self.articleDetails count]/6];
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *myFile = [mainBundle pathForResource: @"articleAggregator" ofType: @"json"];
    
    NSData* data = [NSData dataWithContentsOfFile:myFile];
    
    
    NSString* stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    BOOL isValid = [NSJSONSerialization isValidJSONObject:data];
    
    //  NSDictionary *json = [stringData ];
    
    NSArray* article;
   AggregatorLayoutView * result = [[AggregatorLayoutView alloc] init];
    [result setBackgroundColor:[UIColor blackColor]];
    result.dataSource = self;
    [result initalizeFrame:self.flipperContainerView.frame];
    if(page %4 ==  0){
        indexOfArticle=0;
        [result initalizeViews];
        
     }
    else if(page %4== 1){
        indexOfArticle=0;
        [result initalizeViewsOption2];
        
    }
    else if(page%4 == 2){
        indexOfArticle=4;
        [result initalizeViewsOption3];
        
    }
    else if(page%4 == 3){
        indexOfArticle = 12;
        [result initalizeViewsOption4];
        
    } else {
        indexOfArticle = 20;
        [result initalizeViews];
        
    }

    result.backgroundColor= [UIColor whiteColor];
    return result;
}

-(id)getData:(AggregatorLayoutView *)aggregatorLayoutView{
    return self.articleDetails;
}
-(NSArray*)getArticle{

    if(indexOfArticle<[self.articleDetails count])
    {
         return [self.articleDetails objectAtIndex:indexOfArticle++];
        
    }
    return nil;
}
-(IBAction)purchaseArticle:(id)sender{
    
    [self performSegueWithIdentifier:@"articleView" sender:sender];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"articleView"])
    {
        UIButton* button = (UIButton*) sender;
        FullScreenView* articleItem =(FullScreenView*)button.superview;
     
        ArticleViewController* nextVC  =(ArticleViewController*) segue.destinationViewController;
        nextVC.articleLink = [NSString stringWithFormat:@"%ld", button.superview.tag ];
        nextVC.articleTitle=articleItem.articleTitle.text;
    }
}


-(NSString*) json
{
    return @"[{\"title\":\"Emerging paradigms in anti-infective drug design \",\"journalId\":\"PAR\",\"componentId\":9137288,\"displayOrder\":null,\"authors\":null,\"volumeId\":141,\"issueId\":\"01\",\"fileId\":\"S0031182013001224\",\"forthcoming\":\"N\",\"dispart\":\"Preface\",\"doi\":\"10.1017/S0031182013001224\",\"publishedOnlineDate\":1401206400000,\"itemNo\":null,\"firstPage\":\"1\",\"lastPage\":\"7\",\"seriesId\":\"0\",\"topic\":null,\"copyrightStatement\":\"Copyright © Cambridge University Press 2014 \",\"pageCount\":null},{\"title\":\"The utility of yeast as a tool for cell-based, target-directed high-throughput screening \",\"journalId\":\"PAR\",\"componentId\":9137255,\"displayOrder\":null,\"authors\":null,\"volumeId\":141,\"issueId\":\"01\",\"fileId\":\"S0031182013000425\",\"forthcoming\":\"N\",\"dispart\":null,\"doi\":\"10.1017/S0031182013000425\",\"publishedOnlineDate\":1366732800000,\"itemNo\":null,\"firstPage\":\"8\",\"lastPage\":\"16\",\"seriesId\":\"0\",\"topic\":null,\"copyrightStatement\":\"Copyright © Cambridge University Press 2013 \",\"pageCount\":null},{\"title\":\"An <i>in silico</i> structure-based approach to anti-infective drug discovery \",\"journalId\":\"PAR\",\"componentId\":9137261,\"displayOrder\":null,\"authors\":null,\"volumeId\":141,\"issueId\":\"01\",\"fileId\":\"S0031182013000693\",\"forthcoming\":\"N\",\"dispart\":null,\"doi\":\"10.1017/S0031182013000693\",\"publishedOnlineDate\":1371398400000,\"itemNo\":null,\"firstPage\":\"17\",\"lastPage\":\"27\",\"seriesId\":\"0\",\"topic\":null,\"copyrightStatement\":\"Copyright © Cambridge University Press 2013 \",\"pageCount\":null},{\"title\":\"Target-based drug discovery for human African trypanosomiasis: selection of molecular target and chemical matter \",\"journalId\":\"PAR\",\"componentId\":9137279,\"displayOrder\":6,\"authors\":\"IAN H. GILBERT\",\"volumeId\":141,\"issueId\":\"01\",\"fileId\":\"S0031182013001017\",\"forthcoming\":\"N\",\"dispart\":null,\"doi\":\"10.1017/S0031182013001017\",\"publishedOnlineDate\":1375977600000,\"itemNo\":null,\"firstPage\":\"28\",\"lastPage\":\"36\",\"seriesId\":\"0\",\"topic\":null,\"copyrightStatement\":\"Copyright © Cambridge University Press 2013 The online version of this article is published within an Open Access environment subject to the conditions of the Creative Commons Attribution-NonCommercial-ShareAlike licence <http://creativecommons.org/licenses/by-nc-sa/3.0/>. The written permission of Cambridge University Press must be obtained for commercial re-use.\",\"pageCount\":null},{\"title\":\"<i>N-</i>Myristoyltransferase as a potential drug target in malaria and leishmaniasis \",\"journalId\":\"PAR\",\"componentId\":9137258,\"displayOrder\":null,\"authors\":null,\"volumeId\":141,\"issueId\":\"01\",\"fileId\":\"S0031182013000450\",\"forthcoming\":\"N\",\"dispart\":null,\"doi\":\"10.1017/S0031182013000450\",\"publishedOnlineDate\":1366732800000,\"itemNo\":null,\"firstPage\":\"37\",\"lastPage\":\"49\",\"seriesId\":\"0\",\"topic\":null,\"copyrightStatement\":\"Copyright © Cambridge University Press 2013 \",\"pageCount\":null},{\"title\":\"Novel inhibitors of the <i>Plasmodium falciparum</i> electron transport chain \",\"journalId\":\"PAR\",\"componentId\":9137294,\"displayOrder\":null,\"authors\":null,\"volumeId\":141,\"issueId\":\"01\",\"fileId\":\"S0031182013001571\",\"forthcoming\":\"N\",\"dispart\":null,\"doi\":\"10.1017/S0031182013001571\",\"publishedOnlineDate\":1401206400000,\"itemNo\":null,\"firstPage\":\"50\",\"lastPage\":\"65\",\"seriesId\":\"0\",\"topic\":null,\"copyrightStatement\":\"Copyright © Cambridge University Press 2014 \",\"pageCount\":null},{\"title\":\"Progressing the global antimalarial portfolio: finding drugs which target multiple <i>Plasmodium</i> life stages \",\"journalId\":\"PAR\",\"componentId\":9137264,\"displayOrder\":null,\"authors\":null,\"volumeId\":141,\"issueId\":\"01\",\"fileId\":\"S0031182013000747\",\"forthcoming\":\"N\",\"dispart\":null,\"doi\":\"10.1017/S0031182013000747\",\"publishedOnlineDate\":1370793600000,\"itemNo\":null,\"firstPage\":\"66\",\"lastPage\":\"76\",\"seriesId\":\"0\",\"topic\":null,\"copyrightStatement\":\"Copyright © Cambridge University Press 2013 \",\"pageCount\":null},{\"title\":\"High-throughput decoding of drug targets and drug resistance mechanisms in African trypanosomes \",\"journalId\":\"PAR\",\"componentId\":9137252,\"displayOrder\":null,\"authors\":null,\"volumeId\":141,\"issueId\":\"01\",\"fileId\":\"S0031182013000243\",\"forthcoming\":\"N\",\"dispart\":null,\"doi\":\"10.1017/S0031182013000243\",\"publishedOnlineDate\":1365350400000,\"itemNo\":null,\"firstPage\":\"77\",\"lastPage\":\"82\",\"seriesId\":\"0\",\"topic\":null,\"copyrightStatement\":\"Copyright © Cambridge University Press 2013 \",\"pageCount\":null},{\"title\":\"Determination of antiprotozoal drug mechanisms by metabolomics approaches \",\"journalId\":\"PAR\",\"componentId\":9137267,\"displayOrder\":11,\"authors\":\"DARREN J. CREEK, MICHAEL P. BARRETT\",\"volumeId\":141,\"issueId\":\"01\",\"fileId\":\"S0031182013000814\",\"forthcoming\":\"N\",\"dispart\":null,\"doi\":\"10.1017/S0031182013000814\",\"publishedOnlineDate\":1370361600000,\"itemNo\":null,\"firstPage\":\"83\",\"lastPage\":\"92\",\"seriesId\":\"0\",\"topic\":null,\"copyrightStatement\":\"Copyright © Cambridge University Press 2013 The online version of this article is published within an Open Access environment subject to the conditions of the Creative Commons Attribution licence <http://creativecommons.org/licenses/by/3.0/>.\",\"pageCount\":null},{\"title\":\"Animal models of efficacy to accelerate drug discovery in malaria \",\"journalId\":\"PAR\",\"componentId\":9137276,\"displayOrder\":null,\"authors\":null,\"volumeId\":141,\"issueId\":\"01\",\"fileId\":\"S0031182013000991\",\"forthcoming\":\"N\",\"dispart\":null,\"doi\":\"10.1017/S0031182013000991\",\"publishedOnlineDate\":1371744000000,\"itemNo\":null,\"firstPage\":\"93\",\"lastPage\":\"103\",\"seriesId\":\"0\",\"topic\":null,\"copyrightStatement\":\"Copyright © Cambridge University Press 2013 \",\"pageCount\":null},{\"title\":\"Pharmacokinetics and pharmacodynamics utilizing unbound target tissue exposure as part of a disposition-based rationale for lead optimization of benzoxaboroles in the treatment of Stage 2 Human African Trypanosomiasis \",\"journalId\":\"PAR\",\"componentId\":9137273,\"displayOrder\":14,\"authors\":\"STEPHEN WRING, ERIC GAUKEL, BAKELA NARE, ROBERT JACOBS, BETH BEAUDET, TANA BOWLING, LUKE MERCER, CYRUS BACCHI, NIGEL YARLETT, RYAN RANDOLPH, ROBIN PARHAM, CINDY REWERTS, JACOB PLATNER, ROBERT DON\",\"volumeId\":141,\"issueId\":\"01\",\"fileId\":\"S003118201300098X\",\"forthcoming\":\"N\",\"dispart\":null,\"doi\":\"10.1017/S003118201300098X\",\"publishedOnlineDate\":1378310400000,\"itemNo\":null,\"firstPage\":\"104\",\"lastPage\":\"118\",\"seriesId\":\"0\",\"topic\":null,\"copyrightStatement\":\"Copyright © Cambridge University Press 2013 The online version of this article is published within an Open Access environment subject to the conditions of the Creative Commons Attribution license <http://creativecommons.org/licenses/by/3.0/>.\",\"pageCount\":null},{\"title\":\"Anti-<i>Wolbachia</i> drug discovery and development: safe macrofilaricides for onchocerciasis and lymphatic filariasis \",\"journalId\":\"PAR\",\"componentId\":9137282,\"displayOrder\":13,\"authors\":\"MARK J. TAYLOR, ACHIM HOERAUF, SIMON TOWNSON, BARTON E. SLATKO, STEPHEN A. WARD\",\"volumeId\":141,\"issueId\":\"01\",\"fileId\":\"S0031182013001108\",\"forthcoming\":\"N\",\"dispart\":null,\"doi\":\"10.1017/S0031182013001108\",\"publishedOnlineDate\":1374076800000,\"itemNo\":null,\"firstPage\":\"119\",\"lastPage\":\"127\",\"seriesId\":\"0\",\"topic\":null,\"copyrightStatement\":\"Copyright © Cambridge University Press 2013 The online version of this article is published within an Open Access environment subject to the conditions of the Creative Commons Attribution licence <http://creativecommons.org/licenses/by/3.0/>.\",\"pageCount\":null},{\"title\":\"Antimalarial drug discovery – the path towards eradication \",\"journalId\":\"PAR\",\"componentId\":9137270,\"displayOrder\":15,\"authors\":\"JEREMY N BURROWS, EMILIE BURLOT, BRICE CAMPO, STEPHANIE CHERBUIN, SARAH JEANNERET, DIDIER LEROY, THOMAS SPANGENBERG, DAVID WATERSON, TIMOTHY NC WELLS, PAUL WILLIS\",\"volumeId\":141,\"issueId\":\"01\",\"fileId\":\"S0031182013000826\",\"forthcoming\":\"N\",\"dispart\":null,\"doi\":\"10.1017/S0031182013000826\",\"publishedOnlineDate\":1373990400000,\"itemNo\":null,\"firstPage\":\"128\",\"lastPage\":\"139\",\"seriesId\":\"0\",\"topic\":null,\"copyrightStatement\":\"Copyright © Cambridge University Press 2013 The online version of this article is published within an Open Access environment subject to the conditions of the Creative Commons Attribution licence <http://creativecommons.org/licenses/by/3.0/>.\",\"pageCount\":null},{\"title\":\"Screening strategies to identify new chemical diversity for drug development to treat kinetoplastid infections \",\"journalId\":\"PAR\",\"componentId\":9137291,\"displayOrder\":null,\"authors\":null,\"volumeId\":141,\"issueId\":\"01\",\"fileId\":\"S003118201300142X\",\"forthcoming\":\"N\",\"dispart\":null,\"doi\":\"10.1017/S003118201300142X\",\"publishedOnlineDate\":1377619200000,\"itemNo\":null,\"firstPage\":\"140\",\"lastPage\":\"146\",\"seriesId\":\"0\",\"topic\":null,\"copyrightStatement\":\"Copyright © Cambridge University Press 2013 \",\"pageCount\":null},{\"title\":\"Screening strategies to identify new chemical diversity for drug development to treat kinetoplastid infections – CORRIGENDUM \",\"journalId\":\"PAR\",\"componentId\":9137297,\"displayOrder\":null,\"authors\":null,\"volumeId\":141,\"issueId\":\"01\",\"fileId\":\"S0031182013001741\",\"forthcoming\":\"N\",\"dispart\":\"Corrigendum\",\"doi\":\"10.1017/S0031182013001741\",\"publishedOnlineDate\":1381161600000,\"itemNo\":null,\"firstPage\":\"147\",\"lastPage\":\"147\",\"seriesId\":\"0\",\"topic\":null,\"copyrightStatement\":\"Copyright © Cambridge University Press 2013 \",\"pageCount\":null},{\"title\":\"Open source drug discovery – A limited tutorial\",\"journalId\":\"PAR\",\"componentId\":9137285,\"displayOrder\":null,\"authors\":null,\"volumeId\":141,\"issueId\":\"01\",\"fileId\":\"S0031182013001121\",\"forthcoming\":\"N\",\"dispart\":null,\"doi\":\"10.1017/S0031182013001121\",\"publishedOnlineDate\":1377619200000,\"itemNo\":null,\"firstPage\":\"148\",\"lastPage\":\"157\",\"seriesId\":\"0\",\"topic\":null,\"copyrightStatement\":\"Copyright © Cambridge University Press 2013 The online version of this article is published within an Open Access environment subject to the conditions of the Creative Commons Attribution licence <http://creativecommons.org/licenses/by/3.0/>.\",\"pageCount\":\"10\"},{\"title\":\"PAR volume 141 issue 1 Cover and Front matter \",\"journalId\":\"PAR\",\"componentId\":9137301,\"displayOrder\":null,\"authors\":null,\"volumeId\":141,\"issueId\":\"01\",\"fileId\":\"S0031182013002205\",\"forthcoming\":\"N\",\"dispart\":\"Front Cover (OFC, IFC) and matter\",\"doi\":\"10.1017/S0031182013002205\",\"publishedOnlineDate\":1401206400000,\"itemNo\":null,\"firstPage\":\"f1\",\"lastPage\":\"f2\",\"seriesId\":\"0\",\"topic\":null,\"copyrightStatement\":\"Copyright © Cambridge University Press 2014 \",\"pageCount\":null},{\"title\":\"PAR volume 141 issue 1 Cover and Back matter \",\"journalId\":\"PAR\",\"componentId\":9137303,\"displayOrder\":null,\"authors\":null,\"volumeId\":141,\"issueId\":\"01\",\"fileId\":\"S0031182013002217\",\"forthcoming\":\"N\",\"dispart\":\"Back Cover (IBC, OBC) and matter\",\"doi\":\"10.1017/S0031182013002217\",\"publishedOnlineDate\":1401206400000,\"itemNo\":null,\"firstPage\":\"b1\",\"lastPage\":\"b2\",\"seriesId\":\"0\",\"topic\":null,\"copyrightStatement\":\"Copyright © Cambridge University Press 2014 \",\"pageCount\":null}]";
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
