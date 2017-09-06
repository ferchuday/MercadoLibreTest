//
//  SearchCreditCardTableViewController.m
//  MercadoLibre
//
//  Created by federico carzoglio on 3/9/17.
//  Copyright © 2017 federico carzoglio. All rights reserved.
//

#import "SearchCreditCardTableViewController.h"
#import "CreditCardTableViewCell.h"
#import "Bank.h"
#import "Connection.h"
#import "AppDelegate.h"
#import "SearchBankTableViewController.h"
#import "PaymentMethod.h"

@interface SearchCreditCardTableViewController ()
{
    NSMutableArray * filteredCards;
    NSMutableArray* banksArray;
    BOOL isFiltered;
}

@end

@implementation SearchCreditCardTableViewController

@synthesize cardList,callback;

- (void)viewDidLoad {
    [super viewDidLoad];
    isFiltered = false;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isFiltered) {
        return [filteredCards count];//[searchBanks count];
    } else {
        return [self.cardList count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CreditTableViewCell";
    
    CreditCardTableViewCell *cell = (CreditCardTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CreditCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    PaymentMethod *payment;
    
    if (isFiltered) {
        payment = [filteredCards objectAtIndex:indexPath.row];
    }
    else
    {
         payment = [self.cardList objectAtIndex:indexPath.row];
    }
    cell.lblName.text = payment.name;
    cell.imgCard.image = payment.thumbnail;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PaymentMethod * payment;
    if (isFiltered) {
        payment = [filteredCards objectAtIndex:indexPath.row];
    } else {
        payment = [cardList objectAtIndex:indexPath.row];
    }
    // Por codigo
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.color= [UIColor blackColor];
    [self.tableView addSubview:spinner];
    spinner.center = self.tableView.center;
    
    [spinner startAnimating];
    
    self.callback = [[Callback alloc]init:self onSuccess:^(NSDictionary *dictionary) {
        
        AppDelegate *app =(AppDelegate*)[[UIApplication sharedApplication] delegate];
        [app.selection setObject:payment.idPayment forKey:@"payment"];
        
        banksArray = [[NSMutableArray alloc] init];
        for (NSDictionary*dic in dictionary) {
            Bank *bankToSave = [[Bank alloc] initWithDictionary:dic];
            [banksArray addObject:bankToSave];
        }
         [spinner stopAnimating];
        if (banksArray.count == 0) {
            [self openPopUpError];
        }
        else
        {
            [self performSegueWithIdentifier:@"amountToBanks" sender:self];
        }
        
    } onBadRequestError:^{
        //Se podria implementar directamente en el callback, que tiene una referencia de la view
        [spinner stopAnimating];
    } onGenericError:^{
        [spinner stopAnimating];
    } onFailure:^{
        [spinner stopAnimating];
    }];
    
 
    
    Connection *con = [[Connection alloc] init];
    [con getbanks:nil callBack:self.callback paymentMethod:payment.idPayment];
    
    
}


#pragma mark - SearchBar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        isFiltered = false;
    }else
    {
        isFiltered = true;
        filteredCards = [[NSMutableArray alloc]init];
        for (PaymentMethod *pay in cardList) {
            NSRange nameRange = [pay.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound) {
                [filteredCards addObject:pay];
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *navigationController = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"amountToBanks"])
    {
        SearchBankTableViewController *destViewController = (SearchBankTableViewController * ) navigationController ;
        destViewController.bankList = banksArray;

    }
}

-(void)openPopUpError
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error "
                                                                   message:@"La cuenta seleccionada no tiene bancos asociados."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* closeAction = [UIAlertAction actionWithTitle:@"Ok"
                                                          style:UIAlertActionStyleDefault
                                                        handler:nil];
    
    [alert addAction:closeAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}


@end
