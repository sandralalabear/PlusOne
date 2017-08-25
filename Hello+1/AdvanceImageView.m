//
//  AdvanceImageView.m
//  HelloMyAdvanceImageView
//
//  Created by H.M.L on 2017/3/29.
//  Copyright © 2017年 H.M.L. All rights reserved.
//

#import "AdvanceImageView.h"

@implementation AdvanceImageView
{
    UIActivityIndicatorView *loadingView; // instance variable for loading image view
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)loadImageWithURL:(NSURL *)url
{
    [self preparingToDownload]; //prepare the loading pic first...
    
    //Cache Support
    
    //算出url的唯一檔名
    NSString *hashedFilename = [NSString stringWithFormat:@"Cache_%ld",[url hash]];
    NSURL *cachesURL = [[NSFileManager defaultManager]
                         URLsForDirectory:NSCachesDirectory
                                inDomains:NSUserDomainMask].firstObject;
    NSString *fullFilePathname = [cachesURL.path stringByAppendingPathComponent:hashedFilename];
    
    NSLog(@"Caches Path: %@",cachesURL.path);
    
    UIImage *cachedImage = [UIImage imageWithContentsOfFile:fullFilePathname];
    if(cachedImage != nil)
    {
        self.image = cachedImage;
        return;
    }
    self.image = nil;
    
    //Start animation of loadingView
    [loadingView startAnimating];
    
    //Start to download image from URL
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask * task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //Return when error occur.
        if(error)
        {
            NSLog(@"Error:%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [loadingView stopAnimating];
                //Show default image or ...
            });

            return;
        }
        
        UIImage *image = [UIImage imageWithData:data];
        
        //Must change to UI Queue/Thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingView stopAnimating];
            self.image = image;
        });
        
        //Save data as a cache file
        //下載成功才要做咩
        [data writeToFile:fullFilePathname atomically:true];
    }];

    [task resume]; //start the task
    
}

- (void)preparingToDownload
{
    //Remove exist loadingView if necessary
    if(loadingView)
    {
        [loadingView removeFromSuperview];
    }
    
    //create loadingView
    CGSize selfSize = self.frame.size; // self is imageView
    CGRect loadingViewFrame = CGRectMake(0, 0, selfSize.width, selfSize.height);
    
    loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loadingView.color = [UIColor blueColor];
    loadingView.hidesWhenStopped = true;
    loadingView.frame = loadingViewFrame;
    
    [self addSubview:loadingView];
}



@end
