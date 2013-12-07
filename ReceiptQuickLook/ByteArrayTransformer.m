//
// Receipt QuickLook Plugin.
// Copyright (c) 2013 Laurent Etiemble.
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
#import "ByteArrayTransformer.h"

@implementation ByteArrayTransformer

/**
 * @brief Return the destination type.
 */
+ (Class)transformedValueClass {
    return [NSString class];
}

/**
 * @brief No reverse transformation is allowed.
 */
+ (BOOL)allowsReverseTransformation {
    return NO;
}

/**
 * @brief The NSData bytes are printed as hexa-decimal value separated by a ':'.
 * @param value The value to transform
 * @return A string representation of the data
 */
- (id)transformedValue:(id)value {
    if (![value isKindOfClass:[NSData class]]) {
        return nil;
    }
    NSData *data = (NSData *)value;
    const unsigned char *bytes = [data bytes];
    NSMutableString *buffer = [[NSMutableString alloc] init];
    for(NSUInteger i = 0; i < [data length]; i++) {
        if (i > 0 ) {
            [buffer appendString:@":"];
        }
        [buffer appendFormat:@"%02X", bytes[i]];
    }
    return buffer;
}

@end
