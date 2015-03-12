//
//  ArticleViewController.m
//  Scalable Tablet App
//
//  Created by cvflores on 6/21/14.
//  Copyright (c) 2014 cvflores. All rights reserved.
//

#import "ArticleViewController.h"
//#import "ArticleXMLParser.h"
#import "Article.h"
#import <MBProgressHUD/MBProgressHUD.h>



@interface ArticleViewController ()<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate>

@end

@implementation ArticleViewController


@synthesize abstractPage;
@synthesize articleTitleLabel;
@synthesize articleTitle;
@synthesize articleBarLabel;
@synthesize articleLink;
@synthesize loadingActivityView;
@synthesize abstractLabel;
@synthesize scrollView;
@synthesize pageControl;
@synthesize articleAttribute;
@synthesize volume;
@synthesize issue;
@synthesize articleList;
NSMutableData *receivedData;

BOOL pageControlBeingUsed;

int i = 0;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // Test commit
        NSLog(@"This a test commit");
    }
    return self;
}

- (void)viewDidLoad
{
     [super viewDidLoad];
    
 //   UITableView* tableView = self.mainSlideMenu.leftMenu.tableView;
//    [tableView setDelegate:self];
//    [tableView setDataSource:self];
//    [tableView reloadData];
//    
    
    i=0;
  //  [self.navigationController setNavigationBarHidden:YES animated:YES];
    
   // self.navigationItem.titleView = self.articleBarLabel;
 //   AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
   // [mainVC.leftMenu.leftMenus addObject:@"Test new ROW2"];
   // mainVC.leftMenu.leftMenus = [articleList mutableCopy];
    //[mainVC.leftMenu.tableView reloadData];
    [self.navigationController setToolbarHidden:YES animated:YES];
   

    [self reloadArticle];
    
}

-(void)reloadArticle{
//    NSMutableString* articleMutableLink = [[NSMutableString alloc] initWithString:@"http://journals.cambridge.org/action/xxx"];
//    
//    self.articleAttribute.text = [[NSString alloc] initWithFormat:@"Volume %@ Issue %@ ",self.volume,self.issue];
//    
//    [articleMutableLink replaceOccurrencesOfString:@"xxx" withString:articleLink options:NSLiteralSearch range: NSMakeRange(0, [articleMutableLink length])];
//    
//    [articleMutableLink replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSLiteralSearch range: NSMakeRange(0, [articleMutableLink length])];
//    NSURL *myURL = [NSURL URLWithString:[articleMutableLink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [articleTitleLabel setText:articleTitle];
    [articleTitleLabel sizeToFit];
//    NSLog(@"loading url : %@", myURL );
//    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:myURL];
//    NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"cjo", @"cjo"];
//    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    //   NSString *authValue = [authData base64Encoding];
    
//    loadingActivityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    CGAffineTransform transform = CGAffineTransformMakeScale(2.0f, 2.0f);
//    loadingActivityView.transform = transform;
//    [scrollView addSubview:loadingActivityView];
//    
//    
//    CGSize boundsSize = scrollView.bounds.size;
//    CGRect frameToCenter = loadingActivityView.frame;
//    // center horizontally
//    if (frameToCenter.size.width < boundsSize.width)
//        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
//    else
//        frameToCenter.origin.x = 0;
//    
//    // center vertically
//    if (frameToCenter.size.height < boundsSize.height)
//        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
//    else
//        frameToCenter.origin.y = 0;
//    
//    loadingActivityView.frame = frameToCenter;
//    [loadingActivityView startAnimating];
    
    //   [self.abstractPage loadRequest:myRequest];
//    NSURLConnection *myConnection = [NSURLConnection connectionWithRequest:myRequest delegate:self];
 //   loadingActivityView = [Misc loadActivityView:scrollView.bounds.size];
    [scrollView addSubview:loadingActivityView];
    [loadingActivityView startAnimating];
    //loadingActivityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.articleTitleLabel.text = self.articleTitle;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

   NSURLConnection *myConnection = [Misc getURLConnection:@"http://journals.cambridge.org/action/xxx" param:@"displayAbstract?fromPage=online&aid=9585049&fulltextType=RV&fileId=S0031182014001838" id:self];
  //  [self anotherLoad];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge previousFailureCount] == 0) {
        NSLog(@"received authentication challenge");
        NSURLCredential *newCredential = [NSURLCredential credentialWithUser:@"cjo"
                                                                    password:@"cjo"
                                                                 persistence:NSURLCredentialPersistenceForSession];
        NSLog(@"credential created");
        [[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
        NSLog(@"responded to authentication challenge");
    }
    else {
        NSLog(@"previous authentication failure");
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
    
    int errorCode = httpResponse.statusCode;
    
    NSString *fileMIMEType = [[httpResponse MIMEType] lowercaseString];
    
    NSLog(@"response is %d, %@", errorCode, fileMIMEType);
    receivedData =  [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    
    //    if(self.journalLabel.text == nil){
    //    [self.journalLabel setText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    //    }
    //    else{
    //
    //        NSString *temp = [self.journalLabel text];
    //        temp = [temp stringByAppendingString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    //
    //        [self.journalLabel setText:temp];
    //
    //    }
    [receivedData appendData:data];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    
    
    // inform the user
    
    NSLog(@"Connection failed! Error - %@ %@",
          
          [error localizedDescription],
          
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // do something with the data
    
    // receivedData is declared as a method instance elsewhere
    
    NSString *temp = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    if([NSJSONSerialization isValidJSONObject:receivedData]){
        NSLog(@"nice one");
    }
    else{
        NSLog(@"INVALID JSON");
    }
    
    //self.journalLabel.text= temp ;
    
    NSLog(@"Data! ,%@", temp);
    
    
    NSRange range =[temp rangeOfString:@ "<div class=\"fulltxt-holder\">"];

    if(range.location != NSNotFound){
        temp = [temp substringFromIndex:range.location];
        self.abstractLabel.text = @"";
    }
    else if([temp rangeOfString:@"<div class=\"abstract_legacy_style\">"].location !=NSNotFound){
        self.abstractLabel.text = @"Abstract";
        range = [temp rangeOfString:@"<div class=\"abstract_legacy_style\">"];
        temp = [temp substringFromIndex:range.location];
       

    }
    else if([temp rangeOfString:@"<div xmlns=\"http://www.w3.org/1999/xhtml\" class=\"description-box\">"].location !=NSNotFound){
        self.abstractLabel.text = @"";
        range = [temp rangeOfString:@"<div xmlns=\"http://www.w3.org/1999/xhtml\" class=\"description-box\">"];
        temp = [temp substringFromIndex:range.location];
        
    }

   

    
    
     range = [temp rangeOfString:@"<p class=\"section-title\">Abstract</p>"];
 //   temp = [temp substringFromIndex:range.location];
    if(range.location != NSNotFound){
        temp = [temp substringFromIndex:range.location];

          range = [temp rangeOfString:@"<strong>Key words</strong>"];
        if(range.location !=NSNotFound)
        temp = [temp substringToIndex:range.location];
    }
    
    range = [temp rangeOfString:@"<!-- End of descriptions -->"];
    if(range.location !=NSNotFound){
        temp = [temp substringToIndex:range.location];
        
        
    }
  

    
    
   
    
    
    NSMutableString* mutableTemp = [[NSMutableString alloc] initWithString:temp];
    
    [mutableTemp replaceOccurrencesOfString:@"<p class=\"section-title\">Abstract</p>" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [mutableTemp length])];
    
    
    
    [mutableTemp replaceOccurrencesOfString:@"/data/firstAbstract/" withString:@"http://journals.cambridge.org/data/firstAbstract/" options:NSLiteralSearch range:NSMakeRange(0, [mutableTemp length])];
    


    
    [self.abstractPage loadHTMLString:mutableTemp baseURL:nil];
    [self.abstractPage setDelegate:self];
    
     UIWebView* webView =  [[UIWebView alloc] initWithFrame:CGRectMake(self.scrollView.frame.origin.x-50, self.scrollView.frame.origin.y-50 , self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    [webView setDelegate:self];
    
    [webView setBackgroundColor:[UIColor whiteColor]];
        [webView loadHTMLString:mutableTemp baseURL:nil];
    [self.scrollView addSubview:webView];
    [self anotherLoad];
   // [self.scrollView addSubview:label];
   
        NSLog(@"Succeeded!");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [loadingActivityView stopAnimating];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if(i==0){
         i++;
    return YES;
       

    }
    else
    return NO;
}
- (void)anotherLoad
{
    //webViewArray = [[NSMutableArray alloc] initWithCapacity:0 ];
    
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.scrollView.frame.origin.y-50 , self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.scrollView.frame.origin.y-100, self.scrollView.frame.size.width,45)];
    [label setFont:    [UIFont fontWithName:@"Helvetica MS" size:21]];
    [label setTextColor:[UIColor colorWithRed: 179.0/255.0 green: 179.0/255.0 blue:179.0/255.0 alpha: 1.0]];
    [webView setBackgroundColor:[UIColor whiteColor]];
  //  Article *article = [ArticleXMLParser loadArticle];
   // [webView loadHTMLString:article.abstract baseURL:baseURL];
    //[webView loadHTMLString:[self getWebViewContent1] baseURL:baseURL];
    
    
   // [self.scrollView addSubview:webView];
    [self.scrollView addSubview:label];
    
    label.text=@"Introduction";
    UIWebView* webView1 = [[UIWebView alloc] initWithFrame:CGRectMake( self.scrollView.frame.size.width*1, self.scrollView.frame.origin.y-50 , self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    
    UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake( self.scrollView.frame.size.width*1, self.scrollView.frame.origin.y-100, self.scrollView.frame.size.width,45)];
    [webView1 setBackgroundColor:[UIColor whiteColor]];

    label1.text=@"Materials and Methods";
    
    [label1 setFont:    [UIFont fontWithName:@"Helvetica MS" size:21]];
    [label1 setTextColor:[UIColor colorWithRed: 179.0/255.0 green: 179.0/255.0 blue:179.0/255.0 alpha: 1.0]];
    
    [webView1 loadHTMLString:[self getWebViewContent2] baseURL:baseURL];
    
    [self.scrollView addSubview:webView1];
    [self.scrollView addSubview:label1];
    
    UIWebView* webView2 = [[UIWebView alloc] initWithFrame:CGRectMake( self.scrollView.frame.size.width*2, self.scrollView.frame.origin.y-50 , self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    [webView2 setBackgroundColor:[UIColor whiteColor]];

    UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake( self.scrollView.frame.size.width*2, self.scrollView.frame.origin.y-100, self.scrollView.frame.size.width,45)];
    
    label2.text=@"Results and Discussions";
    
    [label2 setFont:    [UIFont fontWithName:@"Helvetica MS" size:21]];

    [label2 setTextColor:[UIColor colorWithRed: 179.0/255.0 green: 179.0/255.0 blue:179.0/255.0 alpha: 1.0]];
    
    
    
    
    [webView2 loadHTMLString:[self getWebViewContent3] baseURL:baseURL];
    
    
    
    UIWebView* webView3 = [[UIWebView alloc] initWithFrame:CGRectMake( self.scrollView.frame.size.width*3, self.scrollView.frame.origin.y-50 , self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    [webView3 setBackgroundColor:[UIColor whiteColor]];

    UILabel* label3 = [[UILabel alloc] initWithFrame:CGRectMake( self.scrollView.frame.size.width*3, self.scrollView.frame.origin.y-100, self.scrollView.frame.size.width,45)];
    
    label3.text=@"References";
    
    [label3 setFont:    [UIFont fontWithName:@"Helvetica MS" size:21]];

    [label3 setTextColor:[UIColor colorWithRed: 179.0/255.0 green: 179.0/255.0 blue:179.0/255.0 alpha: 1.0]];
    
    
    
    
    [webView3 loadHTMLString:[self getWebViewContent4] baseURL:baseURL];
    
    
    
    
    //[webView1 loadHTMLString:[self getWebViewContent2] baseURL:nil];
    
    [self.scrollView addSubview:webView2];
    [self.scrollView addSubview:label2];
    
    [self.scrollView addSubview:webView3];
    [self.scrollView addSubview:label3];
    
    
    
    //    [webView loadHTMLString:[self getWebViewContent1] baseURL:nil];
    //
    //    for (int i = 0; i < 6; i++) {
    //
    //    }
    //    [super viewDidLoad];
    //    NSArray *colors = [NSArray arrayWithObjects:[UIColor redColor], [UIColor greenColor], [UIColor blueColor], nil];
    //    for (int i = 0; i < colors.count; i++) {
    //        CGRect frame;
    //        frame.origin.x = self.scrollView.frame.size.width * i;
    //        frame.origin.y = 0;
    //        frame.size = self.scrollView.frame.size;
    //
    //        UIView *subview = [[UIView alloc] initWithFrame:frame];
    //        subview.backgroundColor = [colors objectAtIndex:i];
    //        [self.scrollView addSubview:webView];
    //        [self.scrollView addSubview:label];
    //
    //    }
    [self.scrollView setDelegate:self];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 5, self.scrollView.frame.size.height);
    
    // Do any additional setup after loading the view.
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}
- (IBAction)changePage {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [articleList count];
}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        // [cell setBackgroundColor:[UIColor ]];
//        
//        [cell setOpaque:false];
//        // [cell.textLabel setBackgroundColor: [UIColor grayColor]];
//        
//        
//        // [cell.textLabel setFrame:CGRectMake(cell.frame.origin.x-200, cell.frame.origin.y,cell.frame.size.width-10, cell.frame.size.height-10)];
//        //   [cell.textLabel setTextColor:[UIColor blackColor]];
//        [cell.textLabel setTextColor:[UIColor colorWithRed: 128.0/255.0 green: 128.0/255.0 blue:128.0/255.0 alpha: 1.0]];
//        //[cell.textLabel setNumberOfLines:2];
//        cell.textLabel.numberOfLines = 3;
//        
//        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:16]];
//    }
//    
//    
//    // Configure the cell...
//    if (articleList != nil) {
//        NSLog(@"Cell: %ld", (long)indexPath.row);
//        Article* article = [articleList objectAtIndex:indexPath.row];
//      //  cell.textLabel.text = article.articleTitle;
//    }
//    else
//    {
//        NSLog(@"No cells!");
//        [cell.textLabel setText:@"No Accounts"];
//    }
//    
//    return cell;
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"single Tap on imageview");
//    
//    UITableViewCell* sender = [tableView cellForRowAtIndexPath:indexPath];
//    
//    Article* article = [articleList objectAtIndex:indexPath.row];
//    
//    self.articleLink =article.articleLink;
//    i--;
//    [self reloadArticle];
//    [self.mainSlideMenu closeLeftMenu ];
//}



-(NSString*)getWebViewContent1{
    
    
    
    return @"<div class=\"sec1\"><p>Malaria is an infectious vector-borne disease responsible for significant global morbidity and mortality (Snow et al. 2005). The vast majority of the fatal cases of malaria are caused by Plasmodium falciparum, although Plasmodium vivax, which is itself responsible for huge morbidity (Mendis et al. 2001), may also, although rarely, be severe and fatal (Kochar et al. 2005; Rogerson and Carter, 2008; Suwanarusk et al. 2008; ter Kuile and Rogerson, 2008; Tjitra et al. 2008; Andrade et al. 2010). The sequestration of parasitized erythrocytes in the deep vasculature is the main cause of the pathology of severe falciparum malaria. Mature trophozoites and schizonts sequester in the peripheral circulation due to the adhesion of infected erythrocytes to endothelial cells (cytoadherence) and with uninfected erythrocytes (rosetting) leading to significantly impaired blood circulation (Miller et al. 1994). Infected erythrocytes also become more rigid and adhere to different cell types (Raventos-Suarez et al. 1985).</p><p>The malaria parasite modifies its host-cell environment, presumably to enhance its own survival, and this leads to pathological consequences for the host. While all stages of the parasite modify their host cell to a certain extent, infected erythrocytes are subject to extensive modifications that are vital for parasite survival (Miller et al. 1994). Human erythrocytes lack protein trafficking machinery, so, following invasion, P. falciparum first has to establish a trafficking pathway to export various proteins to the surface of the infected cell.</p></div>";
}

-(NSString*)getWebViewContent2{
    
    return @"<div class=\"sec2\"><h2 id=\"sec2-1\">Cloning, expression and purification of FhGALE</h2> <div class=\"sec2-1\"><p>The modification of the erythrocyte from a free-flowing and essentially non-adhesive cell to one that is capable of adhering to endothelial cells and non-infected erythrocytes (Miller et al. 1994) highlights the dramatic modification that occurs following the invasion of the malaria parasite. Major changes that occur in the infected erythrocyte include the formation of small protrusions on the surface of the cell (knobs), alterations in ion channel behaviour (Decherf et al. 2004; Staines et al. 2007), the formation of novel channels for nutrient import (Saliba et al. 1998; Desai et al. 2000; Staines et al. 2004), membrane rigidity and cell deformability (Glenister et al. 2002) and altered behaviour of infected erythrocytes in the microcirculation (Diez-Silva et al. 2012). These modifications occur as a result of the export of various effector proteins in the infected erythrocyte. Mature erythrocytes are devoid of any endogenous vesicle trafficking machinery; therefore, for the parasite to export proteins, it needs to establish its own trafficking pathway. The major obstruction for protein export in the infected erythrocyte is the interface of the parasite and the host-cell cytoplasm, i.e. the parasitophorous vacuole (PV) and its associated membrane (parasitophorous vacuole membrane (PVM)). In order to alter the host cell from a hostile environment to one that is conducive for parasite survival, parasite-encoded proteins have to traverse the PV and the PVM and enter the erythrocyte.</p></br><h4>Fig. 1.</h3><p>Schematic representation of an exported protein in the PV in a P. falciparum-infected erythrocyte. Exported proteins enter PV, get unfolded and cross PVM and enter erythrocyte cytoplasm with the help of translocons. In erythrocyte cytoplasm, exported proteins first get refolded with the help of heat shock protein and then reach subcellular locations in erythrocytes. PVM, parasitophorous vacuole membrane; PM, parasite membrane. This image showing translocation of exported protein from PVM is drawn on the basis of work by Gehde et al. (2009) </br>.<img src=\"S0031182014000948_fig3p.jpeg\"/> </p> </br></br>  <p>How, then, does the parasite achieve this? To understand protein trafficking beyond the PVM, two pathways of protein export have been proposed: one is vesicle mediated (Gormley et al. 1992; Foley and Tilley, 1998; Taraschi et al. 2001) and the other channel mediated (Gormley et al. 1992; Schatz and Dobberstein, 1996; Foley and Tilley, 1998; Schnell and Hebert, 2003). Plasmodium falciparum proteins thought to be exported via vesicles include PfEMP-1, PfSar1p, Pfsec31p, etc. (Gormley et al. 1992; Ansorge et al. 1996; Trelka et al. 2000; Taraschi et al. 2001, 2003), while soluble proteins such as KAHRP, PHIST, MESA, PfEMP-3, FIKK kinase, etc. are thought to be exported via the channel pathway (Hiller et al. 2004; Marti et al. 2004; Sargeant et al. 2006). The channel-mediated protein export pathway in P. falciparum is discussed here in detail. First, a signal sequence directs the protein for export to the lumen of the endoplasmic reticulum (ER) where the export signal is recognized and processed for entry into the secretory pathway. Through this secretory pathway, the protein crosses the PV and then the PVM through translocons present in the membrane (de Koning-Ward et al. 2009). The protein then enters the erythrocyte cytosol and is finally directed to its destination, which may be the host-cell cytosol, Maurer's clefts (MCs), the erythrocyte membrane or the surface of the erythrocyte (Fig. 1) (Cooke et al. 2004).</p> <p> Recently, several key issues in protein export have been elucidated. These include the identification of an export signal (Hiller et al. 2004; Marti et al. 2004), the mechanism by which the export signal is processed (Chang et al. 2008; Boddey et al. 2009, 2010; Russo et al. 2010; Bhattacharjee et al. 2012), the physical nature of exported proteins in the PV (Gehde et al. 2009), the translocon machinery (de Koning-Ward et al. 2009) and the role of MCs in directing proteins to the surface of the host cell (Bhattacharjee et al. 2008). Based on these breakthroughs, the channel-mediated protein export pathway has been modelled (Fig. 1) and advances in our current understanding of the various steps involved in protein trafficking are discussed in detail below.</p> <h2 id=\"sec2-1\">Identification of the export signal and prediction of exported proteins</h2><p>A major advance in our understanding of the protein trafficking mechanisms of malaria parasites was the identification of an export signal sequence, and the use of this to predict which proteins the parasite exports (Hiller et al. 2004; Marti et al. 2004). These studies revealed a consensus conserved amino acid motif downstream of the N-terminal sequences of many exported proteins, which was termed the Plasmodium export element (PEXEL) or the vacuole transport signal (VTS) (Hiller et al. 2004; Marti et al. 2004), which is conserved structurally and functionally across the Plasmodium species infecting humans and birds (Marti et al. 2004). The PEXEL/VTS motif generally lies within a 20–60 amino-acid stretch downstream of the N-terminal sequence of many exported proteins (Hiller et al. 2004; Marti et al. 2004; Sargeant et al. 2006) (Fig. 2). It consists of five amino acids RxLxE/Q/G, of which arginine (R) and lysine (L) are essential for recognition whereas the fifth amino acid glutamate (E) is not essential and can be replaced with glutamine (Q) (frequently) or glycine (G) (rarely) (Hiller et al. 2004; Marti et al. 2004) (x could be any amino acid). Further, the PEXEL processed proteins get acetylated at the new N-terminus, which appears to be crucial for recognition and transport of exported proteins to red cells (Chang et al. 2008; Boddey et al. 2009). A recent study has identified that many exported proteins can have a relaxed PEXEL motif (RxLxxE), which is functional and processed by the same mechanism used for canonical PEXEL (Boddey et al. 2013). Based on the updated information of the relaxed PEXEL motif, ExportPred version 1.0 (Sargeant et al. 2006) has been re-designed (version 2.0), which identified 73 additional exported proteins from the falciparum genome (Boddey et al. 2013). </p> <p>The PEXEL/VTS motif does not appear to be essential for a protein to enter the export pathway, however, as several exported proteins do not possess such a motif. The exported proteins targeted to the host-cell cytoplasm that lack a well-defined PEXEL/VTS motif are denoted as PEXEL negative export proteins (PNEPs). These PNEPs include skeleton binding protein-1 (SBP-1), membrane-associated histidine-rich protein-1 (MAHRP-1), and ring export protein-1 and -2 (REX-1 and REX-2) (Blisnick et al. 2000; Spycher et al. 2003; Hawthorne et al. 2004; Spielmann et al. 2006; Haase et al. 2009; Saridaki et al. 2009), which are all resident proteins of MCs. The PNEPs (REX-2, SBP-1 and MAHRP-1) contain a conserved transmembrane domain but lack a signal sequence, whereas REX-1 has a recessed signal sequence (Dixon et al. 2008). These PNEPs have ER intermediates, suggesting export via a classical secretory pathway (Spycher et al. 2006; Dixon et al. 2008; Saridaki et al. 2008; Haase et al. 2009). It is very likely that processing of a signal peptide could also generate a similar N-terminus of PNEPs as generated by Plasmepsin-V; therefore, it has been proposed (Spielmann and Gilberger, 2010) that following processing by a signal peptidase, the trafficking of PNEPs may converge with PEXEL proteins at the translocon. The functional evaluation of Plasmodium export signals in Plasmodium berghei suggests that there may be multiple pathways of protein export for PEXEL and PNEP proteins in non-falciparum malaria parasites (Sijwali and Rosenthal, 2010). Based on the quantity of PEXEL/VTS positive proteins, it is apparent that the majority of proteins exported by P. falciparum are PEXEL/VTS positive, whereas in non-falciparum Plasmodium species, it is the PEXEL/VTS-independent proteins that make up the majority of the exportome (Table 1). The most well-characterized example of PEXEL/VTS-independent export in a non-P. falciparum malaria parasite is the export of the variant surface proteins of P. vivax, Plasmodium cynomolgi, Plasmodium knowlesi and Plasmodium yoelii/P. berghei/Plasmodium chabaudi (Table 1). Only a few members of the above variant gene families (Table 1) possess a canonical PEXEL/VTS motif near their signal sequences. Plasmodium vivax VIR proteins provide direct evidence for their export at the surface of infected red blood cells (iRBC; Bernabeu et al. 2012; Lopez et al. 2013). Indirect evidence for export of VIR proteins can be inferred from the structural similarity of VIR subfamilies A and D (Merino et al. 2006) with the exported proteins of P. falciparum SURFIN and two transmembrane (Pf2TM) proteins respectively that lack a canonical PEXEL (Sam-Yellowe et al. 2004; Winter et al. 2005; Alexandre et al. 2011). This suggests that the non-falciparum Plasmodium species may have different mechanisms for the export of proteins necessary for host-cell remodelling and virulence, and corroborates a hypothesis that canonical PEXEL/VTS exported proteins have undergone lineage-specific expansion in the falciparum parasite (Pick et al. 2011). Further, it is unclear whether the greater abundance of canonical PEXEL/VTS proteins in P. falciparum is due to the fact that P. falciparum requires a high degree of host-cell remodelling compared with non-falciparum malaria parasite species, and so exports more proteins, or to the fact that protein export in the non-falciparum species is mainly mediated through PEXEL/VTS-independent pathways (Pick et al. 2011).</p></div></div>";
    
}
-(NSString*)getWebViewContent3{
    
    return @"<div class=\"sec3\"><h2 id=\"sec3-1\">FhGALE is a dimeric protein</h2><div class=\"sec3-1\"><p>The number of predicted exported proteins is far fewer in non-falciparum malaria species than in P. falciparum when algorithm-based predictions are used (Pick et al. 2011). The majority of predicted exported proteins belong to 27 well-characterized gene families, including stevor, pfemp-1, rifin, fikk kinases, surfin and pf2tm and 21 other novel gene families (Sargeant et al. 2006; Boddey et al. 2013). Some of the major novel exported protein-encoding gene families are PHIST, DNA-J and hydrolase proteins (Sargeant et al. 2006). The majority of predicted exported proteins are hypothetical and require further functional characterization and annotation. Furthermore, phylogenetic studies suggest the occurrence of lineage-specific expansion of the phist, DNA-J and FIKK kinases gene families in the P. falciparum genome (Ward et al. 2004; Sargeant et al. 2006). One member of the phist-b gene family has been shown to be involved in knob formation (Maier et al. 2008; Acharya et al. 2012).</p> <p>The expansion of various gene families in P. falciparum but not in non-falciparum malaria species suggests that radiation of these gene families may have shaped the specific pathogenesis of this parasite (Sargeant et al. 2006; Pick et al. 2011). The high virulence of P. falciparum compared with non-falciparum malaria species is mainly mediated by the localization of PfEMP-1 on the surface of infected erythrocytes. Studies of the export of PfEMP-1 beyond the PVM have been carried out using the PfEMP-1 protein (Var2CSA) expressed by the CS-2 cloned line of P. falciparum that causes placental malaria (Salanti et al. 2004). The genome of this parasite has 59 different PfEMP-1 proteins expressed in a mutually exclusive way so that a single PfEMP-1 protein is expressed during each schizogonic cycle in the blood (Dzikowski et al. 2006a , b ). This suggests that the actual number of exported proteins required for the successful expression of PfEMP-1 at the surface of the erythrocyte may be larger than currently thought. A large-scale gene knockout study has described the involvement of various PHIST proteins in PfEMP-1 trafficking as well as in the modification of erythrocyte membrane rigidity (Maier et al. 2008). Recently, a single PHIST protein has been shown to have vital interaction with the ATS domain of PfEMP-1 (Mayer et al. 2012), suggesting a putative role for PHIST proteins in trafficking parasite-encoded proteins in the infected erythrocyte. Therefore, the lineage-specific expansion of PHIST and other export families (Sargeant et al. 2006) may be a specific requirement of P. falciparum relating to the trafficking of host-cell remodelling and virulence-associated proteins. </p></div></div>";
}
-(NSString*) getWebViewContent4{
    
    return @"<div class=\"references-list\" id=\"rl\" name=\"rl\"><ul><li>Acharya, P., Kumar, R. and Tatu, U. (2007). Chaperoning a cellular upheaval in malaria: heat shock proteins in Plasmodium falciparum . Molecular and Biochemical Parasitology 153, 85–94.</li><li>Acharya, P., Chaubey, S., Grover, M. and Tatu, U. (2012). An exported heat shock protein 40 associates with pathogenesis-related knobs in Plasmodium falciparum infected erythrocytes. PLoS ONE 7, e44605.</li><li>Alexandre, J. S., Yahata, K., Kawai, S., Torii, M. and Kaneko, O. (2011). PEXEL-independent trafficking of Plasmodium falciparum SURFIN4.2 to the parasite-infected red blood cell and Maurer's clefts. Parasitology International 60, 313–320.</li><li>Andrade, B. B., Reis-Filho, A., Souza-Neto, S. M., Clarencio, J., Camargo, L. M., Barral, A. and Barral-Netto, M. (2010). Severe Plasmodium vivax malaria exhibits marked inflammatory imbalance. Malaria Journal 9, 13.</li><li>Ansorge, I., Benting, J., Bhakdi, S. and Lingelbach, K. (1996). Protein sorting in Plasmodium falciparum-infected red blood cells permeabilized with the pore-forming protein streptolysin O. Biochemical Journal 315, 307–314.</li><li>Bernabeu, M., Lopez, F. J., Ferrer, M., Martin-Jaular, L., Razaname, A., Corradin, G., Maier, A. G., Del Portillo, H. A. and Fernandez-Becerra, C. (2012). Functional analysis of Plasmodium vivax VIR proteins reveals different subcellular localizations and cytoadherence to the ICAM-1 endothelial receptor. Cellular Microbiology 14, 386–400.</li><li>Bhattacharjee, S., van Ooij, C., Balu, B., Adams, J. H. and Haldar, K. (2008). Maurer's clefts of Plasmodium falciparum are secretory organelles that concentrate virulence protein reporters for delivery to the host erythrocyte. Blood 111. </li><li>Bhattacharjee, S., Stahelin, R. V., Speicher, K. D., Speicher, D. W. and Haldar, K. (2012). Endoplasmic reticulum PI(3)P lipid binding targets malaria proteins to the host cell. Cell 148, 201–212.</li><li>Blisnick, T., Morales Betoulle, M. E., Barale, J. C., Uzureau, P., Berry, L., Desroses, S., Fujioka, H., Mattei, D. and Braun Breton, C. (2000). Pfsbp1, a Maurer's cleft Plasmodium falciparum protein, is associated with the erythrocyte skeleton. Molecular and Biochemical Parasitology</li><li>Boddey, J. A., Moritz, R. L., Simpson, R. J. and Cowman, A. F. (2009). Role of the Plasmodium export element in trafficking parasite proteins to the infected erythrocyte. Traffic 10, 285–299.</li><li>Boddey, J. A., Hodder, A. N., Gunther, S., Gilson, P. R., Patsiouras, H., Kapp, E. A., Pearce, J. A., de Koning-Ward, T. F., Simpson, R. J., Crabb, B. S. and Cowman, A. F. (2010). An aspartyl protease directs malaria effector proteins to the host cell. Nature 463, 627–631.</li><li>Boddey, J. A., Carvalho, T. G., Hodder, A. N., Sargeant, T. J., Sleebs, B. E., Marapana, D., Lopaticki, S., Nebl, T. and Cowman, A. F. (2013). Role of plasmepsin V in export of diverse protein families from the Plasmodium falciparum exportome. Traffic 14, 532–550.</li><li>Bullen, H. E., Charnaud, S. C., Kalanon, M., Riglar, D. T., Dekiwadia, C., Kangwanrangsan, N., Torii, M., Tsuboi, T., Baum, J., Ralph, S. A., Cowman, A. F., de Koning-Ward, T. F., Crabb, B. S. and Gilson, P. R. (2012). Biosynthesis, localization, and macromolecular arrangement of the Plasmodium falciparum translocon of exported proteins (PTEX). Journal of Biological Chemistry 287.</li></ul></div>";
}


/*- (NSString *)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath
{
    NSString *identifier;
    
    switch (indexPath.row) {
        case 0:
            identifier = @"firstSegue";
            break;
        case 1:
            identifier = @"secondSegue";
            break;
    }
    return identifier;
}

- (NSString *) segueIdentifierForIndexPathInRightMenu:(NSIndexPath *)indexPath
{
    NSString *identifier;
    switch (indexPath.row) {
        case 0:
            identifier = @"firstRightSegue";
            break;
        case 1:
            identifier = @"secondRightSegue";
            break;
    }
    return identifier;
}

- (void)configureLeftMenuButton:(UIButton *)button
{
    CGRect frame = button.frame;
    frame.origin = (CGPoint){0,0};
    frame.size = (CGSize){40,40};
    
    button.frame = frame;
    
    [button setImage:[UIImage imageNamed:@"icon-menu"] forState:UIControlStateNormal];
}

- (void) configureRightMenuButton:(UIButton *)button
{
    CGRect frame = button.frame;
    frame.origin = (CGPoint){0,0};
    frame.size = (CGSize){40,40};
    
    button.frame = frame;
    
    [button setImage:[UIImage imageNamed:@"icon-menu.png"] forState:UIControlStateNormal];
}*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
