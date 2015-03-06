//
//  VolumeViewController.h
//  Scalable Tablet PAR
//
//  Created by cvflores on 2/27/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VolumeViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *journalDescription;
@property (strong, nonatomic) IBOutlet UIButton *firstViewButton;
@property (strong, nonatomic) IBOutlet UIButton *openAccessButton;
@property (strong, nonatomic) IBOutlet UITableView *volumeTable;
@property (strong, nonatomic) IBOutlet UIImageView *latestIssueCover;
@property (strong,nonatomic) NSDictionary* journalDetails;
@end
