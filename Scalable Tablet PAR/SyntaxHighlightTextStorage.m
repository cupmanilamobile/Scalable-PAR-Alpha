//
//  SyntaxHighlightTextStorage.m
//  Scalable Tablet PAR
//
//  Created by Mark Oliver Baltazar on 3/11/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "SyntaxHighlightTextStorage.h"

@implementation SyntaxHighlightTextStorage {
    NSMutableAttributedString *_backingStore;
}

- (id)init {
    if (self = [super init]) {
        _backingStore = [NSMutableAttributedString new];
    }
    return self;
}

- (NSString *)string {
    return [_backingStore string];
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range {
    return [_backingStore attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str {
    NSLog(@"replaceCharactersInRange:%@ withString:%@", NSStringFromRange(range), str);
    
    [self beginEditing];
    [_backingStore replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters | NSTextStorageEditedAttributes range:range changeInLength:str.length - range.length];
    [self endEditing];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range {
    NSLog(@"setAttributes:%@ range:%@", attrs, NSStringFromRange(range));
    
    [self beginEditing];
    [_backingStore setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}

- (void)processEditing {
    [self performReplacementsForRange:[self editedRange]];
    [super processEditing];
}

- (void)performReplacementsForRange:(NSRange)changedRange {
    NSRange extendedRange = NSUnionRange(changedRange, [[_backingStore string] lineRangeForRange:NSMakeRange(changedRange.location, 0)]);
    extendedRange = NSUnionRange(changedRange, [[_backingStore string] lineRangeForRange:NSMakeRange(NSMaxRange(changedRange), 0)]);
    [self applyStylesToRange:extendedRange];
}

- (void)applyStylesToRange:(NSRange)searchRange {
    // 1. create some fonts
//    UIFontDescriptor* fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle];
    
    UIFontDescriptor *italicFontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:
                                              @{
                                                @"NSFontFamilyAttribute": @"Helvetica Neue",
                                                @"NSFontFaceAttribute"  : @"Italic"
                                              }];
    UIFont *italicFont = [UIFont fontWithDescriptor:italicFontDescriptor size: 13];
    
    UIFont *normalFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    // 2. match items surrounded by asterisks
    NSString *regexStr = @"<i>(.+?)</i>";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSDictionary *italicAttributes = @{ NSFontAttributeName : italicFont };
    NSDictionary *normalAttributes = @{ NSFontAttributeName : normalFont };
    
    // 3. iterate over each match, making the text bold
    [regex enumerateMatchesInString:[_backingStore string] options:0 range:searchRange
        usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
            NSRange matchRange = [match rangeAtIndex:1];
            [self addAttributes:italicAttributes range:matchRange];
                             
            // 4. reset the style to the original
            if (NSMaxRange(matchRange)+1 < self.length) {
            [self addAttributes:normalAttributes range:NSMakeRange(NSMaxRange(matchRange)+1, 1)];
        }
    }];
}

@end
