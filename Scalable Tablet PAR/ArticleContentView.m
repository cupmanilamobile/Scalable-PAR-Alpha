//
//  ArticleContentView.m
//  Scalable-Table-PAR
//
//  Created by Julius Lundang on 3/25/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "ArticleContentView.h"
#import "GDataXMLNode.h"

@implementation ArticleContentView {
    NSLayoutManager *_layoutManager;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"S0031182014001565h" ofType:@"xml"];
        NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:htmlFile];
        NSError *error;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
        
        if (doc == nil) {
            return nil;
        }
        
        NSLog(@"%@", doc);
        // create the text storage
        _articleMarkup = [[NSAttributedString alloc] initWithFileURL:[[NSURL alloc] initFileURLWithPath:htmlFile] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    }
    
    return self;
}

- (void)buildFrames
{
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:_articleMarkup];
    
    // create the layout manager
    _layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:_layoutManager];
    
    // create a container
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(self.bounds.size.width, FLT_MAX)];
    [_layoutManager addTextContainer:textContainer];
    
    // create a view
    UITextView *textView = [[UITextView alloc] initWithFrame:self.bounds textContainer:textContainer];
    textView.scrollEnabled = YES;
    [self addSubview:textView];
}
@end
