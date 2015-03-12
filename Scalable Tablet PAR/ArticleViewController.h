//
//  ArticleViewController.h
//  Scalable Tablet App
//
//  Created by cvflores on 6/21/14.
//  Copyright (c) 2014 cvflores. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Article.h"
#import "Misc.h"

@interface ArticleViewController : UIViewController<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *articleBarLabel;
@property (strong, nonatomic) IBOutlet UILabel *articleTitleLabel;

@property (strong,nonatomic) NSString* articleTitle;
@property (strong,nonatomic) NSString* articleLink;
@property (weak, nonatomic) IBOutlet UILabel *abstractLabel;

@property (weak, nonatomic) IBOutlet UIWebView *abstractPage;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView* loadingActivityView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UILabel *articleAttribute;
@property (strong,nonatomic) NSString* volume;
@property (strong,nonatomic) NSString* issue;
@property (strong,nonatomic) NSArray* articleList;

@end
