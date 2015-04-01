//
//  SyntaxHighlightTextStorage.m
//  Scalable-Table-PAR
//
//  Created by Julius Lundang on 3/31/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "SyntaxHighlightTextStorage.h"

@implementation SyntaxHighlightTextStorage {
    NSMutableAttributedString *_backingStorage;
    NSDictionary *_replacements;
}

- (instancetype)init {
    if (self = [super init]) {
        _backingStorage = [NSMutableAttributedString new];
        [self createHighlightPatterns];
    }
    return self;
}

#pragma mark - Persistence
// A text storage subclass must provide its own 'persitence'
- (NSString *)string {
    return [_backingStorage string];
}

#pragma mark - Class cluster
// Since NSTextStorage is a public interface of class cluster, we can't jsut subclass it and override a few methods to extend its functionality.
- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range {
    return [_backingStorage attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str {
    NSLog(@"replaceCharactersInRange:%@ withString:%@", NSStringFromRange(range), str);
    
    [self beginEditing];
    [_backingStorage replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters|NSTextStorageEditedAttributes range:range changeInLength:str.length - range.length];
    [self endEditing];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range {
    NSLog(@"setAttributes: %@ range%@", attrs, NSStringFromRange(range));
    
    [self beginEditing];
    [_backingStorage setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}

#pragma mark - Formatting
// This sends notification when the text changes to the layout manager.
// It also serves as a convenient home for any post-editing login
- (void)processEditing {
    [self performReplacementsForRange:[self editedRange]];
    [super processEditing];
}

- (void)performReplacementsForRange:(NSRange)changedRange {
    NSRange extendedRange = NSUnionRange(changedRange, [[_backingStorage string] lineRangeForRange:NSMakeRange(changedRange.location, 0)]);
    extendedRange = NSUnionRange(extendedRange, [[_backingStorage string] lineRangeForRange:NSMakeRange(NSMaxRange(changedRange), 0)]);
    [self applyStylesToRange:extendedRange];
}

- (void)applyStylesToRange:(NSRange)searchRange {
    NSDictionary *normalAttrs = @{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]};
    
    // iterate over each replacement
    for (NSString *key in _replacements) {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:key options:0 error:nil];
        
        NSDictionary *attributes = _replacements[key];
        
        [regex enumerateMatchesInString:[_backingStorage string] options:0 range:searchRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            // apply the style
            NSRange matchRange = [result range];
            [self addAttributes:attributes range:matchRange];
            
            // reset the style to the original
            if (NSMaxRange(matchRange)+1 < self.length) {
                [self addAttributes:normalAttrs range:NSMakeRange(NSMaxRange(matchRange)+1, 1)];
            }
        }];
    }
    /*
    // create some fonts
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    UIFontDescriptor *boldFontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    UIFont *boldFont = [UIFont fontWithDescriptor:boldFontDescriptor size:0.0F];
    UIFont *normalFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    // match items surrounded by asterisk
    NSString *regexStr = @"(\\*\\w+(.\\s\\w+)*\\*)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:nil];
    NSDictionary *boldAttributes = @{NSFontAttributeName: boldFont};
    NSDictionary *normalAttributes = @{NSFontAttributeName: normalFont};
    
    // iterage over each match, making the text bold
    [regex enumerateMatchesInString:[_backingStorage string] options:0 range:searchRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange matchRange = [result range];
        [self addAttributes:boldAttributes range:matchRange];
        
        // reset the style to the original
        if (NSMaxRange(matchRange)+1 < self.length) {
            [self addAttributes:normalAttributes range:NSMakeRange(NSMaxRange(matchRange)+1, 1)];
        }
    }]; */
}

- (void)createHighlightPatterns {
    UIFontDescriptor *scriptFontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:@{UIFontDescriptorFamilyAttribute: @"Zapfino"}];
    
    // base our script font on the preferred body font size
    UIFontDescriptor *bodyFontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    NSNumber *bodyFontSize = bodyFontDescriptor.fontAttributes[UIFontDescriptorSizeAttribute];
    UIFont *scriptFont = [UIFont fontWithDescriptor:scriptFontDescriptor size:[bodyFontSize floatValue]];
    
    // create the attributes
        NSDictionary *headingOneAttributes = [self attributesWithDescriptor:scriptFontDescriptor size:[bodyFontSize floatValue] * 2.0F];
    NSDictionary *boldAttributes = [self createAttributesForFontStyle:UIFontTextStyleBody withTrait:UIFontDescriptorTraitBold];
    NSDictionary *italicAttributes = [self createAttributesForFontStyle:UIFontTextStyleBody withTrait:UIFontDescriptorTraitItalic];
    NSDictionary *scriptAttributes = @{NSFontAttributeName: scriptFont};
    
    // construct a dictionary of replacements based on regexes
    _replacements = @{
//                      @"^#\\w.*":  headingOneAttributes,
                      @"(\\*\\w+(.\\s\\w+)*\\*)" : boldAttributes,
                      @"(_\\w+(.\\s\\w+)*_)" : italicAttributes,
                      //@"(~\\w+(\\s\\w+)*~)\\s" : scriptAttributes,
                      };
}

- (NSDictionary *)createAttributesForFontStyle:(NSString *)style withTrait:(uint32_t)trait {
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:style];
    UIFontDescriptor *descriptorWithTrait = [fontDescriptor fontDescriptorWithSymbolicTraits:trait];
    UIFont *font = [UIFont fontWithDescriptor:descriptorWithTrait size:0.0];

    return @{NSFontAttributeName: font};
}

- (NSDictionary *)attributesWithDescriptor:(UIFontDescriptor *)descriptor size:(CGFloat)size {
    UIFont *font = [UIFont fontWithDescriptor:descriptor size:size];
    return @{NSFontAttributeName: font};
}

+ (void)removeMarkers:(NSTextStorage *)textStorage{
    // Remove unnecessary punctuations
    NSRegularExpression *regexBold = [NSRegularExpression regularExpressionWithPattern:@"(\\*\\w+(\\s\\w+)*\\*)" options:0 error:nil];
    
    NSArray *matchesBold = [regexBold matchesInString:[textStorage string] options:0 range:NSMakeRange(0, textStorage.length)];
    
    // Iterage over matches (bold) in reverse
    for (NSTextCheckingResult *result in matchesBold) {
        NSRange matchRange = [result range];
        NSString *foundStr = [[textStorage string] substringWithRange:matchRange];
        NSString *replacement = [foundStr substringWithRange:NSMakeRange(1, foundStr.length - 2)];
        [textStorage replaceCharactersInRange:matchRange withString:replacement];
    }
}

@end
