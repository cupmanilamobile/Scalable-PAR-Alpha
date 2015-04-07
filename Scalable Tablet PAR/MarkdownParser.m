//
//  MarkdownParser.m
//  Scalable-Table-PAR
//
//  Created by Julius Lundang on 3/26/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "MarkdownParser.h"
@import UIKit;

@implementation MarkdownParser {
    NSArray *_replacements;
    NSDictionary *_bodyTextAttributes;
    NSDictionary *_headingOneAttributes;
    NSDictionary *_headingTwoAttributes;
    NSDictionary *_headingThreeAttributes;
}

- (instancetype)init {
    if (self = [super init]) {
        [self createTextAttributes];
    }
    return self;
}

- (void)createTextAttributes {
    // create the font descriptors
    UIFontDescriptor *baskerville = [[UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody] fontDescriptorWithFamily:@"Baskerville"];
    UIFontDescriptor *baskervilleBold = [baskerville fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    
    // determine the current text size preference
    UIFontDescriptor *bodyFont = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    NSNumber *bodyFontSize = bodyFont.fontAttributes[UIFontDescriptorSizeAttribute];
    CGFloat bodyFontSizeValue = [bodyFontSize floatValue];
    
    // create the attributes for the various styles
    _bodyTextAttributes = [self attributesWithDescriptor:baskerville size:bodyFontSizeValue];
    _headingOneAttributes = [self attributesWithDescriptor:baskerville size:bodyFontSizeValue * 1.8F];
    _headingTwoAttributes = [self attributesWithDescriptor:baskerville size:bodyFontSizeValue * 1.6F];
    _headingThreeAttributes = [self attributesWithDescriptor:baskerville size:bodyFontSizeValue * 1.4F];
}

- (NSDictionary *)attributesWithDescriptor:(UIFontDescriptor *)descriptor size:(CGFloat)size {
    UIFont *font = [UIFont fontWithDescriptor:descriptor size:size];
    return @{ NSFontAttributeName: font };
}

- (NSAttributedString *)parseMarkdown:(NSString *)md {
    NSMutableAttributedString *parsedOutput = [[NSMutableAttributedString alloc] init];
    // 1. break the string into lines and iterate over each line
    NSString *text = md;
    NSArray *lines = [text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for (NSUInteger lineIndex = 0; lineIndex < lines.count; lineIndex++) {
        NSString *line = lines[lineIndex];
        
        if ([line isEqualToString:@""]) {
            continue;
        }
        
        // 2. math the various 'heading' styles
        __block NSDictionary *textAttributes = _bodyTextAttributes;
        if (line.length > 3) {
            if ([[line substringToIndex:3] isEqualToString:@"###"]) {
                textAttributes = _headingThreeAttributes;
                line = [line substringFromIndex:3];
            } else if ([[line substringToIndex:2] isEqualToString:@"##"]) {
                textAttributes = _headingTwoAttributes;
                line = [line substringFromIndex:2];
            } else if ([[line substringToIndex:1] isEqualToString:@"#"]) {
                textAttributes = _headingOneAttributes;
                line = [line substringFromIndex:1];
            }
        }
        
        // 3. apply the attributes to this line of text
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:line attributes:textAttributes];
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\*\\w+(.\\s\\w+)*\\*)" options:0 error:nil];
        [regex enumerateMatchesInString:[attributedText string] options:0 range:NSMakeRange(0, attributedText.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            NSRange matchRange = [result range];
            NSRange effectiveRange = NSMakeRange(0, 0);
            UIFont *font = [attributedText attribute:NSFontAttributeName atIndex:NSMaxRange(effectiveRange) effectiveRange:&effectiveRange];
            font = [self createAttributesForFontStyle:[font fontDescriptor] withTrait:UIFontDescriptorTraitBold];
            [attributedText addAttribute:NSFontAttributeName value:font range:matchRange];
        }];

        NSRegularExpression *regexSup = [NSRegularExpression regularExpressionWithPattern:@"<sup>([\\w]+)*.</sup>" options:0 error:nil];
        [regexSup enumerateMatchesInString:[attributedText string] options:0 range:NSMakeRange(0, attributedText.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            NSRange matchRange = [result range];
            NSRange effectiveRange = NSMakeRange(0, 0);
            UIFont *font = [attributedText attribute:NSFontAttributeName atIndex:NSMaxRange(effectiveRange) effectiveRange:&effectiveRange];
            font = [self createAttributesForFontStyle:[font fontDescriptor] withTrait:0];
            [attributedText addAttribute:NSBaselineOffsetAttributeName value:@10 range:matchRange];
        }];
        
        [self removeMarkers:attributedText pattern:@"(\\*\\w+(.\\s\\w+)*\\*)"];
        [self removeMarkers:attributedText pattern:@"<(/)?sup>"];
        
        // 4. append to the output
        [parsedOutput appendAttributedString:attributedText];
        [parsedOutput appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
    }
    return parsedOutput;
}

- (UIFont *)createAttributesForFontStyle:(UIFontDescriptor *)fontDescriptor withTrait:(uint32_t)trait {
    UIFontDescriptor *descriptorWithTrait = [fontDescriptor fontDescriptorWithSymbolicTraits:trait];
    UIFont *font = [UIFont fontWithDescriptor:descriptorWithTrait size:0.0];
    return font;
}

- (void)removeMarkers:(NSMutableAttributedString *)mutableAttributedString pattern:(NSString *)pattern {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    
    NSArray *matches = [regex matchesInString:[mutableAttributedString string] options:0 range:NSMakeRange(0, mutableAttributedString.length)];
    
    // Iterate over matche in reverse
    for (NSTextCheckingResult *result in [matches reverseObjectEnumerator]) {
        NSRange matchRange = [result range];
        NSString *foundString = [[mutableAttributedString string] substringWithRange:matchRange];
        NSString *replacement;
        if ([pattern isEqualToString:@"(\\*\\w+(.\\s\\w+)*\\*)"]) {
            replacement = [foundString substringWithRange:NSMakeRange(1, foundString.length - 2)];
        } else {
            replacement = @"";
        }
        [mutableAttributedString replaceCharactersInRange:matchRange withString:replacement];
    }
    
}
@end
