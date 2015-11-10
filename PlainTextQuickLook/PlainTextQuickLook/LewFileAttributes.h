//
//  LewFileAttributes.h
//  PlainTextQuickLook
//
//  Created by pljhonglu on 15/11/9.
//  Copyright © 2015年 pljhonglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LewFileAttributes : NSObject
@property (readonly) NSURL *url;

@property (nonatomic, assign, readonly) BOOL isTextFile;
@property (nonatomic, copy, readonly) NSString *mimeType;
@property (nonatomic, copy, readonly) NSString *fileExtension;
@property (nonatomic, copy, readonly) NSString *fileName;
@property (nonatomic, copy, readonly) NSString *fileBadge;

+ (instancetype)fileAttributesForItemAtURL:(NSURL *)URL bundleURL:(NSURL *)bundleURL;

@end
