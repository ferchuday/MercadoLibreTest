//
//  Bank.h
//  MercadoLibre
//
//  Created by federico carzoglio on 3/9/17.
//  Copyright © 2017 federico carzoglio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Bank : NSObject

@property (nonatomic) NSString* idBank;
@property (nonatomic) NSString* name;
@property (nonatomic) NSString* sthumbnail;
@property (nonatomic) UIImage*  thumbnail;


-(id) initWithDictionary:(NSDictionary*)dictionary;

@end
