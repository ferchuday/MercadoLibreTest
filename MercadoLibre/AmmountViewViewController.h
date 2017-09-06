//
//  AmmountViewViewController.h
//  MercadoLibre
//
//  Created by federico carzoglio on 2/9/17.
//  Copyright © 2017 federico carzoglio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Callback.h"
#import "TextFieldValidator.h"


@interface AmmountViewViewController : UIViewController

@property (nonatomic) Callback *callback;

@property (weak, nonatomic) IBOutlet TextFieldValidator *txtAmmount;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityContinue;
@property (nonatomic)BOOL isSecondCall;

- (IBAction)btnContinuePushed:(id)sender;

@end
