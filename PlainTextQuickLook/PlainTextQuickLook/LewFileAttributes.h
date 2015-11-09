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

@property (readonly) BOOL isTextFile;
@property (readonly) NSString *mimeType;
@property (readonly) NSString *fileExtension;
@property (readonly) NSString *fileName;

+ (instancetype)fileAttributesForItemAtURL:(NSURL *)URL bundleURL:(NSURL *)bundleURL;


- (NSString *)fileBadge;
@end
