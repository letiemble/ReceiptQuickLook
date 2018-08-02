//
// Receipt QuickLook Plugin.
// Copyright (c) 2013-2018 Laurent Etiemble.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>
#include <Foundation/Foundation.h>
#import "Receipt.h"
#import "HTMLWriter.h"
#import "ReceiptHTMLWriter.h"

/**
 * @brief Generate a preview for the given URL.
 * @param thisInterface TODO
 * @param thumbnail The preview instance
 * @param url The URL of the file
 * @param contentTypeUTI The UTI of the file
 * @param options The options
 * @param maxSize The maximum size for the thumbnail
 */
OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options);

/**
 * @brief Cancels the generation of the preview.
 * @param thisInterface TODO
 * @param thumbnail The preview instance
 */
void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview);

#pragma ----- Implementation -----

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options) {
    @autoreleasepool {
        NSURL *nsurl = (__bridge NSURL *)url;
        NSData *data = [NSData dataWithContentsOfURL:nsurl];
        if (!data) {
            return noErr;
        }

        // The above might have taken some time, so before proceeding make sure the user didn't cancel the request
        if (QLPreviewRequestIsCancelled(preview)) {
            return noErr;
        }

        // If the file is not receipt, does nothing
        if (![Receipt looksLikeAReceiptFile:data]) {
            return noErr;
        }
        
        // Parse the receipt
        Receipt *receipt = [[Receipt alloc] initWithData:data];

        // Load a CSS stylesheet to insert it into the HTML
        NSBundle *bundle = [NSBundle bundleForClass:[HTMLWriter class]];
        NSURL *cssFile = [bundle URLForResource:@"receipt" withExtension:@"css"];
        NSString *cssContent =[NSString stringWithContentsOfURL:cssFile encoding:NSUTF8StringEncoding error:nil];
        
        // Perform the HTML generation
        HTMLWriter *writer = [[ReceiptHTMLWriter alloc] init];
        [writer startDocument];
        [writer startHead];
        [writer writeTitle:[nsurl lastPathComponent]];
        [writer startElement:@"style"];
        [writer write:cssContent];
        [writer endElement:@"style"];
        [writer endHead];
        [writer startBody];

        [writer startElement:@"h3"];
        [writer write:@"Receipt"];
        [writer endElement:@"h3"];
        [writer writeObject:[receipt dictionary]];

        [writer startElement:@"h3"];
        [writer write:@"Certificates"];
        [writer endElement:@"h3"];
        [writer writeObject:[receipt certificates]];

        [writer startElement:@"h3"];
        [writer write:@"Signers"];
        [writer endElement:@"h3"];
        [writer writeObject:[receipt signers]];

        [writer endBody];
        [writer endDocument];
        
        // Put metadata in a dictionary
        NSString *html = [writer buffer];
        NSDictionary *properties = @{
            // properties for the HTML data
            (__bridge NSString *)kQLPreviewPropertyTextEncodingNameKey : @"UTF-8",
            (__bridge NSString *)kQLPreviewPropertyMIMETypeKey : @"text/html",
        };
        
        // Pass preview data and metadata/attachment dictionary to QuickLook
        QLPreviewRequestSetDataRepresentation(preview,
                                              (__bridge CFDataRef)[html dataUsingEncoding:NSUTF8StringEncoding],
                                              kUTTypeHTML,
                                              (__bridge CFDictionaryRef)properties);
    }
    return noErr;
}

void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview) {
    // Not supported
}
