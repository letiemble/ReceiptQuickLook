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
#import <openssl/asn1.h>
#import <openssl/bio.h>
#import <openssl/objects.h>
#import <openssl/pkcs7.h>
#import <openssl/x509.h>
#import <Foundation/Foundation.h>

/**
 * @brief Keys for each receipt attribute
 */
typedef enum _ReceiptAttributeType {
    /** @brief Bundle identifier */
    ReceiptAttributeTypeBundleId = 2,
    /** @brief Application version */
    ReceiptAttributeTypeBundleVersion = 3,
    /** @brief Opaque value */
    ReceiptAttributeTypeOpaqueValue = 4,
    /** @brief Hash value */
    ReceiptAttributeTypeHash = 5,
    /** @brief Creation date */
    ReceiptAttributeTypeCreationDate = 12,
    /** @brief In-app purchase receipt */
    ReceiptAttributeTypeInAppPurchase = 17,
    /** @brief Original Application Version */
    ReceiptAttributeTypeOriginalApplicationVersion = 19,
    /** @brief Receipt Expiration Date */
    ReceiptAttributeTypeExpirationDate = 21,
    /** @brief Quantity */
    InAppAttributeTypeQuantity = 1701,
    /** @brief Product identifier */
    InAppAttributeTypeProductIdentifer = 1702,
    /** @brief Transaction identifier */
    InAppAttributeTypeTransactionIdentifer = 1703,
    /** @brief Purchase date */
    InAppAttributeTypePurchaseDate = 1704,
    /** @brief Original transaction identifier */
    InAppAttributeTypeOriginalTransactionIdentifer = 1705,
    /** @brief Original purchase date */
    InAppAttributeTypeOriginalPurchaseDate = 1706,
    /** @brief Subscription Expiration Date */
    InAppAttributeTypeSubscriptionExpirationDate = 1708,
    /** @brief Web Order Line Item ID */
    InAppAttributeTypeWebOrderLineItemId = 1711,
    /** @brief Cancellation Date */
    InAppAttributeTypeCancellationDate = 1712,
    /** @brief Subscription Introductory Price Period */
    InAppAttributeTypeSubscriptionIntroductoryPricePeriod = 1719,
} ReceiptAttributeType;

/**
 * @brief Wrapper class around a cryptographic receipt generated by the App Stores.
 */
@interface Receipt : NSObject {
    NSArray *_certificates;
    NSArray *_signers;
    NSDictionary *_dictionary;
}

/**
 * @brief Initialize this instance with the receipt's data.
 * @param data The receipt's data
 * @return A wrapper instance
 */
- (id)initWithData:(NSData *)data;

/**
 * @brief Return an array of dictionaries that contains all the parsed certificates of the receipt.
 * @return An array of dictionaries.
 */
- (NSArray *)certificates;

/**
 * @brief Return an array of dictionaries that contains all the parsed signers certificates of the receipt.
 * @return An array of dictionaries.
 */
- (NSArray *)signers;

/**
 * @brief Return a dictionary that contains all the parsed attributes of the receipt.
 * @return A dictionary containing the attributes.
 */
- (NSDictionary *)dictionary;

/**
 * @brief Performs a preliminary parsing to check if the data may be a cryptographic receipt.
 * @param data The receipt's data
 * @return YES if the data may be a valid cryptographic receipt; NO otherwise.
 */
+ (BOOL)looksLikeAReceiptFile:(NSData *)data;

@end
