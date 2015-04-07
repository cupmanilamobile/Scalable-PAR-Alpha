//
//  ArticleContentView.m
//  Scalable-Table-PAR
//
//  Created by Julius Lundang on 3/25/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "ArticleContentView.h"

@implementation ArticleContentView {
    NSLayoutManager *_layoutManager;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)buildFrames
{
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
        containerIndex++;
        // Determine the glyph range for the new text container. This value is used to determin wheter further text containers are required
        range = [_layoutManager glyphRangeForTextContainer:textContainer];
    }
    // Finally update the size of the scroll view based on the number of containers created
    self.contentSize = CGSizeMake(self.bounds.size.width * (CGFloat)containerIndex, self.bounds.size.height);
    self.pagingEnabled = YES;
    
    [self buildViewsForCurrentOffset];
}

- (CGRect)frameForViewAtIndex:(NSUInteger)index {
    CGRect textViewRect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    textViewRect = CGRectInset(textViewRect, 10.0, 20.0);
    textViewRect = CGRectOffset(textViewRect, (self.bounds.size.width) * (CGFloat)index, 0.0);
    
    return textViewRect;
}

- (NSArray *)textSubviews {
    NSMutableArray *views = [NSMutableArray new];
    for (UIView *subview in self.subviews) {
        if ([subview class] == [UITextView class]) {
            [views addObject:subview];
        }
    }
    return views;
}

- (UITextView *)textViewForContainer:(NSTextContainer *)textContainer {
    for (UITextView *textView in [self textSubviews]) {
        if (textView.textContainer == textContainer) {
            return textView;
        }
    }
    return nil;
}

- (BOOL)shouldRenderView:(CGRect)viewFrame {
    if (viewFrame.origin.x + viewFrame.size.width < (self.contentOffset.x - self.bounds.size.width)) {
        return NO;
    }
    if (viewFrame.origin.x > (self.contentOffset.x + self.bounds.size.width * 2.0)) {
        return NO;
    }
    return YES;
}

- (void)buildViewsForCurrentOffset {
    // Iterate over all instances of NSTextContainer that have been added to the layout manager
    for (NSUInteger index = 0; index < _layoutManager.textContainers.count; index++) {
        // Obtain the view that renders this container. textViewForContainer: will return nil if a view is not present
        NSTextContainer *textContainer = _layoutManager.textContainers[index];
        UITextView *textView = [self textViewForContainer:textContainer];
        
        // Determine the frame for this view, and whether or not is hould be rendered
        CGRect textViewRect = [self frameForViewAtIndex:index];
        
        if ([self shouldRenderView:textViewRect]) {
            // If it should be rendered, check whether it already exists. If id odes, do nothing; if not, create it
            if (!textView) {
                NSLog(@"Adding view at index %u", index);
                UITextView *textView = [[UITextView alloc] initWithFrame:textViewRect textContainer:textContainer];
                [self addSubview:textView];
            }
        } else {
            // If it shouldn't be rendered, check if it exists already. If it does, remove it.
            if (textView) {
                NSLog(@"Deleting view at index %u", index);
                [textView removeFromSuperview];
            }
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self buildViewsForCurrentOffset];
}
@end
