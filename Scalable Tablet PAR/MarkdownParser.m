//
//  MarkdownParser.m
//  Scalable-Table-PAR
//
//  Created by Julius Lundang on 3/26/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "MarkdownParser.h"
#import <UIKit/UIKit.h>

@implementation MarkdownParser {
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
    _headingOneAttributes = [self attributesWithDescriptor:baskervilleBold size:bodyFontSizeValue * 2.0F];
    _headingTwoAttributes = [self attributesWithDescriptor:baskervilleBold size:bodyFontSizeValue * 1.8F];
    _headingThreeAttributes = [self attributesWithDescriptor:baskervilleBold size:bodyFontSizeValue * 1.4F];
}

- (NSDictionary *)attributesWithDescriptor:(UIFontDescriptor *)descriptor size:(CGFloat)size {
    UIFont *font = [UIFont fontWithDescriptor:descriptor size:size];
    return @{NSFontAttributeName: font};
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
        NSDictionary *textAttributes = _bodyTextAttributes;
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
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:line attributes:textAttributes];
        
        // 4. append to the output
        [parsedOutput appendAttributedString:attributedText];
        [parsedOutput appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
    }
    return parsedOutput;
}

@end
