//
//  ServerCommunicator.h
//  buyer
//
//  Created by H.M.L on 2017/4/27.
//  Copyright © 2017年 H.M.L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^DoneHandler)(NSError *error, id result);

@interface ServerCommunicator : NSObject
@property (strong, nonatomic) NSMutableDictionary *resultDicObject;
@property (strong, nonatomic) NSMutableArray *resultAryObject;
@property (strong, nonatomic) NSString *resultStrObject;
@property (strong, nonatomic) NSMutableArray *imageData;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSMutableArray *imageArray;
//@property (strong,nonatomic) NSMutableArray *cachesImage;

+ (instancetype)sharedInstance;

- (void)updateDeviceToken:(NSString *)deviceToken completion:(DoneHandler)done;

- (void)insertTextData:(NSDictionary *)username
            completion:(DoneHandler)done;

- (void)sendTextMessage:(NSString *)sender
                 message:(NSString *)message
                receiver:(NSString *)receiver
              completion:(DoneHandler)done;

- (void)selectTextData;

- (void)upLoadImages:(NSDictionary *)parameters :(NSData *)imageData;

- (void)updateImages:(NSDictionary *)parameters :(NSData *)imageData;

- (void)downloadPhotoWithFileName:(NSString *)fileName
                      completion:(DoneHandler)done;

- (void)savePhotoWithFilename:(NSString *)fileName data:(NSData *)fileData;

- (void)doPostWithURLString:(NSString *)urlString
                parameters:(NSDictionary *)parameters
                      data:(NSData *)data
                completion:(DoneHandler)done;

- (void)doPostJobWithURLString:(NSString*) urlString
                    parameters:(NSDictionary*) parameters
                          data:(NSData*) data
                    completion:(DoneHandler) done;

- (void)downLoadImages:(NSString *)resultString;

- (UIImage *)handleIncomingMessages:(NSString *)filename;

@end
