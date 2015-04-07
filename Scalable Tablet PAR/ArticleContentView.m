//
//  ArticleContentView.m
//  Scalable-Table-PAR
//
//  Created by Julius Lundang on 3/25/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "ArticleContentView.h"
#import "SyntaxHighlightTextStorage.h"

@implementation ArticleContentView {
    NSLayoutManager *_layoutManager;
}

- (void)buildFrames
{
    NSDictionary *attrs = @{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]};
    // create the text storage
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self.articleMarkup];
    
    // create the layout manager
    _layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:_layoutManager];
    
    // build the frames
    NSRange range = NSMakeRange(0, 0);
    NSUInteger containerIndex = 0;
    while(NSMaxRange(range) < _layoutManager.numberOfGlyphs) {
        // Create a frame for the view at this index;
        CGRect textViewRect = [self frameForViewAtIndex:containerIndex];
        // Create an instance of NSTextContainer with a size based on the frame returned from frameForViewAtIndex. Note the 16.0F magic number; you decrese the height by this amount as UITextView adds an 8.0F margin above and below the container
        CGSize containerSize = CGSizeMake(textViewRect.size.width, textViewRect.size.height - 16.0f);
        NSTextContainer* textContainer = [[NSTextContainer alloc] initWithSize:containerSize];
        [_layoutManager addTextContainer:textContainer];
        // Create UITextView for this container
        UITextView *textView = [[UITextView alloc] initWithFrame:textViewRect textContainer:textContainer];
        [self addSubview:textView];
        containerIndex++;
        // Determine the glyph range for the new text container. This value is used to determin wheter further text containers are required
        range = [_layoutManager glyphRangeForTextContainer:textContainer];
    }
    // Finally update the size of the scroll view based on the number of containers created
    self.contentSize = CGSizeMake(self.bounds.size.width * (CGFloat)containerIndex, self.bounds.size.height);
    self.pagingEnabled = YES;
}

- (CGRect)frameForViewAtIndex:(NSUInteger)index {
    CGRect textViewRect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    textViewRect = CGRectInset(textViewRect, 10.0, 20.0);
    textViewRect = CGRectOffset(textViewRect, (self.bounds.size.width) * (CGFloat)index, 0.0);
    
    return textViewRect;
}
@end
