//
//  LewFileAttributes.m
//  PlainTextQuickLook
//
//  Created by pljhonglu on 15/11/9.
//  Copyright © 2015年 pljhonglu. All rights reserved.
//

#define FNExtensionsBlackList @"ExtensionsBlackList"
#define FNFileNameWhiteList @"FileNameWhiteList"
#define FNFileNameToBadgeMap @"FileNameToBadgeMap"
#define FNExtensionsWhiteList @"ExtensionsWhiteList"

#import "LewFileAttributes.h"

@interface LewFileAttributes ()
@property (nonatomic, assign) BOOL isTextFile;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, copy) NSString *mimeType;
@property (nonatomic, copy) NSString *fileExtension;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *fileBadge;

@end

@implementation LewFileAttributes

static NSDictionary<NSString *, NSString*> * MimeTypeToBadgeMap;
static NSBundle *BUNDLE;

+ (instancetype)fileAttributesForItemAtURL:(NSURL *)URL bundleURL:(NSURL *)bundleURL{
    
    LewFileAttributes *file = [[LewFileAttributes alloc]init];
    file.url = URL;
    file.fileExtension = [URL pathExtension];
    file.fileName = [URL lastPathComponent];
    file.isTextFile = NO;
    
    BUNDLE = [NSBundle bundleWithURL:bundleURL];
    
    if (!file.fileExtension || file.fileExtension.length == 0) {
        NSString *fileNameWhiteListPath = [BUNDLE pathForResource:FNFileNameWhiteList ofType:@"plist"];
        NSArray<NSString *> *fileNameWhiteList = [NSArray arrayWithContentsOfFile:fileNameWhiteListPath];
        if ([fileNameWhiteList containsObject:file.fileName]) {
            file.isTextFile = YES;
        }
    }else{
        NSString *extensionBlackListPath = [BUNDLE pathForResource:FNExtensionsBlackList ofType:@"plist"];
        NSArray<NSString *> *extensionBlackList = [NSArray arrayWithContentsOfFile:extensionBlackListPath];
        if (![extensionBlackList containsObject:file.fileName]) {
            CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef _Nonnull)(file.fileExtension), NULL);
            if (UTTypeConformsTo(UTI, kUTTypeText)) {
                file.isTextFile = YES;
            }else{
                NSString *extensionWhiteListPath = [BUNDLE pathForResource:FNExtensionsWhiteList ofType:@"plist"];
                NSArray<NSString *> *extensionWhiteList = [NSArray arrayWithContentsOfFile:extensionWhiteListPath];
                if ([extensionWhiteList containsObject:file.fileExtension]) {
                    file.isTextFile = YES;
                }
            }
            CFStringRef mimeType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
            CFRelease(UTI);
            file.mimeType = (__bridge NSString *)(mimeType);
        }
    }

    return file;
}

#pragma mark - getter
- (NSString *)fileBadge{
    if(!_isTextFile){
        return nil;
    }
    
    MimeTypeToBadgeMap = @{
                           @"application/xml": @"xml",
                           @"text/x-c"       : @"C",
                           @"text/x-c++"     : @"C++",
                           @"text/x-shellscript" : @"shell",
                           @"text/x-php"     : @"php",
                           @"text/x-python"  : @"python",
                           @"text/x-perl"    : @"perl",
                           @"text/x-ruby"    : @"ruby"
                           };
    
    if (!_fileExtension || _fileExtension.length == 0) {
        NSString *fileNameToBadgeMapPath = [BUNDLE pathForResource:FNFileNameToBadgeMap ofType:@"plist"];
        NSDictionary<NSString *, NSString *> *fileNameToBadgeMap = [NSDictionary dictionaryWithContentsOfFile:fileNameToBadgeMapPath];
        _fileBadge = fileNameToBadgeMap[_fileName];
    }else{
        if (_fileExtension.length < 10) {
            _fileBadge = _fileExtension;
        }else if(_mimeType && _mimeType.length > 0){
            _fileBadge = MimeTypeToBadgeMap[_mimeType];
        }
    }
    if (!_fileBadge || _fileBadge.length == 0) {
        _fileBadge = @"unknown";
    }
    
    return _fileBadge;
}
@end


