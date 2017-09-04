//
//  Connection.m
//  MercadoLibre
//
//  Created by federico carzoglio on 2/9/17.
//  Copyright © 2017 federico carzoglio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Connection.h"
#import "AFNetworking.h"

@interface Connection ()

@end


@implementation Connection

#pragma Constantes
static NSString * const BASE_URL        = @"https://api.mercadopago.com/v1/payment_methods";

static NSString * const PUBLIC_KEY      = @"?public_key=444a9ef5-8a6b-429f-abdf-587639155d88";
static NSString * const PAYMENT_METHOD_ID = @"&payment_method_id=";
static NSString * const ISSUERS         = @"&issuer.id=";
static NSString * const AMMOUNT         = @"&amount=";

static NSString * const CARD_ISSUERS    = @"/card_issuers";
static NSString * const INSTALLMENTS    = @"/installments";



-(void) getPaymentMethods:(NSDictionary*)parameters callBack:(Callback*)callback 
{
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"%@%@",BASE_URL,PUBLIC_KEY ] parameters:nil error:nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [[manager dataTaskWithRequest:request  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable errorToReturn)
      {
          [callback onResponse:[(NSHTTPURLResponse *)response statusCode] dicctionaryBody:responseObject];
          
      }] resume];
}

-(void) getbanks:(NSDictionary*)parameters callBack:(Callback*)callback paymentMethod:(NSString*)payment
{
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"%@%@%@%@%@",BASE_URL,CARD_ISSUERS,PUBLIC_KEY,PAYMENT_METHOD_ID ,payment] parameters:nil error:nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [[manager dataTaskWithRequest:request  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable errorToReturn)
      {
          [callback onResponse:[(NSHTTPURLResponse *)response statusCode] dicctionaryBody:responseObject];
          
      }] resume];
}

-(void) getInstallments:(NSDictionary*)parameters callBack:(Callback*)callback paymentMethod:(NSString*)payment ammount:(NSString*)ammount issure:(NSString*)issureSelected
{
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",BASE_URL,INSTALLMENTS,PUBLIC_KEY,AMMOUNT,ammount,PAYMENT_METHOD_ID ,payment,ISSUERS,issureSelected] parameters:nil error:nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [[manager dataTaskWithRequest:request  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable errorToReturn)
      {
          [callback onResponse:[(NSHTTPURLResponse *)response statusCode] dicctionaryBody:responseObject];
          
      }] resume];
}

@end
