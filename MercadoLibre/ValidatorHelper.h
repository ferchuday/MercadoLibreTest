//
//  ValidatorHelper.h
//  MercadoLibre
//
//  Created by federico carzoglio on 2/9/17.
//  Copyright © 2017 federico carzoglio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TextFieldValidator.h"

@interface ValidatorHelper : NSObject

//Metodos
//-(id) init:(NSString*)image;

-(BOOL) validateNotEmpty:(TextFieldValidator*)field;

-(BOOL) validateNumber:(TextFieldValidator*)field;

-(BOOL) validateAmount:(TextFieldValidator*)field;

@end

