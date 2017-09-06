//
//  Callback.h
//  MercadoLibre
//
//  Created by federico carzoglio on 2/9/17.
//  Copyright © 2017 federico carzoglio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void(^callbackWithDictionaryBlock)(NSDictionary* dictionary);
typedef void(^callbackEmptyBlock)();

@interface Callback : NSObject

@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) UIViewController* view;
@property (nonatomic, strong) callbackWithDictionaryBlock onSuccessBlock;             // 200
@property (nonatomic, strong) callbackEmptyBlock onBadRequestErrorBlock;              // 400
@property (nonatomic, strong) callbackEmptyBlock onGenericErrorBlock;                 // 500
@property (nonatomic, strong) callbackEmptyBlock onFailureBlock;                      // Error de conexion

- (id) init:(UIViewController *)view onSuccess:(callbackWithDictionaryBlock)onSuccesBlock onBadRequestError:(callbackEmptyBlock)onBadRequestErrorBlock onGenericError:(callbackEmptyBlock)onGenericErrorBlock onFailure:(callbackEmptyBlock)onFailureBlock;

- (void) onResponse:(NSInteger)code dicctionaryBody:(NSDictionary *)response;



@end
