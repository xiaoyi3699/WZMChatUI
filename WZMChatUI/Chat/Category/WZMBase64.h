#import <Foundation/Foundation.h>

@interface NSData (WZMBase64)

+ (NSData *)chat_dataWithchat_base64EncodedString:(NSString *)string;
- (NSString *)chat_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)chat_base64EncodedString;

@end

@interface NSString (WZMBase64)

+ (NSString *)chat_stringWithchat_base64EncodedString:(NSString *)string;
- (NSString *)chat_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)chat_base64EncodedString;
- (NSString *)chat_base64DecodedString;
- (NSData *)chat_base64DecodedData;

@end
