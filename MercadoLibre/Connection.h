//
//  Connection.h
//  MercadoLibre
//
//  Created by federico carzoglio on 2/9/17.
//  Copyright © 2017 federico carzoglio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Callback.h"


@interface Connection : NSObject

-(void) getPaymentMethods:(NSDictionary*)parameters callBack:(Callback*)callback;
-(void) getbanks:(NSDictionary*)parameters callBack:(Callback*)callback paymentMethod:(NSString*)payment;
-(void) getInstallments:(NSDictionary*)parameters callBack:(Callback*)callback paymentMethod:(NSString*)payment ammount:(NSString*)ammount issure:(NSString*)issureSelected;

@end
