//
//  ServerCommunicator.m
//  buyer
//
//  Created by H.M.L on 2017/4/27.
//  Copyright © 2017年 H.M.L. All rights reserved.
//

#import "ServerCommunicator.h"
#import <AFNetworking.h>
//#import "TableViewController.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import "TableViewController.h"

@implementation ServerCommunicator

static ServerCommunicator * _singletonCommunicator = nil;

+ (instancetype)sharedInstance
{
    if(_singletonCommunicator == nil)
    {
        _singletonCommunicator = [ServerCommunicator new];
    }
    return _singletonCommunicator;
}

- (void)updateDeviceToken:(NSString *) deviceToken completion:(DoneHandler _Nonnull)done
{
    //(2)
    //USER_NAME_KEY等等是在.h檔的define寫好，將來要改直接改define，才不會出摟子...
    NSDictionary * parameters = @{@"username":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"login"][@"username"]],
                                  @"password":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"login"][@"password"]],
                                  @"devicetoken":deviceToken};
    [self doPostWithURLString:UPDATEDEVICETOKEN_URL
                   parameters:parameters
                         data:nil
                   completion:done];
}

- (void)sendTextMessage:(NSString *)sender
                message:(NSString *)message
               receiver:(NSString *)receiver
             completion:(DoneHandler)done
{
    // Prepare parameters
    NSDictionary *parameters = @{@"sender":sender,
                                 @"message":message,
                                 @"receiver":receiver};
    
    [self doPostJobWithURLString:CHATMESSAGE_INSERT_URL
                      parameters:parameters
                            data:nil
                      completion:done];
}

- (void)insertTextData:(NSDictionary *)parameters completion:(DoneHandler)done {
    
    [self doPostWithURLString:INSERT_URL
                   parameters:parameters
                         data:nil
                   completion:done];
    NSLog(@"fasdf");
}

- (void)doPostWithURLString:(NSString *)urlString parameters:(NSDictionary *)parameters data:(NSData *)data completion:(DoneHandler)done {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"doPOST Parameters: %@",jsonString);
    
    NSDictionary *finalParameters = @{@"data":jsonString};
    
    //Perform Post Action(上傳部分)
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //POST會開啟背景thread
    [manager POST:urlString
       parameters:finalParameters
         progress:nil //^(NSProgress * _Nonnull uploadProgress){ }  //上傳進度
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              if(done != nil) {
                  done(nil,responseObject);
              }
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
              NSLog(@"Post Fail: %@",error);
              if(done != nil) {
                  done(error,nil);
              }
          }];
}


- (void)selectTextData {
    NSDictionary *dd = [[NSDictionary alloc] init];
    [self doPostWithURLString:SELECT_URL
                   parameters:dd
                         data:nil
                   completion:^(NSError *error, id result) {
                   }];
}

//上傳圖片function
- (void)upLoadImages:(NSDictionary *)parameters :(NSData *)imageData {
    
    NSURL *documentsURL = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    NSString *filename = [NSString stringWithFormat:@"%@.jpg",[NSDate date]];
    NSURL *fullFilePathURL = [documentsURL URLByAppendingPathComponent:filename];
    [imageData writeToURL:fullFilePathURL atomically:true];
    
    [self doPostJobWithURLString:INSERT_DEAL_URL
                      parameters:parameters
                            data:imageData
                      completion:nil];
}

//更新圖片function
- (void)updateImages:(NSDictionary *)parameters :(NSData *)imageData {
    
    NSURL *documentsURL = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    NSString *filename = [NSString stringWithFormat:@"%@.jpg",[NSDate date]];
    NSURL *fullFilePathURL = [documentsURL URLByAppendingPathComponent:filename];
    [imageData writeToURL:fullFilePathURL atomically:true];
    
    [self doPostJobWithURLString:UPDATE_IMAGE_URL
                      parameters:parameters
                            data:imageData
                      completion:^(NSError *error, id result) {}];
}

- (void)downLoadImages:(NSString *)resultString
{
    self.imageData = [NSMutableArray new];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"image/jpeg"];
    NSString *finalFileURLString = [PHOTO_URL stringByAppendingPathComponent:resultString];
    NSLog(@"%@",finalFileURLString);
    [manager GET:finalFileURLString
      parameters:nil progress:nil
         success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 NSLog(@"zzzzzz%@",responseObject);
                 [self.imageData addObject:responseObject];
                 [[NSUserDefaults standardUserDefaults] setObject:self.imageData forKey:@"imagedata"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 //self.imagetest.image = [UIImage imageNamed:@"pikachu.jpg"];
                 //self.imagetest.image = [UIImage imageWithData:responseObject];
             });
             
             //done(nil,responseObject);
             
         } failure:^(NSURLSessionDataTask *_Nullable task, NSError* _Nonnull error) {
             //done(error,nil);
             NSLog(@"falsehahahaha");
         }];
}



- (void)doPostJobWithURLString:(NSString *)urlString
                    parameters:(NSDictionary *)parameters
                          data:(NSData *)data
                    completion:(DoneHandler)done
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"doPOST Parameters: %@",jsonString);
    
    NSDictionary *finalParameters = @{@"data":jsonString};
    NSLog(@"%@",finalParameters);
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:urlString
       parameters:finalParameters
constructingBodyWithBlock:
     ^(id<AFMultipartFormData>  _Nonnull formData) {
         
         if(data != nil) {
             [formData appendPartWithFileData:data
                                         name:@"fileToUpload"
                                     fileName:@"image.jpg"
                                     mimeType:@"image/jpg"];
         }
     }
         progress:nil
          success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject){
              if(done != nil) {
                  NSLog(@"success");
                      done(nil,responseObject);
              }
          }
          failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error){
              
              NSLog(@"doPOST Fail: %@",error);
              if(done != nil) {
                  done(error,nil);
              }
          }];
}

//Photos Support
- (void)savePhotoWithFilename:(NSString *)fileName data:(NSData *)fileData
{
    NSURL *fullFilenameURL = [self fullURLwithFilename:fileName];
    
    [fileData writeToURL:fullFilenameURL atomically:true];
}

- (UIImage *)loadPhotoWithFilename:(NSString *)fileName
{
    NSURL *fullFilenameURL = [self fullURLwithFilename:fileName];
    
    return [UIImage imageWithContentsOfFile:fullFilenameURL.path];
}

- (NSURL *)fullURLwithFilename:(NSString *)fileName
{
    //Find caches URL
    NSURL *cachesURL = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask].firstObject;
    //Decide filename that we really stored in storage
    NSString *hashedFilename = [NSString stringWithFormat:@"%lu.jpg", fileName.hash];
    
    return [cachesURL URLByAppendingPathComponent:hashedFilename];
}

-(UIImage *)handleIncomingMessages:(NSString *)filename
{
    UIImage *photo = [self loadPhotoWithFilename:filename];
    if(photo == nil)
    {
        //need to download photo
        [self downloadPhotoWithFileName:filename completion:^(NSError *error, id result) {
            
            //save result as a cache file
            if(result)
            {
                [self savePhotoWithFilename:filename data:result];
            }
            
            self.image = [UIImage imageWithData:result];
            NSLog(@"Download");
        }];
        return self.image;
    }
    else
    {
        NSLog(@"caches");
        return photo;
    }
}

- (void)downloadPhotoWithFileName:(NSString *)fileName
                      completion:(DoneHandler)done {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"image/jpeg"];
    
    NSString *finalURLString = [PHOTO_URL stringByAppendingPathComponent:fileName];
    
    [manager GET:finalURLString
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
         //responseObject->原始資料的raw data
         NSLog(@"Download File OK: %ld bytes",[responseObject length]);
         
         [self.imageArray addObject:responseObject];

         //dispatch_async(dispatch_get_main_queue(), ^{
         //    [self.imageArray addObject:responseObject];
         //});
         
         done(nil,responseObject);
             
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
         NSLog(@"Download File Fail: %@",error);
         done(error,nil);
     }];
}

@end
