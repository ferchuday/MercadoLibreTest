//
//  Callback.m
//  MercadoLibre
//
//  Created by federico carzoglio on 2/9/17.
//  Copyright © 2017 federico carzoglio. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "Callback.h"


@interface Callback ()

@end

@implementation Callback

- (id) init:(UIViewController *)view onSuccess:(callbackWithDictionaryBlock)onSuccesBlock onBadRequestError:(callbackEmptyBlock)onBadRequestErrorBlock onGenericError:(callbackEmptyBlock)onGenericErrorBlock onFailure:(callbackEmptyBlock)onFailureBlock
{
    self = [super init];
    self.view                   = view;
    self.onSuccessBlock         = onSuccesBlock;
    self.onBadRequestErrorBlock = onBadRequestErrorBlock;
    self.onGenericErrorBlock    = onGenericErrorBlock;
    self.onFailureBlock         = onFailureBlock;
    return self;
    
}

- (void) onResponse:(NSInteger)code dicctionaryBody:(NSDictionary *)response
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    switch (code) {
            
        case 200:
            self.onSuccessBlock(response);
            
            break;
            
        case 400:
        {
            self.onBadRequestErrorBlock(response);
            break;
            
        }
//        case 409:
//        {
////            if ([self.view isKindOfClass:[AddOtherBankViewController class]]) {
////                UIAlertController * alert = [UIAlertController
////                                             alertControllerWithTitle:@""
////                                             message:[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]]
////                                             preferredStyle:UIAlertControllerStyleAlert];
////                
////                UIAlertAction* acceptButton = [UIAlertAction
////                                               actionWithTitle:@"Aceptar"
////                                               style:UIAlertActionStyleDefault
////                                               handler:^(UIAlertAction * action) {
////                                                   
////                                                   [[NSNotificationCenter defaultCenter]
////                                                    postNotificationName:@"ErrorDniAddingAccount"
////                                                    object:self];
////                                                   
////                                               }];
////                [alert addAction:acceptButton];
////                
////                [(UIViewController*) self.view presentViewController:alert animated:YES completion:nil];
////            }
//            
//            break;
//        }
        case 500:
            self.onGenericErrorBlock();
            break;
            
        default:
            self.onFailureBlock();
            
            break;
    }
    
}


@end
