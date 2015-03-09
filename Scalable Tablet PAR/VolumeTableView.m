//
//  VolumeTableView.m
//  Scalable Tablet PAR
//
//  Created by Mark Oliver Baltazar on 3/9/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "VolumeTableView.h"
#import "VolumeTableViewCell.h"

@implementation VolumeTableView

- (instancetype)initWithVolumeList:(NSArray *)arrVolumeList {
    self = [super init];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        
        _arrVolumeList = arrVolumeList;
    }
    return self;
}

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
    
}

@end
