//
//  ViewController.m
//  Scalable Tablet PAR
//
//  Created by cvflores on 2/20/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "ArticleContentViewController.h"
#import "ArticleContentView.h"
#import <AFNetworking/AFNetworking.h>
#import "GDataXMLNode.h"
#import "MarkdownMaker.h"
#import "MarkdownParser.h"

@interface ArticleContentViewController () {
    ArticleContentView *_articleContentView;
}

@end

@implementation ArticleContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.87F alpha:1.0F];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager new];
    manager.responseSerializer = [AFHTTPResponseSerializer new];
//    [manager GET:@"http://localhost/S0031182014001565w.xml" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    [manager GET:@"http://localhost/S0031182014001644h.xml" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        MarkdownParser *parser = [[MarkdownParser alloc] init];
        MarkdownMaker *mm = [MarkdownMaker sharedManager];
        _articleContentView = [[ArticleContentView alloc] initWithFrame:self.view.bounds];
        _articleContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _articleContentView.articleMarkup = [parser parseMarkdown:[mm convertAbstractDataToMarkdown:responseObject]];
//        _articleContentView.articleMarkup = [mm convertAbstractDataToMarkdown:responseObject];
        [self.view addSubview:_articleContentView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
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
