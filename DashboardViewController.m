//
//  DashboardViewController.m
//  Scalable Tablet PAR
//
//  Created by Mark Oliver Baltazar on 3/6/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "DashboardViewController.h"
#import "ArticleAggregatorViewController.h"
#import "VolumeTableViewCell.h"
#import "IssueCover.h"
#import "Misc.h"
#import "Journal.h"
#import "Volume.h"
#import "Issue.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import <Parse/Parse.h>

#define CJOTEST_2_COVER_IMAGES_URL @"http://cjotest-2.uat.cambridge.org/cover_images/PAR/PAR%@_%@.jpg"

@interface DashboardViewController ()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *journalDetailsViewHeightContraint;
@property (strong, nonatomic) IBOutlet UIView *journalDetailsView;

@property (strong, nonatomic) IBOutlet UITextView *journalDescriptionTextView;
@property (strong, nonatomic) IBOutlet UIImageView *journalCoverImageView;
@property (strong, nonatomic) IBOutlet UILabel *journalEditorLabel;
@property (strong, nonatomic) IBOutlet UILabel *journalDescriptionLabel;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) NSArray *arrVolumeList;
@property (strong, nonatomic) NSArray *arrIssueList;

@property (strong, nonatomic) IBOutlet UIWebView *journalEditorWebview;
@property (strong, nonatomic) IBOutlet UIWebView *journalDescriptionWebview;
@end

@implementation DashboardViewController {
    int journalDetailsOriginalViewHeight;
    NSString *latestVolumeId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_journalDetailsView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgcleangray.jpg"]]];
    journalDetailsOriginalViewHeight = _journalDetailsView.frame.size.height;
    
    // Download journal cover
    [Misc downloadingServerImageFromUrl:_journalCoverImageView AndUrl:@"http://journals.cambridge.org/cover_images/PAR/PAR.jpg"];
    
    PFQuery *query = [Journal query];
    [query whereKey:@"journalId" equalTo:@"PAR"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self showProgressHud];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                Journal *journal = [objects objectAtIndex:0];
                [self loadWebview:_journalEditorWebview with:journal[@"editor"] type:@"editor"];
                [self loadWebview:_journalDescriptionWebview with:journal[@"description"] type:@"description"];
                
                _arrVolumeList = [self fetchAllVolumes];
                latestVolumeId = ((Volume *) _arrVolumeList[0]).volumeId;
                if (_arrVolumeList.count > 0) {
                    _arrIssueList = [self fetchIssueListByVolumeId:latestVolumeId];
                    if (_arrIssueList.count > 0) {
                        [self buildIssueCover];
                    }
                }
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)buildIssueCover {
    [[_scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    IssueCover *issueCover;
    for (int i = 0; i < _arrIssueList.count; i++) {
        Issue *issue = [_arrIssueList objectAtIndex:i];
        
        if ([self hasNumbericOnly:issue.issueId]) {
            int tag = [issue.issueId intValue];
            issueCover = [[[NSBundle mainBundle] loadNibNamed:@"IssueCover" owner:self options:nil] lastObject];
            issueCover.issueLabel.text = [NSString stringWithFormat:@"Issue %02d", tag];
            issueCover.volumeId = [issue.volumeId intValue];
            issueCover.tag  = tag;
        
            // Add gesture recognizer
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(issueTap:)];
            [issueCover addGestureRecognizer:singleTap];
        
            // Setup constraints
            [_scrollView addSubview:issueCover];
            [self setIssueCoverConstraints:i];
        }
    }
    
    [self.view layoutIfNeeded]; // Required
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, issueCover.frame.origin.y + issueCover.frame.size.height + 24)];
    [self loadIssueImages];
}

- (IssueCover *)issueCover:(int)index {
    Issue *issue = [_arrIssueList objectAtIndex:index];
    return (IssueCover *) [_scrollView viewWithTag: [issue.issueId intValue]];
}

- (void)loadIssueImages {
    for (int i = 0; i < _arrIssueList.count; i++) {
        Issue *issue = [_arrIssueList objectAtIndex:i];
        if ([self hasNumbericOnly:issue.issueId]) {
            NSString *url = [NSString stringWithFormat:CJOTEST_2_COVER_IMAGES_URL, issue.volumeId, issue.issueId];
            [Misc downloadingServerImageFromUrl:[self issueCover:i].coverImage AndUrl:url];
        }
    }
}

#pragma mark - Hide & Show button
- (IBAction)showHideButtonPressed:(UIButton *)button {
    [UIView animateWithDuration:.4f animations:^{
        if (_journalDetailsView.frame.size.height == 0) {
            _journalDetailsViewHeightContraint.constant += journalDetailsOriginalViewHeight;
            [button setTitle:@"Hide" forState:UIControlStateNormal];
            _journalDetailsView.alpha = 1;

        } else {
            _journalDetailsViewHeightContraint.constant -= journalDetailsOriginalViewHeight;
            [button setTitle:@"Show" forState:UIControlStateNormal];
            _journalDetailsView.alpha = 0;
        }
        [self.view layoutIfNeeded];
    }];
}

// If there is CoreData already, TODO: fetch it instead in CoreData. (<< To Confirm..)
- (NSArray *)fetchIssueListByVolumeId:(NSString *)volumeId {
    PFQuery *issueQuery = [Issue query];
    [issueQuery whereKey:@"volumeId" equalTo:volumeId];
    [issueQuery orderByAscending:@"issueId"];
    
    NSError *issueError;
    return[issueQuery findObjects:&issueError];
}

- (NSArray *)fetchAllVolumes {
    PFQuery *volumeQuery = [Volume query];
    NSError *volumeError;
    NSArray *arr = [volumeQuery findObjects:&volumeError];
    
    NSSortDescriptor *aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"volumeId" ascending:NO comparator:^(id obj1, id obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    return [NSMutableArray arrayWithArray:[arr sortedArrayUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]]];;
}

- (void)reloadIssueCovers:(NSString *)volumeId {
    [self showProgressHud];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        _arrIssueList = [self fetchIssueListByVolumeId:volumeId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self buildIssueCover];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (void)showProgressHud {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [hud setLabelText:@"Loading..."];
    [hud show:YES];
}

// TODO: There are issueId with value 'S1'. For now, we disregard this but should be catered soon
- (BOOL)hasNumbericOnly:(NSString *)str {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[a-z]" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:str options:0 range:NSMakeRange(0, [str length])];
    return matches.count == 0;
}

#pragma mark - Menu Actions
- (IBAction)showLatestIssues:(id)sender {
    _tableView.hidden = YES;
    _scrollView.hidden = NO;
    [self reloadIssueCovers:latestVolumeId];
}

- (IBAction)showVolumes:(UIButton *)button {
    _scrollView.hidden = YES;
    _tableView.hidden = NO;
    [_tableView reloadData];
    
//    [UIView animateWithDuration:0.5 animations:^{
//        _tableView.frame = CGRectMake(0, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height);
//        _scrollView.frame = CGRectMake(-_scrollView.frame.size.width, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height);
//    }];
}

#pragma mark - Segue
- (void)issueTap:(id) sender {
    [self performSegueWithIdentifier:@"articleAggregator" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"articleAggregator"]) {
        ArticleAggregatorViewController* nextVC = [segue destinationViewController];
        IssueCover *issueCover = (IssueCover *) [(UIGestureRecognizer *)sender view];
        nextVC.volumeId = issueCover.volumeId;
        nextVC.issueId = issueCover.tag;
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrVolumeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    
    Volume *volume = _arrVolumeList[indexPath.row];
    VolumeTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"VolumeTableViewCell" owner:self options:nil] lastObject];
    cell.textLabel.text = [NSString stringWithFormat:@"Volume %@", volume.volumeId];
    cell.volumeYear.text = [formatter stringFromDate:volume.circulationDate];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Volume *volume = _arrVolumeList[indexPath.row];
    [self reloadIssueCovers:volume.volumeId];
    tableView.hidden = YES;
    _scrollView.hidden = NO;
}

#pragma mark - Constraints
- (void)setIssueCoverConstraints:(int)index {
    IssueCover *currentCover = [self issueCover:index];
    IssueCover *previousCover;
    if (index == 0) {
        previousCover = [self issueCover:index];
    } else if (index < 5) {
        previousCover = [self issueCover:index - 1];
    } else {
        previousCover = [self issueCover:index - 5];
    }
    
    NSDictionary *viewsDictionary = index == 0 ? NSDictionaryOfVariableBindings(currentCover) : NSDictionaryOfVariableBindings(previousCover, currentCover);
    
    // Vertical Constraint
    NSString *visualVertical = index < 5 ? @"V:|-10-[currentCover]" : @"V:[previousCover]-24-[currentCover]";
    NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:visualVertical options:0 metrics:nil views:viewsDictionary];
    
    if (index > 5) { // Improve this
        previousCover = [self issueCover:index - 1];
        viewsDictionary = index == 0 ? NSDictionaryOfVariableBindings(currentCover) : NSDictionaryOfVariableBindings(previousCover, currentCover);
    }
    
    // Horizontal Constraint
    NSString *visualHorizontal = index == 0 || index % 5 == 0 ? @"H:|-20-[currentCover]" : @"H:[previousCover]-25-[currentCover]";
    NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:visualHorizontal options:0 metrics:nil views:viewsDictionary];
    
    // Size constraints
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:currentCover attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeWidth multiplier:0.0 constant:125];
    
    [_scrollView addConstraints:constraint_POS_V];
    [_scrollView addConstraints:constraint_POS_H];
    [_scrollView addConstraint:width];
}

- (void)loadWebview:(UIWebView *)webview with:(NSString *)string type:(NSString *)type {
    int i;
    NSString *tmp, *editorText = @"";;
    if ([type isEqualToString:@"editor"]) {
        i = 12;
        tmp = @"editor";
        editorText = @"Editor(s):";
    } else {
        i = 13;
        tmp = @"description";
    }
    
    NSString *html = [NSString stringWithFormat:@"<html><body style='font-family:Helvetica Neue; font-size:%ipx; color:#555'>%@ %@</body><html>", i, editorText, string];
    NSString *docsFolder = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filename = [docsFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.html", tmp]];

    NSError *error;
    [html writeToFile:filename atomically:NO encoding:NSUTF8StringEncoding error:&error];
    [webview loadHTMLString:html baseURL:nil];

}
@end
