
#import <UIKit/UIKit.h>

@interface UIAlertController (SimpleAlert)
+ (UIAlertController *)showTipsInViewController:(UIViewController *)veiwController
                                        message:(NSString *)message;


+ (UIAlertController *)showTipsInViewController:(UIViewController *)veiwController
                                        message:(NSString *)message
                                    handleTitle:(NSString *)handleTitle
                                        handler:(void(^)(UIAlertAction *action))handler
                                         canceled:(void(^)(UIAlertAction *action))canceled;

+ (UIAlertController *)showActionSheetInViewController:(UIViewController *)veiwController
                                               message:(NSString *)message
                                                title1:(NSString *)title1
                                              handler1:(void(^)(UIAlertAction *action))handler1
                                                title2:(NSString *)title2
                                              handler2:(void(^)(UIAlertAction *action))handler2;

+ (UIAlertController *)showActionSheetInViewController:(UIViewController *)veiwController
                                               message:(NSString *)message
                                                titles:(NSArray *)titles
                                               handler:(void(^)(NSInteger buttonIndex, NSString *title))handler;
@end
