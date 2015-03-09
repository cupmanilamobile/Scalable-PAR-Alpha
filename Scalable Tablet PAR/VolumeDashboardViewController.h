//
//  VolumeDashboardViewController.h
//  Scalable Tablet PAR
//
//  Created by cvflores on 2/20/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VolumeDashboardViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *latestVolumeCover;
@property (strong, nonatomic) IBOutlet UIScrollView *volumeContainerScrollView;
@property (strong,nonatomic)  NSDictionary* volumeDetails;
@property (strong,nonatomic) NSArray* issueList;
@property (strong, nonatomic) IBOutlet UILabel *latestVolumeLabel;
@property (strong, nonatomic) IBOutlet UIPageControl *volumePageControl;
@property (assign, nonatomic) NSInteger volumeId;
@end
