//
//  AggregatorLayoutView.m
//  Scalable Tablet App
//
//  Created by cvflores on 1/26/15.
//  Copyright (c) 2015 cvflores. All rights reserved.
//

#import "AggregatorLayoutView.h"
#import "ArticleAggregatorItemView.h"


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
    [self setFrame:CGRectMake(0.0, 75.0,width, height-150)];

    
}
-(void)initializeBorders{
    NSArray* array = [self subviews];
    UIView* view;
    
    CGFloat borderWidth = 1.0f;
    
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
    articleItem.title.text = [article objectForKey:@"title"] ;
   // articleItem.tag = [[article objectForKey: @"tag"] intValue];
    articleItem.authors.text = nil;//[article objectForKey:@"authors"];
    
    
    

    articleItem.frame  =CGRectMake(x * (index%3)+8, y*(index/3)+8,width - 8 , height-8);
    
    return articleItem;
}
-(void)setDatasource:(NSObject <AggregatorLayoutDelegate>*) dataSource{
    self.dataSource = dataSource;}

@end
