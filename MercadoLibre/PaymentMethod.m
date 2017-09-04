//
//  PaymentMethod.m
//  MercadoLibre
//
//  Created by federico carzoglio on 3/9/17.
//  Copyright © 2017 federico carzoglio. All rights reserved.
//

#import "PaymentMethod.h"

@implementation PaymentMethod

@synthesize idPayment,name,sthumbnail,thumbnail;

-(id) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    self.idPayment  = [dictionary objectForKey:@"id"];
    self.name       = [dictionary objectForKey:@"name"];
    self.sthumbnail = [dictionary objectForKey:@"secure_thumbnail"];
    self.thumbnail  = [UIImage imageWithData: [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [dictionary objectForKey:@"thumbnail"]]]];
    
    return self;
}



@end
