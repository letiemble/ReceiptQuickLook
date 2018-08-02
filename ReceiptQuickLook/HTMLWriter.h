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
#import <Foundation/Foundation.h>

typedef NSString *(^HTMLWriterLabelProvider)(id value);

/**
 * @brief Used to serialize an object into a HTML document.
 */
@interface HTMLWriter : NSObject {
    /** @brief The HTML buffer. */
    NSMutableString *_buffer;
    /** @brief The tag stack. */
    NSMutableArray *_stack;
}

/**
 * @brief Returns the HTML buffer.
 */
- (NSString *)buffer;

/**
 * @brief Reset the buffer and the internal stack.
 */
- (void)reset;

/**
 * @brief Start the HTML document.
 */
- (void)startDocument;

/**
 * @brief End the HTML document.
 */
- (void)endDocument;

/**
 * @brief Start the head section of the HTML document.
 */
- (void)startHead;

/**
 * @brief End the head section of the HTML document.
 */
- (void)endHead;

/**
 * @brief Create a title for the HTML document.
 */
- (void)writeTitle:(NSString *)title;

/**
 * @brief Append a a stylesheet link for the HTML document.
 */
- (void)appendStyleSheet:(NSString *)styleSheet;

/**
 * @brief Start the body section of the HTML document.
 */
- (void)startBody;

/**
 * @brief End the body section of the HTML document.
 */
- (void)endBody;

/**
 * @brief Start a HTML table.
 */
- (void)startTable;

/**
 * @brief Start a HTML table.
 * @param attributes The attributes to set on the table.
 */
- (void)startTableWithAttributes:(NSDictionary *)attributes;

/**
 * @brief End a HTML table.
 */
- (void)endTable;

/**
 * @brief Start a HTML table header.
 */
- (void)startTableHeader;

/**
 * @brief End a HTML table header.
 */
- (void)endTableHeader;

/**
 * @brief Start a HTML table body.
 */
- (void)startTableBody;

/**
 * @brief End a HTML table body.
 */
- (void)endTableBody;

/**
 * @brief Start a HTML table row.
 */
- (void)startRow;

/**
 * @brief Start a HTML table row.
 * @param attributes The attributes to set on the table row.
 */
- (void)startRowWithAttributes:(NSDictionary *)attributes;

/**
 * @brief End a HTML table row.
 */
- (void)endRow;

/**
 * @brief Start a HTML table cell.
 */
- (void)startCell;

/**
 * @brief Start a HTML table cell.
 * @param attributes The attributes to set on the table cell.
 */
- (void)startCellWithAttributes:(NSDictionary *)attributes;

/**
 * @brief End a HTML table cell.
 */
- (void)endCell;

/**
 * @brief Start a HTML tag.
 * @param tag The tag name.
 */
- (void)startElement:(NSString *)tag;

/**
 * @brief Start a HTML tag.
 * @param tag The tag name.
 * @param attributes The attributes to set on the table cell.
 */
- (void)startElement:(NSString *)tag withAttributes:(NSDictionary *)attributes;

/**
 * @brief End a HTML table tag.
 * @param tag The tag name.
 */
- (void)endElement:(NSString *)tag;

/**
 * @brief Write the text.
 * @param text The text to write
 */
- (void)write:(NSString *)text;

/**
 * @brief Write an object.
 * @param object The object to write
 */
- (void)writeObject:(id)object;

/**
 * @brief Return a format string for the given index. Used when outputting array.
 * @param index The index.
 * @return A format string that can be used with the index.
 */
-(NSString *)formatForIndex:(NSUInteger)index;

/**
 * @brief Return a format string for the given key. Used when outputting dictionary.
 * @param key The key.
 * @return A format string that can be used with the key.
 */
-(NSString *)formatForKey:(id)key;

@end
