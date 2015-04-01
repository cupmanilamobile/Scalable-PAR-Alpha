//
//  MarkdownMaker.m
//  Scalable-Table-PAR
//
//  Created by Julius Lundang on 3/26/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "MarkdownMaker.h"
#import "NSString+Markdown.h"

@implementation MarkdownMaker

+ (id)sharedManager {
    static MarkdownMaker *sharedMarkdown = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMarkdown = [[self alloc] init];
    });
    
    return sharedMarkdown;
}

- (id)init {
    return (self = [super init]);
}

- (NSString *)convertAbstractDataToMarkdown:(NSData *)data{
    _document = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    
    // title
    GDataXMLElement *title = [_document nodesForXPath:@"//article-title" error:nil][0];
    NSString *mdTitle = [[title XMLString] stringByReplacingOccurencesOfRegEx:@"<(/)?italic>"];
    mdTitle = [NSString stringWithFormat:@"#%@", [mdTitle stringByStrippingHTML]];
    
    // contributors
    GDataXMLElement *contribGroup = [_document nodesForXPath:@"//contrib-group" error:nil][0];
    NSMutableString *mdContribGroup = [[NSMutableString alloc] initWithString:@"#"];
    NSArray *contribs = [contribGroup nodesForXPath:@"contrib" error:nil];
    [contribs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        GDataXMLElement *name = [obj nodesForXPath:@"name" error:nil][0];
        NSArray *xrefs = [obj nodesForXPath:@"xref" error:nil];
        [mdContribGroup appendString:[NSString stringWithFormat:@"%@ ", [[name nodesForXPath:@"given-names" error:nil][0] stringValue]]];
        [mdContribGroup appendString:[NSString stringWithFormat:@"%@", [[name nodesForXPath:@"surname" error:nil][0] stringValue]]];
        [xrefs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([[[obj attributeForName:@"ref-type"] stringValue] isEqual:@"corresp"]) {
                [mdContribGroup appendString:[NSString stringWithFormat:@" <sup>c%@</sup> ", [obj stringValue]]];
            } else if ([[[obj attributeForName:@"ref-type"] stringValue] isEqual:@"fn"]) {
                [mdContribGroup appendString:[NSString stringWithFormat:@"<sup>p%@</sup>", [obj stringValue]]];
            }else {
                [mdContribGroup appendString:[NSString stringWithFormat:@"<sup>a%@</sup>", [obj stringValue]]];
            }
        }];
    }];
    
    // affiliations
    NSArray *aff = [_document nodesForXPath:@"//aff" error:nil];
    NSMutableString *mdAff = [[NSMutableString alloc] init];
    [aff enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSArray *children = [obj children];
        [children enumerateObjectsUsingBlock:^(id iobj, NSUInteger iidx, BOOL *istop) {
            if (iidx == 0) {
                [mdAff appendString:[[[iobj nodesForXPath:@"//label/sup" error:nil] objectAtIndex:idx] XMLString]];
            } else {
                [mdAff appendString:[iobj stringValue]];
            }
        }];
        if (idx < [aff count]) {
            [mdAff appendString:@"\n"];
        }
    }];

    // abstract
    GDataXMLElement *abstract = [_document nodesForXPath:@"//abstract" error:nil][0];
    NSString *summary = [[[[abstract nodesForXPath:@".//title" error:nil] firstObject] XMLString] stringByStrippingHTML];
    NSMutableString *mdAbstract = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"#%@\n\n", summary]];
    NSArray *abstractChildren = [abstract children];
    [abstractChildren enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx > 0) {
            [mdAbstract appendString:[[[obj XMLString] stringByStrippingHTML] stringByReplacingOccurencesOfRegEx:@"<(/)?italic>"]];
            if (idx < [abstractChildren count]) {
                [mdAbstract appendString:@"\n\n"];
            }
        }
    }];

    // date histories
    NSArray *dateHistory = [_document nodesForXPath:@"//date" error:nil];
    NSMutableString *mdDateHistory = [[NSMutableString alloc] init];
    [dateHistory enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *dateType;
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        format.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        NSDate *date;
        if ([[[obj attributeForName:@"date-type"] stringValue] isEqualToString:@"received"]) {
            dateType = @"Received";
        } else if ([[[obj attributeForName:@"date-type"] stringValue] isEqualToString:@"rev-recd"]) {
            dateType = @"Revised";
        } else if ([[[obj attributeForName:@"date-type"] stringValue] isEqualToString:@"accepted"]) {
            dateType = @"Accepted";
        }
        date = [format dateFromString:[NSString stringWithFormat:@"%@-%@-%@",
                                       [[[obj nodesForXPath:@".//year" error:nil] firstObject] stringValue],
                                       [[[obj nodesForXPath:@".//month" error:nil] firstObject] stringValue],
                                       [[[obj nodesForXPath:@".//day" error:nil] firstObject] stringValue]]];
        [format setDateFormat:@"MMMM dd yyyy"];
        [mdDateHistory appendFormat:[NSString stringWithFormat:@"(%@ %@)", dateType, [format stringFromDate:date]]];
        if (idx < [dateHistory count]) {
            [mdDateHistory appendFormat:@"\n"];
        }
    }];
    
    // circulation date
    GDataXMLElement *circulationDate = [[_document nodesForXPath:@"//pub-date[@pub-type='epub']" error:nil] firstObject];
    NSMutableString *mdCirculationDate = [[NSMutableString alloc] init];
    if (circulationDate== nil) {
        circulationDate = [[_document nodesForXPath:@"//pub-date[@pub-type='ppub']" error:nil] firstObject];
    }
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    format.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDate *circDate = [format dateFromString:[NSString stringWithFormat:@"%@-%@-%@",
                                               [[[circulationDate nodesForXPath:@".//year" error:nil] firstObject] stringValue],
                                               [[[circulationDate nodesForXPath:@".//month" error:nil] firstObject] stringValue],
                                               [[[circulationDate nodesForXPath:@".//day" error:nil] firstObject] stringValue]]];
    [format setDateFormat:@"MMMM dd yyyy"];
    [mdCirculationDate appendString:[NSString stringWithFormat:@"(Online publication %@)", [format stringFromDate:circDate]]];
    
    // key words
    GDataXMLElement *keywords = [[_document nodesForXPath:@"//kwd-group" error:nil] firstObject];
    NSMutableString *mdKeywords = [[NSMutableString alloc] init];
    NSString *keywordTitle = [[[keywords nodesForXPath:@".//title" error:nil] firstObject] stringValue];
    [mdKeywords appendString:[NSString stringWithFormat:@"%@\n", keywordTitle]];
    [[keywords children] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx > 0) {
            [mdKeywords appendString:[[[obj XMLString] stringByStrippingHTML] stringByReplacingOccurencesOfRegEx:@"<(/)?italic>"]];
            if (idx < [[keywords children] count]) {
                [mdKeywords appendString:@"; "];
            }
        }
    }];
    
    // author notes
    NSArray *authorNotes = [[[_document nodesForXPath:@"//author-notes" error:nil] firstObject] children];
    NSMutableString *mdAuthorNotes = [[NSMutableString alloc] init];
    [mdAuthorNotes appendString:@"Correspondence\n\n"];
    [authorNotes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([[obj name] isEqualToString:@"corresp"]) {
            NSString *label = [[[obj nodesForXPath:@".//label" error:nil] firstObject]stringValue];
            [mdAuthorNotes appendString:[NSString stringWithFormat:@"<sup>c%@</sup>", label]];
        } else if ([[obj name] isEqualToString:@"fn"]) {
            NSString *label = [[[obj nodesForXPath:@".//label" error:nil] firstObject]stringValue];
            [mdAuthorNotes appendString:[NSString stringWithFormat:@"<sup>p%@</sup>", label]];
        }
        [[obj children] enumerateObjectsUsingBlock:^(id iobj, NSUInteger iidx, BOOL *istop) {
            if (iidx > 0) {
                [mdAuthorNotes appendString:[iobj stringValue]];
            }
        }];
        if (idx < [authorNotes count]) {
            [mdAuthorNotes appendString:@"\n"];
        }
    }];
    
    return [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@\n%@%@\n\n%@\n\n%@",
            mdTitle, mdContribGroup, mdAff, mdAbstract, mdDateHistory, mdCirculationDate, mdKeywords, mdAuthorNotes];
}



@end
