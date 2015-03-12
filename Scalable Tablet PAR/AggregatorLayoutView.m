//
//  AggregatorLayoutView.m
//  Scalable Tablet App
//
//  Created by cvflores on 1/26/15.
//  Copyright (c) 2015 cvflores. All rights reserved.
//

#import "AggregatorLayoutView.h"
#import "ArticleAggregatorItemView.h"
#import "FullScreenView.h"
#import "Misc.h"


@implementation AggregatorLayoutView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */



-(void)initalizeViews{
    
    
    
    
    
    ArticleAggregatorItemView* view1x3 = [self ArticleAggregatorItem:@"ArticleCell1x3" index:0];
    ArticleAggregatorItemView* view2x1Left = [self ArticleAggregatorItem:@"ArticleCell2x1" index:3];
    ArticleAggregatorItemView* view2x1Middle = [self ArticleAggregatorItem:@"ArticleCell2x1" index:4];
    ArticleAggregatorItemView* view2x1Right = [self ArticleAggregatorItem:@"ArticleCell2x1" index:5];
    
    [self addSubview:view1x3];
    [self addSubview:view2x1Left];
    [self addSubview:view2x1Middle];
    [self addSubview:view2x1Right];
    
    [self initializeBorders];
    
    
}

-(void)initalizeViewsOption2{
    
    
    
    ArticleAggregatorItemView* view1x2 = [self ArticleAggregatorItem:@"ArticleCell1x2" index:0];
    ArticleAggregatorItemView* view2x1Left = [self ArticleAggregatorItem:@"ArticleCell2x1" index:3];
    ArticleAggregatorItemView* view2x1Middle = [self ArticleAggregatorItem:@"ArticleCell2x1" index:4];
    ArticleAggregatorItemView* view3x1Right = [self ArticleAggregatorItem:@"ArticleCell3x1" index:2];
    
    
    
    [self addSubview:view1x2];
    [self addSubview:view2x1Left];
    [self addSubview:view2x1Middle];
    [self addSubview:view3x1Right];
    
    [self initializeBorders];
    
    
}

-(void)initalizeViewsOption3{
    
    
    
    
    
    
    ArticleAggregatorItemView* view1x1Left = [self ArticleAggregatorItem:@"ArticleCell" index:0];
    ArticleAggregatorItemView* view1x1Mid = [self ArticleAggregatorItem:@"ArticleCell" index:1];
    ArticleAggregatorItemView* view1x1Right = [self ArticleAggregatorItem:@"ArticleCell" index:2];
    ArticleAggregatorItemView* view1x2  = [self ArticleAggregatorItem:@"ArticleCell1x2" index:3];
    ArticleAggregatorItemView* view1x1MidRight = [self ArticleAggregatorItem:@"ArticleCell" index:5];
    ArticleAggregatorItemView* view1x1BottomLeft  = [self ArticleAggregatorItem:@"ArticleCell" index:6];
    ArticleAggregatorItemView* view1x1BottomMid  = [self ArticleAggregatorItem:@"ArticleCell" index:7];
    ArticleAggregatorItemView* view1x1BottomRight = [self ArticleAggregatorItem:@"ArticleCell" index:8];
    
    
    
    [self addSubview:view1x1Left];
    [self addSubview:view1x1Mid];
    [self addSubview:view1x1Right];
    [self addSubview:view1x2];
    [self addSubview:view1x1MidRight];
    [self addSubview:view1x1BottomLeft];
    [self addSubview:view1x1BottomMid];
    [self addSubview:view1x1BottomRight];
    
    [self initializeBorders];
    
    
}

-(void)initalizeViewsOption4{
    
    
    
    ArticleAggregatorItemView* view1x1Left = [self ArticleAggregatorItem:@"ArticleCell" index:0];
    ArticleAggregatorItemView* view1x1Mid = [self ArticleAggregatorItem:@"ArticleCell" index:1];
    ArticleAggregatorItemView* view1x1Right = [self ArticleAggregatorItem:@"ArticleCell" index:2];
    ArticleAggregatorItemView* view1x1MidLeft = [self ArticleAggregatorItem:@"ArticleCell" index:3];
    ArticleAggregatorItemView* view1x2  = [self ArticleAggregatorItem:@"ArticleCell1x2" index:4];
    ArticleAggregatorItemView* view1x1BottomLeft  = [self ArticleAggregatorItem:@"ArticleCell" index:6];
    ArticleAggregatorItemView* view1x1BottomMid  = [self ArticleAggregatorItem:@"ArticleCell" index:7];
    ArticleAggregatorItemView* view1x1BottomRight = [self ArticleAggregatorItem:@"ArticleCell" index:8];
    
    [self addSubview:view1x1Left];
    [self addSubview:view1x1Mid];
    [self addSubview:view1x1Right];
    [self addSubview:view1x2];
    [self addSubview:view1x1MidLeft];
    [self addSubview:view1x1BottomLeft];
    [self addSubview:view1x1BottomMid];
    [self addSubview:view1x1BottomRight];
    
    [self initializeBorders];
    
    
    
}

-(void)initalizeFrame:(CGRect) parentFrame {
    
    int height = parentFrame.size.height;
    int width = parentFrame.size.width;
    
    [self setFrame:CGRectMake(0.0, 0.0,width, height)];
    
    
    
}
-(void)initializeBorders{
    NSArray* array = [self subviews];
    UIView* view;
    
    CGFloat borderWidth = 0.6f;
    
    for(int i = 0; i< array.count;i++){
        
        view = array[i];
        view.frame = CGRectInset(view.frame, -borderWidth, -borderWidth);
        view.layer.borderColor = [UIColor grayColor].CGColor;
        view.layer.borderWidth = borderWidth;
        
    }
    
    
}
-(ArticleAggregatorItemView* ) ArticleAggregatorItem:(NSString*) nibName index:(int) index{
    
    
    ArticleAggregatorItemView* articleItem = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] lastObject];
    
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    
    int x = width/3;
    int y = height/3;
    
    int border =8+ (8 * abs(index%3-1));
    int verticalBorder = 8+(8 * abs(index/3-1));
    
    if([nibName isEqual:@"ArticleCell"]){
        
        height = height/3;
        width = width / 3;
    }
    else if([nibName isEqual:@"ArticleCell1x2"]){
        height = height/3;
        width = 2*width / 3;
        
    }
    else if([nibName isEqual:@"ArticleCell2x1"]){
        height = 2*height/3;
        width = width / 3;
        
    }
    else if([nibName isEqual:@"ArticleCell1x3"]){
        height = height/3;
        
    }
    else if([nibName isEqual:@"ArticleCell3x1"]){
        width = width/3;
        
    }
    
    
    NSDictionary* article = [self.dataSource getArticle];
    if(article == Nil){
        return nil;
    }
    
    
    articleItem.title.text =[self stringByStrippingHTML: [article objectForKey:@"title"] ];
    // articleItem.tag = [[article objectForKey: @"tag"] intValue];
    articleItem.authors.text = nil;//[article objectForKey:@"authors"];
    //[articleItem.authors removeFromSuperview];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(tapArticle:)];
    //articleItem.abstractText.text =[self stringByStrippingHTML: [article objectForKey:@"abstract"] ];
    [articleItem.articleImage setImage: [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",rand()%10+1]]];
    [articleItem addGestureRecognizer:singleTap];
    
    articleItem.frame  =CGRectMake(x * (index%3), y*(index/3),width  , height);
    
    articleItem.tag =[[article objectForKey:@"componentId"] integerValue];
    
    return articleItem;
}
-(void)tapArticle:(id) sender{
    ArticleAggregatorItemView* article =(ArticleAggregatorItemView*) [(UIGestureRecognizer *)sender view];
    
  
    UIView* tintView = [[UIView alloc] initWithFrame:CGRectMake(-150, -150,self.frame.size.width*2, self.frame.size.height*2)];
    
    [self addSubview:tintView];
    
    [tintView setBackgroundColor:[UIColor blackColor]];
    tintView.alpha = 0.0;
    tintView.tag = 100;

    
    
    FullScreenView* view =  [[[NSBundle mainBundle] loadNibNamed:@"FullScreenArticleView" owner:self options:nil] lastObject];
    
    
    view.frame = CGRectMake(self.frame.size.width/2, self.frame.size.width/2,0,0 );

    [view.purchaseButton addTarget: self.dataSource
               action: @selector(purchaseArticle:)
     forControlEvents: UIControlEventTouchUpInside];
    [UIView animateWithDuration:0.5 animations:^{
        view.frame =  CGRectMake(50, 30, self.frame.size.width-100, self.frame.size.height-100);
        view.alpha = 1.0;
        [view.articleAbstract setAlpha:1.0];
        [view.articleTitle setAlpha:1.0];
        [tintView setAlpha:0.3];
        
//        view.layer.shadowColor = [UIColor grayColor].CGColor;
//        view.layer.shadowOffset = CGSizeMake(-2.5, -2.5);
//        view.layer.shadowOpacity = 0.5;
//        view.layer.shadowRadius = 0.25;
//        
        view.frame = CGRectInset(view.frame, -1, -1);
        view.layer.borderColor = [UIColor grayColor].CGColor;
        view.layer.borderWidth = 4;
       
    }];
   
    view.tag = article.tag;
    view.articleTitle.text = article.title.text;
    //view.articleAbstract.text = article.abstractText.text;
    
    
//    [view.articleAbstract setNumberOfLines:0];
//    [view.articleAbstract sizeToFit];
   // view.articleAbstract.adjustsFontSizeToFitWidth = YES;
    //view.articleAbstract.numberOfLines = 0;
        [self addSubview:view];
    

    
}





-(NSString *) stringByStrippingHTML: string {
    NSRange r;
    NSString *s = [string copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}
-(void)setDatasource:(NSObject <AggregatorLayoutDelegate>*) dataSource{
    self.dataSource = dataSource;}

@end
