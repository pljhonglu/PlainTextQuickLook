//
//  LewFileAttributes.m
//  PlainTextQuickLook
//
//  Created by pljhonglu on 15/11/9.
//  Copyright © 2015年 pljhonglu. All rights reserved.
//

#import "LewFileAttributes.h"


@interface LewFileAttributes ()
@property (readwrite) NSURL *url;
@property (readwrite) BOOL isTextFile;
@property (readwrite) NSString *mimeType;
@property (readwrite) NSString *fileExtension;
@property (readwrite) NSString *fileName;

@property (nonatomic)  NSString *fileBadge;

@end

@implementation LewFileAttributes

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

static NSDictionary<NSString *, NSString*> * MimeTypeToBadgeMap;
static NSDictionary<NSString *, NSString*> * FileNameToBadgeMap;

+ (instancetype)fileAttributesForItemAtURL:(NSURL *)URL bundleURL:(NSURL *)bundleURL{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
        NSString *mimeTypePath = [bundle pathForResource:@"mimeTypeToBadgeMap" ofType:@"plist"];
        MimeTypeToBadgeMap = [NSDictionary dictionaryWithContentsOfFile:mimeTypePath];
        
        NSString *fileNamePath = [bundle pathForResource:@"filenameToBadgeMap" ofType:@"plist"];
        FileNameToBadgeMap = [NSDictionary dictionaryWithContentsOfFile:fileNamePath];
    });
    
    LewFileAttributes *file = [[LewFileAttributes alloc]init];
    file.url = URL;
    file.fileExtension = [URL pathExtension];
    file.fileName = [URL lastPathComponent];
    file.isTextFile = NO;
    
    if (!file.fileExtension || file.fileExtension.length == 0) {
        [FileNameToBadgeMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            if ([file.fileName.lowercaseString isEqualToString:key]) {
                *stop = YES;
                file.fileBadge = obj;
                file.isTextFile = YES;
            }
        }];
    }else{
        CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef _Nonnull)(file.fileExtension), NULL);
        if (UTTypeConformsTo(UTI, kUTTypeText)) {
            file.isTextFile = YES;
        }
    
        CFStringRef mimeType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
        CFRelease(UTI);
        file.mimeType = (__bridge NSString *)(mimeType);
    }
    
    return file;
}


- (NSString *)fileBadge{
    if(!_isTextFile){
        return nil;
    }
    if (_fileBadge) {
        return _fileBadge;
    }
    
    if (_fileExtension.length < 10) {
        _fileBadge = _fileExtension;
    }else if(_mimeType && _mimeType.length > 0){
        _fileBadge = MimeTypeToBadgeMap[_mimeType];
    }
    
    return _fileBadge;
}
@end


