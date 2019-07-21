#import <Foundation/Foundation.h>

@interface NSData (ChatBase64)

+ (NSData *)chat_dataWithBase64EncodedString:(NSString *)string;
- (NSString *)chat_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)chat_base64EncodedString;

@end

@interface NSString (ChatBase64)

+ (NSString *)chat_stringWithBase64EncodedString:(NSString *)string;
- (NSString *)chat_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)chat_base64EncodedString;
- (NSString *)chat_base64DecodedString;
- (NSData *)chat_base64DecodedData;

@end
