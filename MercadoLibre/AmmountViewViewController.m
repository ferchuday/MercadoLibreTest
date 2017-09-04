//
//  AmmountViewViewController.m
//  MercadoLibre
//
//  Created by federico carzoglio on 2/9/17.
//  Copyright © 2017 federico carzoglio. All rights reserved.
//

#import "AFNetworking.h"
#import "AmmountViewViewController.h"
#import "ValidatorHelper.h"
#import "Connection.h"
#import "PaymentMethod.h"
#import "SearchCreditCardTableViewController.h"
#import "AppDelegate.h"

@interface AmmountViewViewController ()
{
    NSMutableArray *creditCardArray;
    TextFieldValidator *activeField;
}

@end

@implementation AmmountViewViewController
@synthesize btnContinue, activityContinue,isSecondCall;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
    
    if (self.isSecondCall) {
        [self openPopUpfinish];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UINavigationController *navigationController = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"ammountToCreditCard"])
    {
        SearchCreditCardTableViewController *destViewController = (SearchCreditCardTableViewController * ) navigationController ;
        destViewController.cardList = creditCardArray;
        
        //Se podria crear la clase modelo, que con un singleton y crear la variable selection ahi adentro
        AppDelegate *app =(AppDelegate*)[[UIApplication sharedApplication] delegate];
        [app.selection setObject:self.txtAmmount.text forKey:@"ammount"];
    }

}

-(void) configView
{
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
        [singleTap setNumberOfTapsRequired:1];
        [singleTap setNumberOfTouchesRequired:1];
        [self.view addGestureRecognizer:singleTap];
}

-(BOOL)validateFields
{

    self.txtAmmount.text = [self.txtAmmount.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    ValidatorHelper *validate=[[ValidatorHelper alloc] init];
    
    if (![validate validateNotEmpty:self.txtAmmount]) {
        return false;
    }
    
    if (![validate validateAmount:self.txtAmmount]) {
        return false;
    }
    
    // Me parecio bueno hacerlo de esta manera, al margen que seleccionando el tipo de teclado nunca daria false esta validacion
    if (![validate validateNumber:self.txtAmmount]) {
        return false;
    }
    
    return true;
}

- (IBAction)btnContinuePushed:(id)sender {
    
    if ([self validateFields]) {
       
        [self.btnContinue.titleLabel  removeFromSuperview];
        [self.btnContinue setEnabled:false];
        [self.activityContinue startAnimating];

        self.callback = [[Callback alloc]init:self onSuccess:^(NSDictionary *dictionary) {
            
            creditCardArray = [[NSMutableArray alloc] init];
            for (NSDictionary*dic in dictionary) {
                PaymentMethod *paymentToSave = [[PaymentMethod alloc] initWithDictionary:dic];
                [creditCardArray addObject:paymentToSave];
            }
            [self stopAnimation];
            [self performSegueWithIdentifier:@"ammountToCreditCard" sender:self];
            
        } onBadRequestError:^{
            //Se podria implementar directamente en el callback, que tiene una referencia de la view
            [self stopAnimation];
        } onGenericError:^{
            [self stopAnimation];
        } onFailure:^{
            [self stopAnimation];
            [self openPopUpConectionError];
            
        }];
        
        Connection *con = [[Connection alloc] init];
        [con getPaymentMethods:nil callBack:self.callback];
    }
    
}

#pragma Funciones de teclado

- (void)textFieldDidBeginEditing:(TextFieldValidator *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

- (IBAction)resignOnTap:(id)sender {
    [activeField resignFirstResponder];
    
}

-(void)stopAnimation
{
    self.btnContinue.titleLabel.attributedText=[[NSAttributedString alloc] initWithString:@"Continuar" ];
    [self.btnContinue addSubview:self.btnContinue.titleLabel];
    [self.btnContinue setEnabled:YES];
    [self.activityContinue stopAnimating];
}

-(void)openPopUpConectionError
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error de conexión"
                                                                   message:@"En estos momentos el servidor no se encuentra disponible. Inténtelo más tarde."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* closeAction = [UIAlertAction actionWithTitle:@"Ok"
                                                          style:UIAlertActionStyleDefault
                                                        handler:nil];
    
    [alert addAction:closeAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)openPopUpfinish
{
    
    AppDelegate *app =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Datos elegidos"
                                                                   message:[NSString stringWithFormat:@"Monto: %@\r Banco:%@\r Tarjeta:%@\rCuotas:%@",
                                                                            [app.selection objectForKey:@"ammount"],
                                                                            [app.selection objectForKey:@"issure"],
                                                                            [app.selection objectForKey:@"payment"],
                                                                            [app.selection objectForKey:@"cuotas"]]
                                                                            
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* closeAction = [UIAlertAction actionWithTitle:@"Ok"
                                                          style:UIAlertActionStyleDefault
                                                        handler:nil];
    
    [alert addAction:closeAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}


@end
