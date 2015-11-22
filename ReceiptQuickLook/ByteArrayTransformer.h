//
// Receipt QuickLook Plugin.
// Copyright (c) 2013-2015 Laurent Etiemble.
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
#import <Foundation/Foundation.h>

/**
 * @brief The name of the value transformer.
 */
#define BYTE_ARRAY_TRANSFORMER  @"ByteArray"

/**
 * @brief A value transformer to convert a NSData instance into a human readable representation.
 */
@interface ByteArrayTransformer : NSValueTransformer

@end
