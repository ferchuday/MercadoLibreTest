//
//  ValidatorHelper.m
//  MercadoLibre
//
//  Created by federico carzoglio on 2/9/17.
//  Copyright © 2017 federico carzoglio. All rights reserved.
//

#import "ValidatorHelper.h"

#define ImgAlertRed  [UIImage imageNamed:@"ic_alert"]

@interface ValidatorHelper ()

@end

@implementation ValidatorHelper

#pragma Constantes
static NSString * const Validate_number = @"[0-9]+(\\.[0-9][0-9]?)?";  //[0-9]+(\.[0-9][0-9]?)?

//-(id)init:(NSString*)image
//{
//    self = [super init];
//    imgAlert =ImgAlertRed;//[UIImage imageNamed:image];
//    return self;
//

-(BOOL) validateNotEmpty:(TextFieldValidator*)field{
    if ([field.text length] ==0) {
        [field showCustomError:@"Campo obligatorio." image:ImgAlertRed];
        return false;
    }else{
        return true;
    }
}

-(BOOL) validateAmount:(TextFieldValidator*)field{
    if (!([field.text floatValue] > 0) ) {
        [field showCustomError:@"El monto debe ser mayor a 0." image:ImgAlertRed];
        return false;
    }else{
        return true;
    }
}

-(BOOL) validateNumber:(TextFieldValidator*)field
{
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:Validate_number
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:field.text
                                                        options:0
                                                          range:NSMakeRange(0, [field.text length])];
    
    if (numberOfMatches==0){
        
        [field showCustomError:@"Caracteres numéricos." image:ImgAlertRed];
        return false;
    }
    else
        return true;
}




@end
