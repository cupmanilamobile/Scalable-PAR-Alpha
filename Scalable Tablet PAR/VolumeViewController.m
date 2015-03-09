//
//  VolumeViewController.m
//  Scalable Tablet PAR
//
//  Created by cvflores on 2/27/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "VolumeViewController.h"
#import "VolumeCellTableViewCell.h"
#import "VolumeDashboardViewController.h"
#import "Misc.h"

@interface VolumeViewController ()

@end

@implementation VolumeViewController

NSArray* volumes;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [Misc downloadingServerImageFromUrl:self.latestIssueCover AndUrl:@"http://journals.cambridge.org/cover_images/PAR/PAR.jpg"];
    // Do any additional setup after loading the view.
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:@"http://192.168.242.119:8080/release-15.1.PAR/journal/PAR/"]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                self.journalDetails = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                // [self.journalDetails objectForKey:@"description"];
                NSLog(@"done loading");
                NSLog(@"%@",[self.journalDetails objectForKey:@"description"]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //  self.description.text =[self.journalDetails objectForKey:@"description"];
                    ;
//                    [self.latestVolumeLabel setText: [NSString stringWithFormat:@"Volume %@", [[[self.journalDetails objectForKey:@"volumes"] objectAtIndex:0] objectForKey:@"volumeId"]]];
                    
                    volumes = [self.journalDetails objectForKey:@"volumes"];
                    [self setVolumesInContainer];
                });
            }] resume];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    
    static NSString *CellIdentifier = @"Cell";
    
    VolumeCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell != nil) {
        NSDictionary* volume = [volumes objectAtIndex:indexPath.row] ;
        cell.volumeIdLabel.text =[NSString stringWithFormat:@"Volume %@",[volume objectForKey:@"volumeId"]];
        cell.tag =[[volume objectForKey:@"volumeId"] integerValue];
        
        NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
        [f2 setDateFormat:@"EEEE, MMMM dd"];
        
        //NSDate* date = ;
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
       // NSString *formattedDate = [f2 stringFromDate:date];
//        NSInteger day = [components day];
//        NSInteger month = [components month];
//        NSInteger year = [components year];
        
        
        NSMutableString* dateString = [volume objectForKey:@"circulationDate"];
        
        cell.circulationDateLabel.text = [[NSString alloc] initWithFormat:@" %@",[dateString substringToIndex:4]];
        
    }
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [volumes count];
}

-(void)setVolumesInContainer{
    self.volumeTable.delegate = self;
    self.volumeTable.dataSource=self;
    [self.volumeTable reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"single Tap on imageview");
    
    UITableViewCell* sender = [tableView cellForRowAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"issueList" sender:sender];
    
 //   NSLog(@"%@" ,issueLink);
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"issueList"])
    {
        UITableViewCell* tableViewCell = (UITableViewCell*) sender;
        VolumeDashboardViewController* nextVC = [segue destinationViewController];
        nextVC.volumeId = tableViewCell.tag;
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
