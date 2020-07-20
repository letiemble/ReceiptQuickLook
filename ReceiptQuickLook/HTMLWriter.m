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
#import "HTMLWriter.h"
#import "ByteArrayTransformer.h"

#pragma ----- Private -----

@interface HTMLWriter()

- (void)writeDictionary:(NSDictionary *)object;

- (void)writeArray:(NSArray *)object;

- (void)writeData:(NSData *)object;

- (void)writeDate:(NSData *)object;

- (void)writeNumber:(NSNumber *)object;

- (void)writeString:(NSString *)object;

@end

#pragma ----- Implementation -----

@implementation HTMLWriter

/**
 * @brief Called when the called is loaded
 */
+ (void)initialize {
    // Create an instance of the transformer and register it
    ByteArrayTransformer *transformer = [[ByteArrayTransformer alloc] init];
    [NSValueTransformer setValueTransformer:transformer forName:BYTE_ARRAY_TRANSFORMER];
}

/**
 * @brief Default initializer
 */
- (id)init
{
    self = [super init];
    if (self) {
        [self reset];
    }
    return self;
}

- (NSString *)buffer {
    return self->_buffer;
}

- (void)reset {
    self->_buffer = [[NSMutableString alloc] init];
    self->_stack = [[NSMutableArray alloc] init];
}

- (void)startDocument {
    [self startElement:@"html"];
}

- (void)endDocument {
    [self endElement:@"html"];
}

- (void)startHead {
    [self startElement:@"head"];
}

- (void)endHead {
    [self endElement:@"head"];
}

- (void)writeTitle:(NSString *)title {
    [self startElement:@"title"];
    [self write:title];
    [self endElement:@"title"];
}

- (void)appendStyleSheet:(NSString *)styleSheet {
    NSDictionary *attributes = @{ @"rel" : @"stylesheet", @"type" : @"text/css", @"src" : styleSheet };
    [self startElement:@"link" withAttributes:attributes];
    [self endElement:@"link"];
}

- (void)startBody {
    [self startElement:@"body"];
}

- (void)endBody {
    [self endElement:@"body"];
}

- (void)startTable {
    [self startElement:@"table"];
}

- (void)startTableWithAttributes:(NSDictionary *)attributes {
    [self startElement:@"table" withAttributes:attributes];
}

- (void)endTable {
    [self endElement:@"table"];
}

- (void)startTableHeader {
    [self startElement:@"theader"];
}

- (void)endTableHeader {
    [self endElement:@"theader"];
}

- (void)startTableBody {
    [self startElement:@"tbody"];
}

- (void)endTableBody {
    [self endElement:@"tbody"];
}

- (void)startRow {
    [self startElement:@"tr"];
}

- (void)startRowWithAttributes:(NSDictionary *)attributes {
    [self startElement:@"tr" withAttributes:attributes];
}

- (void)endRow {
    [self endElement:@"tr"];
}

- (void)startCell {
    [self startElement:@"td"];
}

- (void)startCellWithAttributes:(NSDictionary *)attributes {
    [self startElement:@"td" withAttributes:attributes];
}

- (void)endCell {
    [self endElement:@"td"];
}

- (void)startElement:(NSString *)tag {
    [self startElement:tag withAttributes:nil];
}

- (void)startElement:(NSString *)tag withAttributes:(NSDictionary *)attributes {
    [self write:@"<"];
    [self write:tag];
    if (attributes) {
        for (NSString *attribute in attributes) {
            [self write:@" "];
            [self write:attribute];
            [self write:@"=\""];
            [self write:[attributes objectForKey:attribute]];
            [self write:@"\""];
        }
    }
    [self write:@">"];
    
    // Push the current tag
    [self->_stack addObject:tag];
}

- (void)endElement:(NSString *)tag {
    // Peek the current tag
    NSString *currentTag = [self->_stack lastObject];
    if (![currentTag isEqualToString:tag]) {
        [NSException raise:@"Tag mismatch" format:@"End tag '%@' does not mathc current tag '%@'", tag, currentTag];
    }
    [self write:@"</"];
    [self write:tag];
    [self write:@">"];
    
    // Pop the current tag
    [self->_stack removeLastObject];
}

- (void)write:(NSString *)text {
    [self->_buffer appendString:text];
}

- (void)writeObject:(id)object {
    Class cls = [object class];
    
    if ([cls isSubclassOfClass:[NSDictionary class]]) {
        [self writeDictionary:object];
    } else if ([cls isSubclassOfClass:[NSArray class]]) {
        [self writeArray:object];
    } else if ([cls isSubclassOfClass:[NSData class]]) {
        [self writeData:object];
    } else if ([cls isSubclassOfClass:[NSDate class]]) {
        [self writeDate:object];
    } else if ([cls isSubclassOfClass:[NSNumber class]]) {
        [self writeNumber:object];
    } else if ([cls isSubclassOfClass:[NSString class]]) {
        [self writeString:object];
    } else {
        [self write:[object description]];
    }
}

- (void)writeDictionary:(NSDictionary *)object {
    [self startTable];
    [self startTableBody];
    
    NSDictionary *labelAttributes = @{ @"class" : @"label" };
    NSDictionary *valueAttributes = @{ @"class" : @"value" };
    
    for (id key in object) {
        [self startRow];
        
        id value = [object objectForKey:key];
        NSString *format = [self formatForKey:key];
        NSString *label = [NSString stringWithFormat:format, key];
        
        [self startCellWithAttributes:labelAttributes];
        [self write:label];
        [self endCell];
        
        [self startCellWithAttributes:valueAttributes];
        [self writeObject:value];
        [self endCell];
        
        [self endRow];
    }
    
    [self endTableBody];
    [self endTable];
}

- (void)writeArray:(NSArray *)object {
    [self startTable];
    [self startTableBody];

    NSDictionary *itemAttributes = @{ @"class" : @"item" };
    
    for (NSUInteger i = 0; i < [object count]; i++) {
        id value = [object objectAtIndex:i];
        NSString *format = [self formatForIndex:i];
        NSString *label = [NSString stringWithFormat:format, (i + 1)];
        
        [self startRow];
        [self startCellWithAttributes:itemAttributes];
        [self write:label];
        [self endCell];
        [self endRow];
        
        [self startRow];
        [self startCell];
        [self writeObject:value];
        [self endCell];
        [self endRow];
    }
    
    [self endTableBody];
    [self endTable];
}

- (void)writeData:(NSData *)object {
    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:BYTE_ARRAY_TRANSFORMER];
    [self write:[transformer transformedValue:object]];
}

- (void)writeDate:(NSDate *)object {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss'Z'"];
    });
    [self write:[formatter stringFromDate:object]];
}

- (void)writeNumber:(NSNumber *)object {
    [self write:[object description]];
}

- (void)writeString:(NSString *)object {
    [self write:object];
}

-(NSString *)formatForIndex:(NSUInteger)index {
    return @"#%d";
}

-(NSString *)formatForKey:(id)key {
    return @"%@";
}

@end
