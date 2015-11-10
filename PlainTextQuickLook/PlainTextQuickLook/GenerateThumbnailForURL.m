#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>
#import <Foundation/Foundation.h>
#import "LewFileAttributes.h"

OSStatus GenerateThumbnailForURL(void *thisInterface, QLThumbnailRequestRef thumbnail, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options, CGSize maxSize);
void CancelThumbnailGeneration(void *thisInterface, QLThumbnailRequestRef thumbnail);

/* -----------------------------------------------------------------------------
    Generate a thumbnail for file

   This function's job is to create thumbnail for designated file as fast as possible
   ----------------------------------------------------------------------------- */

OSStatus GenerateThumbnailForURL(void *thisInterface, QLThumbnailRequestRef thumbnail, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options, CGSize maxSize)
{
    // To complete your generator please implement the function GenerateThumbnailForURL in GenerateThumbnailForURL.c
    @autoreleasepool{
        if (QLThumbnailRequestIsCancelled(thumbnail))
            return noErr;
        
        CFBundleRef bundle = QLThumbnailRequestGetGeneratorBundle(thumbnail);
        CFURLRef bundleURL = CFBundleCopyBundleURL(bundle);
        LewFileAttributes *file = [LewFileAttributes fileAttributesForItemAtURL:(__bridge NSURL *)(url) bundleURL:(__bridge NSURL *)(bundleURL)];
        if (!file.isTextFile) {
            return noErr;
        }
        
        NSDictionary *properties = @{(NSString *)kQLThumbnailPropertyExtensionKey: file.fileBadge};
        
        QLThumbnailRequestSetThumbnailWithURLRepresentation(thumbnail, url, kUTTypePlainText, NULL, (__bridge CFDictionaryRef)(properties));
        
        return noErr;
    }
}

void CancelThumbnailGeneration(void *thisInterface, QLThumbnailRequestRef thumbnail)
{
    // Implement only if supported
}
