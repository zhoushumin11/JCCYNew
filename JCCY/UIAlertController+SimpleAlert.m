
#import "UIAlertController+SimpleAlert.h"

@implementation UIAlertController (SimpleAlert)

+ (UIAlertController *)showTipsInViewController:(UIViewController *)veiwController
                                        message:(NSString *)message{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    [alertVC addAction:confirm];
    [veiwController presentViewController:alertVC animated:YES completion:nil];
    return alertVC;
}


+ (UIAlertController *)showTipsInViewController:(UIViewController *)veiwController
                                        message:(NSString *)message
                                    handleTitle:(NSString *)handleTitle
                                        handler:(void(^)(UIAlertAction *action))handler
                                       canceled:(void (^)(UIAlertAction *action))canceled{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:handleTitle style:UIAlertActionStyleDefault handler:handler];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:canceled];
    [alertVC addAction:confirm];
    [alertVC addAction:cancel];
    [veiwController presentViewController:alertVC animated:YES completion:nil];
    return alertVC;
}

+ (UIAlertController *)showActionSheetInViewController:(UIViewController *)veiwController
                                               message:(NSString *)message
                                                title1:(NSString *)title1
                                              handler1:(void(^)(UIAlertAction *action))handler1
                                                title2:(NSString *)title2
                                              handler2:(void(^)(UIAlertAction *action))handler2{
    
    UIAlertController *actionVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleActionSheet];
    if (title1 && title1.length > 0) {
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:title1 style:UIAlertActionStyleDefault handler:handler1];
        [actionVC addAction:action1];
    }
    if (title2 && title2.length > 0) {
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:title2 style:UIAlertActionStyleDefault handler:handler2];
        [actionVC addAction:action2];
    }
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [actionVC addAction:actionCancel];
    [veiwController presentViewController:actionVC animated:YES completion:nil];
    return actionVC;
}

+ (UIAlertController *)showActionSheetInViewController:(UIViewController *)veiwController
                                               message:(NSString *)message
                                                titles:(NSArray *)titles
                                               handler:(void(^)(NSInteger buttonIndex, NSString *title))handler{
    
    void(^block)(UIAlertAction *action) = ^void(UIAlertAction *action){
        NSInteger index = 0;
        for (NSString *title in titles) {
            if ([title isEqualToString:action.title]) {
                if (handler) handler(index, title);
                break;
            }
            index ++;
        }
    };
    
    UIAlertController *actionVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSInteger i = 0; i < titles.count; i ++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:titles[i]
                                                         style:UIAlertActionStyleDefault
                                                       handler:block];
        [actionVC addAction:action];
    }
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    [actionVC addAction:cancel];
    [veiwController presentViewController:actionVC animated:YES completion:nil];
    return actionVC;
}
@end
