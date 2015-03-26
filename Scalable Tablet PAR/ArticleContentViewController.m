//
//  ViewController.m
//  Scalable Tablet PAR
//
//  Created by cvflores on 2/20/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "ArticleContentViewController.h"
#import "ArticleContentView.h"

@interface ArticleContentViewController () {
    ArticleContentView *_articleContentView;
}

@end

@implementation ArticleContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0.87F alpha:1.0F];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    _articleContentView = [[ArticleContentView alloc] initWithFrame:self.view.bounds];
    _articleContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
//    [self.view addSubview:_articleContentView];
}

- (void)viewDidLayoutSubviews
{
    [_articleContentView buildFrames];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
