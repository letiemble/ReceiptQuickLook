//
// Receipt QuickLook Plugin.
// Copyright (c) 2013-2020 Laurent Etiemble.
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

/**
 * @brief Generate a thumbnail for the given URL.
 * @param thisInterface TODO
 * @param thumbnail The thumbnail instance
 * @param url The URL of the file
 * @param contentTypeUTI The UTI of the file
 * @param options The options
 * @param maxSize The maximum size for the thumbnail
 */
OSStatus GenerateThumbnailForURL(void *thisInterface, QLThumbnailRequestRef thumbnail, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options, CGSize maxSize);

/**
 * @brief Cancels the generation of the thumbnail.
 * @param thisInterface TODO
 * @param thumbnail The thumbnail instance
 */
void CancelThumbnailGeneration(void *thisInterface, QLThumbnailRequestRef thumbnail);

#pragma ----- Implementation -----

OSStatus GenerateThumbnailForURL(void *thisInterface, QLThumbnailRequestRef thumbnail, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options, CGSize maxSize) {
    // Not supported
    return noErr;
}

void CancelThumbnailGeneration(void *thisInterface, QLThumbnailRequestRef thumbnail) {
    // Not supported
}
