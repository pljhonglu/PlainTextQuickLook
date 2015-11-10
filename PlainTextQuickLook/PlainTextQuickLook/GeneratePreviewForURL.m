#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>

#import <Foundation/Foundation.h>
#import "LewFileAttributes.h"

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options);
void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview);

/* -----------------------------------------------------------------------------
   Generate a preview for file

   This function's job is to create preview for designated file
   ----------------------------------------------------------------------------- */

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options)
{
    // To complete your generator please implement the function GeneratePreviewForURL in GeneratePreviewForURL.c
    @autoreleasepool{
        if (QLPreviewRequestIsCancelled(preview))
            return noErr;
        
        CFBundleRef bundle = QLPreviewRequestGetGeneratorBundle(preview);
        CFURLRef bundleURL = CFBundleCopyBundleURL(bundle);
        LewFileAttributes *file = [LewFileAttributes fileAttributesForItemAtURL:(__bridge NSURL *)(url) bundleURL:(__bridge NSURL *)(bundleURL)];
        
        if (!file.isTextFile) {
            return noErr;
        }
        
        QLPreviewRequestSetURLRepresentation(preview, url, kUTTypePlainText, NULL);
        return noErr;
    }
}

void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview)
{
    // Implement only if supported
}
