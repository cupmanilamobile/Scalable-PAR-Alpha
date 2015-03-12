//
//  Misc.m
//  Scalable Tablet App
//
//  Created by cvflores on 8/24/14.
//  Copyright (c) 2014 cvflores. All rights reserved.
//

#import "Misc.h"

@implementation Misc
//@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
//@synthesize managedObjectContext = _managedObjectContext;
//@synthesize managedObjectModel = _managedObjectModel;
//
//

-(NSString *) stringByStrippingHTML: string {
    NSRange r;
    NSString *s = [string copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}
+(void)downloadingServerImageFromUrl:(UIImageView*)imgView AndUrl:(NSString*)strUrl{
    NSString* theFileName = [NSString stringWithFormat:@"%@.png",[[strUrl lastPathComponent] stringByDeletingPathExtension]];
    NSFileManager *fileManager =[NSFileManager defaultManager];
    NSString *fileName = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"tmp/%@",theFileName]];
    
    imgView.backgroundColor = [UIColor darkGrayColor];
    UIActivityIndicatorView *actView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [imgView addSubview:actView];
    [actView startAnimating];
    CGSize boundsSize = imgView.bounds.size;
    CGRect frameToCenter = actView.frame;
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    actView.frame = frameToCenter;
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        NSData *dataFromFile = nil;
        NSData *dataFromUrl = nil;
        
        dataFromFile = [fileManager contentsAtPath:fileName];
        if(dataFromFile==nil){
            dataFromUrl=[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:strUrl]] ;
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if(dataFromFile!=nil){
                imgView.image = [UIImage imageWithData:dataFromFile];
            }else if(dataFromUrl!=nil){
                imgView.image = [UIImage imageWithData:dataFromUrl];
                NSString *fileName = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"tmp/%@",theFileName]];
                
                BOOL filecreationSuccess = [fileManager createFileAtPath:fileName contents:dataFromUrl attributes:nil];
                if(filecreationSuccess == NO){
                    NSLog(@"Failed to create the html file");
                }
                
            }else{;
                imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"issuecover%i.jpg", [self randomNumber:1 largest:5]]];
            }
            [actView removeFromSuperview];
            [imgView setBackgroundColor:[UIColor clearColor]];
        });
    });
}

+ (int)randomNumber:(int)smallest largest:(int)largest {
    int random = smallest + arc4random() % (largest+1-smallest);
    return random;
}

//
//-(void)save:(NSData* ) receivedData
//{
//    NSString *temp = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
//    temp = [temp stringByAppendingString:[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]];
//    
//    
//    
//    NSLog(@"Data received: %@", [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]);
//    NSRange range = [temp rangeOfString:@"/action/issueSubmits"];
//    
//    temp = [temp substringFromIndex:range.location];
//    range = [temp rangeOfString:@"</form"];
//    temp = [temp substringToIndex:range.location];
//    range = [temp rangeOfString:@"checkboxspace-related"];
//    
//    NSMutableArray *articleList = [[NSMutableArray alloc] initWithCapacity:0];
//    NSMutableArray *articleLinks = [[NSMutableArray alloc] initWithCapacity:0];
//    int i = 0;
//    while(range.length >0){
//        
//        
//        
//        
//        temp = [temp substringFromIndex:range.location];
//        
//        range = [temp rangeOfString:@"<span class=\"mathjaxImage\" style=\"display: none;\">"];
//        
//        
//        NSString *articleTemp = [[NSString alloc]initWithString:[temp substringFromIndex:range.location]];
//        
//        
//        range = [articleTemp rangeOfString:@"displayAbstract?"];
//        NSString *link = [articleTemp substringFromIndex:range.location];
//        
//        range = [link rangeOfString:@"\">"];
//        link = [link substringToIndex:range.location ];
//        
//        
//        
//        [articleLinks addObject:link];
//        
//        range = [articleTemp rangeOfString:@"</span>"];
//        articleTemp = [articleTemp substringToIndex:range.location];
//        range = [articleTemp rangeOfString:@">"];
//        
//        articleTemp = [articleTemp substringFromIndex:range.location];
//        NSMutableString *mutableTemp = [[NSMutableString alloc] initWithString:articleTemp];
//        
//        [mutableTemp replaceCharactersInRange:[articleTemp rangeOfString:@">"] withString:@""];
//        
//        
//        NSLog(@"Data 567123! %@", mutableTemp);
//        
//        
//        
//        [articleList addObject:mutableTemp];
//        
//        range = [temp rangeOfString:mutableTemp];
//        
//        temp = [temp substringFromIndex:range.location];
//        
//        range = [temp rangeOfString:@"checkboxspace-related"];
//        
//        
//        
//        
//    };
//    
//      NSLog(@"Succeeded!");
//    
//}
//-(void)addVolume:(id)sender
//{
//    _managedObjectContext = [CoreDataHelper manageObjectContext];
//
//    Volume *volume = [NSEntityDescription insertNewObjectForEntityForName:@"Volume" inManagedObjectContext:_managedObjectContext];
//
//    [volume setVolume:[NSNumber numberWithInt:100]];
//    [volume setVolumeTitle:@"Trial"];
//    [volume setVolumeId:[NSNumber numberWithInt:100100]];
//    [volume setVolumeCover:@"http://journals.cambridge.org/cover_images/FLM/FLM749_-1.jpg"];
//    
//    
//    
//    NSError *error = nil;
//    UIAlertView *alertView = nil;
//    if (![_managedObjectContext save:&error]) {
//        alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error occurred. Please try again later." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    } else {
//        alertView = [[UIAlertView alloc] initWithTitle:@"Registration" message:@"User has been successfully added." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    }
// 
//    [alertView show];
//}
//-(void)addIssue:(id)sender
//{
//    _managedObjectContext = [CoreDataHelper manageObjectContext];
//    
//    Issue *issue = [NSEntityDescription insertNewObjectForEntityForName:@"Issue" inManagedObjectContext:_managedObjectContext];
//    
//    [issue setVolume:[NSNumber numberWithInt:100]];
//    [issue setIssueTitle:@" Issue Trial"];
//    [issue setIssueId:[NSNumber numberWithInt:100102]];
//    [issue setIssue:[NSNumber numberWithInt:1]];
//    [issue setIssueCover:@"http://journals.cambridge.org/cover_images/FLM/FLM749_-1.jpg"];
//    [issue setIssueLink:@"http://journals.cambridge.org/cover_images/FLM/FLM749_-1.jpg"];
//    
//    
//    
//    NSError *error = nil;
//    UIAlertView *alertView = nil;
//    if (![_managedObjectContext save:&error]) {
//        alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error occurred. Please try again later." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    } else {
//        alertView = [[UIAlertView alloc] initWithTitle:@"Registration" message:@"User has been successfully added." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    }
//    
//    [alertView show];
//}
//-(void)addArticle:(id)sender
//{
//    _managedObjectContext = [CoreDataHelper manageObjectContext];
//    
//    Article *article = [NSEntityDescription insertNewObjectForEntityForName:@"Article" inManagedObjectContext:_managedObjectContext];
//    
//    [article setVolume:[NSNumber numberWithInt:100]];
//    [article setArticleTitle:@"Article Trial"];
//    [article setArticleId:[NSNumber numberWithInt:1001001]];
//    [article setArticleLink:@"http://journals.cambridge.org/cover_images/FLM/FLM749_-1.jpg"];
//    [article setIssue:[NSNumber numberWithInt:1]];
//    
//
//    
//    NSError *error = nil;
//    UIAlertView *alertView = nil;
//    if (![_managedObjectContext save:&error]) {
//        alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error occurred. Please try again later." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    } else {
//        alertView = [[UIAlertView alloc] initWithTitle:@"Registration" message:@"User has been successfully added." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    }
//    
//    [alertView show];
//}
//
//-(NSManagedObject*)instantiateManagedObject:(NSString*)managedObjectType{
//    
//    _managedObjectContext = [CoreDataHelper manageObjectContext];
//    
//    NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:managedObjectType inManagedObjectContext:_managedObjectContext];
//    
//    
//    return managedObject;
//    
//}
//-(BOOL)saveManagedObject{
//    
//    NSError *error = nil;
//
//    if (![_managedObjectContext save:&error]) {
//        return false;
//
//    } else {
//        return true;
//
//    }
//  
//    
//}
//-(NSArray *)fetchObjects:(NSDictionary*)predicates type:(NSString *)type
//{
//    _managedObjectContext = [CoreDataHelper manageObjectContext];
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:type inManagedObjectContext:_managedObjectContext];
//    
//    NSEnumerator* predicateKeysEnumarator  = [predicates keyEnumerator];
//    NSMutableString* predicateString = [[NSMutableString alloc] init];
//    NSString* attribute;
//    while((attribute =[predicateKeysEnumarator nextObject])){
//        
//        predicateString = [[predicateString stringByAppendingFormat:@"%@ == %@ and ",attribute,[predicates valueForKey:attribute]] mutableCopy];
//        
//    }
//    
//    predicateString= [[predicateString substringToIndex:predicateString.length-4] mutableCopy];
//   // [NSPredicate predicateWit]
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
//    
//    [request setEntity:entity];
//    [request setPredicate:predicate];
//    //NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"issueTitle" ascending:YES];
//    //NSArray *arr = [[NSArray alloc] initWithObjects:sortDescriptor1, nil];
////  @[sortDescriptor1];
//    //[request setSortDescriptors:arr];
//
//    NSError *error;
//    NSArray *results = [_managedObjectContext executeFetchRequest:request error:&error];
// 
//    return results;
//}
//
#pragma NSURLConnection
+ (NSURLConnection *)getURLConnection:(NSString *)link param:(NSString *)param id:(id)delegate
{
    NSMutableString* mutableLink = [[NSMutableString alloc] initWithString:link];
    [mutableLink replaceOccurrencesOfString:@"xxx" withString:param options:NSLiteralSearch range: NSMakeRange(0, [mutableLink length])];
    [mutableLink replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSLiteralSearch range: NSMakeRange(0, [mutableLink length])];
    NSURL *myURL = [NSURL URLWithString:[mutableLink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"loading url : %@", myURL );
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:myURL];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"cjo", @"cjo"];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    
    return [NSURLConnection connectionWithRequest:myRequest delegate:delegate];
    
}

//#pragma LoadingActivity
//+ (UIActivityIndicatorView *)loadActivityView:(CGSize)boundsSize
//{
//    UIActivityIndicatorView *loadingActivityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    CGAffineTransform transform = CGAffineTransformMakeScale(2.0f, 2.0f);
//    loadingActivityView.transform = transform;
//    //CGSize boundsSize = scrollView.bounds.size;
//    CGRect frameToCenter = loadingActivityView.frame;
//    // center horizontally
//    if (frameToCenter.size.width < boundsSize.width)
//        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
//    else
//        frameToCenter.origin.x = 0;
//    
//    // center vertically
//    if (frameToCenter.size.height < boundsSize.height)
//        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
//    else
//        frameToCenter.origin.y = 0;
//    
//    loadingActivityView.frame = frameToCenter;
//    
//    return loadingActivityView;
//}

@end
