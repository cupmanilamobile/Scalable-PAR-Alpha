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

#define API_GET_JOURNAL_DETAILS_URL @"http://192.168.242.121:8080/release-15.1.PAR/journal/PAR"
#define API_GET_ISSUES_BY_VOLUME_ID_URL @"http://192.168.242.121:8080/release-15.1.PAR/journal/PAR/%i"
#define CJOTEST_2_COVER_IMAGES_URL @"http://cjotest-2.uat.cambridge.org/cover_images/PAR/PAR%i_%@.jpg"

@interface DashboardViewController ()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *journalDetailsViewHeightContraint;
@property (strong, nonatomic) IBOutlet UIView *journalDetailsView;

@property (strong, nonatomic) IBOutlet UITextView *journalDescriptionTextView;
@property (strong, nonatomic) IBOutlet UIImageView *journalCoverImageView;
@property (strong, nonatomic) IBOutlet UILabel *journalEditorLabel;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) NSArray *arrVolumeList;
@property (strong, nonatomic) NSArray *arrIssueList;
@end

@implementation DashboardViewController {
    int journalDetailsOriginalHeight;
    int latestVolumeId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    journalDetailsOriginalHeight = _journalDetailsView.frame.size.height;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // Download journal cover
    [Misc downloadingServerImageFromUrl:_journalCoverImageView AndUrl:@"http://journals.cambridge.org/cover_images/PAR/PAR.jpg"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:API_GET_JOURNAL_DETAILS_URL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError* jsonError = nil;
        NSDictionary *journalDetailsDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        _arrVolumeList = [journalDetailsDictionary objectForKey:@"volumes"];
        latestVolumeId = [[_arrVolumeList[0] objectForKey:@"volumeId"] intValue];
        _arrIssueList = [self fetchIssueListByVolumeId:latestVolumeId];

        dispatch_async(dispatch_get_main_queue(), ^{
            _journalEditorLabel.text = [NSString stringWithFormat:@"Editor(s): %@",  [journalDetailsDictionary objectForKey:@"editor"]];
            _journalDescriptionTextView.text = [journalDetailsDictionary objectForKey:@"description"];
            
            [self buildIssueCover];
        });
    }] resume];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)buildIssueCover {
    [[_scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    IssueCover *issueCover;
    for (int i = 0; i < _arrIssueList.count; i++) {
        int tag = [[_arrIssueList[i] objectForKey:@"issueId"] intValue];
        
        issueCover = [[[NSBundle mainBundle] loadNibNamed:@"IssueCover" owner:self options:nil] lastObject];
        issueCover.volumeId = [[_arrIssueList[i] objectForKey:@"volumeId"] intValue];
        issueCover.issueLabel.text = [NSString stringWithFormat:@"Issue %i", tag];
        issueCover.translatesAutoresizingMaskIntoConstraints = NO;
        issueCover.tag  = tag;
        
        // Add gesture recognizer
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(issueTap:)];
        [issueCover addGestureRecognizer:singleTap];
        
        // Setup constraints
        [_scrollView addSubview:issueCover];
        [self setConstraints:i];
    }
    
    [self.view layoutIfNeeded]; // Required
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, issueCover.frame.origin.y + issueCover.frame.size.height + 24)];
    [self loadIssueImages];
}

- (void)setConstraints:(int)index
{
    IssueCover *previousCover;
    if (index == 0) {
        previousCover = [self issueCover:index];
    } else if (index < 5) {
        previousCover = [self issueCover:index - 1];
    } else {
        previousCover = [self issueCover:index - 5];
    }
    
    IssueCover *currentCover = [self issueCover:index];
    NSDictionary *viewsDictionary = index == 0 ? NSDictionaryOfVariableBindings(currentCover) : NSDictionaryOfVariableBindings(previousCover, currentCover);
    
    NSArray *constraint_POS_V;
    if (index < 5) {
        constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[currentCover]" options:0 metrics:nil views:viewsDictionary];
    } else {
        constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousCover]-24-[currentCover]" options:0 metrics:nil views:viewsDictionary];
    }
    
    if (index > 5) { // Improve this
        previousCover = [self issueCover:index - 1];
        viewsDictionary = index == 0 ? NSDictionaryOfVariableBindings(currentCover) : NSDictionaryOfVariableBindings(previousCover, currentCover);
    }
    
    NSArray *constraint_POS_H;
    if (index == 0 || index % 5 == 0) {
        constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[currentCover]" options:0 metrics:nil views:viewsDictionary];
    } else {
        constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousCover]-25-[currentCover]" options:0 metrics:nil views:viewsDictionary];
    }
    
    // Size constraints
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:currentCover attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeHeight multiplier:0.0 constant:230];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:currentCover attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeWidth multiplier:0.0 constant:125];
    
    [_scrollView addConstraints:constraint_POS_V];
    [_scrollView addConstraints:constraint_POS_H];
    [_scrollView addConstraint:height];
    [_scrollView addConstraint:width];
}

- (IssueCover *)issueCover:(int)index {
    NSInteger issueTag = [[_arrIssueList[index] objectForKey:@"issueId"] integerValue];
    return (IssueCover *) [_scrollView viewWithTag: issueTag];
}

- (void)loadIssueImages {
    for (int i = 0; i < _arrIssueList.count; i++) {
        NSString *url = [NSString stringWithFormat:CJOTEST_2_COVER_IMAGES_URL, latestVolumeId, [_arrIssueList[i] objectForKey:@"issueId"]];
        [Misc downloadingServerImageFromUrl:[self issueCover:i].coverImage AndUrl:url];
    }
}

#pragma mark - Hide & Show button
- (IBAction)showHideButtonPressed:(UIButton *)button {
    [UIView animateWithDuration:.4f animations:^{
        if (_journalDetailsView.frame.size.height == 0) {
            _journalDetailsViewHeightContraint.constant += journalDetailsOriginalHeight;
            [button setTitle:@"Hide" forState:UIControlStateNormal];
            _journalDetailsView.alpha = 1;

        } else {
            _journalDetailsViewHeightContraint.constant -= journalDetailsOriginalHeight;
            [button setTitle:@"Show" forState:UIControlStateNormal];
            _journalDetailsView.alpha = 0;
        }
        [self.view layoutIfNeeded];
    }];
}

// If there is CoreData already, TODO: fetch it instead in CoreData. (<< To Confirm..)
- (NSArray *)fetchIssueListByVolumeId:(int)volumeId {
    NSError *error;
    NSData *issueData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:API_GET_ISSUES_BY_VOLUME_ID_URL, volumeId]]];
    return [NSJSONSerialization JSONObjectWithData:issueData options:0 error:&error];
}

- (void)reloadIssueCovers:(int)volumeId {
    _arrIssueList = [self fetchIssueListByVolumeId:volumeId];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self buildIssueCover];
    });
}

#pragma mark - Menu Actions
- (IBAction)showLatestIssues:(id)sender {
    [self reloadIssueCovers:latestVolumeId];
    _tableView.hidden = YES;
    _scrollView.hidden = NO;
}

- (IBAction)showVolumes:(id)sender {
    [_tableView reloadData];
    _scrollView.hidden = YES;
    _tableView.hidden = NO;
}

- (IBAction)showFirstView:(id)sender {
    NSLog(@"Put code to show FIRSTVIEW articles here..");
}

- (IBAction)showOpenAccess:(id)sender {
    NSLog(@"Put code to show OPEN ACCESS articles here..");
}

#pragma mark - Segue
- (void)issueTap:(id) sender {
    [self performSegueWithIdentifier:@"articleAggregator" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
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
    NSDictionary *volumeDictionary = _arrVolumeList[indexPath.row];
    
    VolumeTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"VolumeTableViewCell" owner:self options:nil] lastObject];
    cell.textLabel.text = [NSString stringWithFormat:@"Volume %@", [volumeDictionary objectForKey:@"volumeId"]];
    cell.volumeYear.text = [[volumeDictionary objectForKey:@"circulationDate"] substringToIndex:4];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self reloadIssueCovers:[[_arrVolumeList[indexPath.row] objectForKey:@"volumeId"] intValue]];
    tableView.hidden = YES;
    _scrollView.hidden = NO;
}

@end
