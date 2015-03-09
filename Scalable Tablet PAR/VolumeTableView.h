//
//  VolumeTableView.h
//  Scalable Tablet PAR
//
//  Created by Mark Oliver Baltazar on 3/9/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VolumeTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
- (instancetype)initWithVolumeList:(NSArray *)arrVolumeList;

@property (strong, nonatomic) NSArray *arrVolumeList;
@end
