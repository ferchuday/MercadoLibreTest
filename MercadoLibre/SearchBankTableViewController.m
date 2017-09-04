//
//  SearchBankTableViewController.m
//  MercadoLibre
//
//  Created by federico carzoglio on 3/9/17.
//  Copyright © 2017 federico carzoglio. All rights reserved.
//

#import "SearchBankTableViewController.h"
#import "CreditCardTableViewCell.h"
#import "Bank.h"
#import "Connection.h"
#import "AppDelegate.h"
#import "AmmountViewViewController.h"

@interface SearchBankTableViewController ()<UMAlertViewDelegate>
{
    NSMutableArray * filteredCards;
    BOOL isFiltered;
}

@end

@implementation SearchBankTableViewController

@synthesize bankList,callback;

- (void)viewDidLoad {
    [super viewDidLoad];
    isFiltered = false;
    
    
    self.umAlertView = [[UMAlertView alloc] init];
    self.umAlertView.delegate = self;

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
        return [self.bankList count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CreditTableViewCell";
    
    //Reutilizo la viewCell
    CreditCardTableViewCell *cell = (CreditCardTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CreditCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Bank *bank;
    
    if (isFiltered) {
        bank = [filteredCards objectAtIndex:indexPath.row];
    }
    else
    {
        bank = [self.bankList objectAtIndex:indexPath.row];
    }
    cell.lblName.text   = bank.name;
    cell.imgCard.image  = bank.thumbnail;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Bank * bank;
    if (isFiltered) {
        bank = [filteredCards objectAtIndex:indexPath.row];
    } else {
        bank = [self.bankList objectAtIndex:indexPath.row];
    }
    // Por codigo
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.tableView addSubview:spinner];
    spinner.tintColor = [UIColor blackColor];
    spinner.center = self.tableView.center;
    
    [spinner startAnimating];
    
    self.callback = [[Callback alloc]init:self onSuccess:^(NSDictionary *dictionary) {

        NSError * err;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&err];
        NSMutableArray *mutable = [[NSMutableArray alloc] init];
        mutable = [NSJSONSerialization JSONObjectWithData: jsonData options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary* dict = [[NSDictionary alloc] init];
        dict = mutable[0];
        AppDelegate *app =(AppDelegate*)[[UIApplication sharedApplication] delegate];
        [app.selection setObject:bank.idBank forKey:@"issure"];
        
        NSMutableArray *stringArray =[[NSMutableArray alloc]init];
        for (NSDictionary *dic in [dict objectForKey:@"payer_costs"]) {
            [stringArray addObject:[dic objectForKey:@"recommended_message"]];
        }
        if (stringArray.count > 0) {
            [self.umAlertView um_showAlertViewTitle:@"Cantidad de cuotas" pickerData:stringArray haveCancelButton:YES completion:^{
                [spinner stopAnimating];
            }];
        }else
        {
            //TODO: No hay cuotas a mostrar
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
    NSMutableDictionary *dictionary =((AppDelegate*)[[UIApplication sharedApplication] delegate]).selection;
    [con getInstallments:nil callBack:self.callback paymentMethod:[dictionary objectForKey:@"payment"] ammount:[dictionary objectForKey:@"ammount"] issure:bank.idBank];
    

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
        for (Bank *bank in self.bankList) {
            NSRange nameRange = [bank.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (nameRange.location != NSNotFound) {
                [filteredCards addObject:bank];
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    UINavigationController *navigationController = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"cardToAmount"])
    {
        AmmountViewViewController *destViewController = (AmmountViewViewController *) navigationController ;
        destViewController.isSecondCall = true;
        
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark  - Alert picker
- (void)selectUMAlertButton {
    
    AppDelegate *app =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.selection setObject:[self.umAlertView selectData] forKey:@"cuotas"];

    [self.umAlertView um_dismissAlertViewCompletion:^{
        [self performSegueWithIdentifier:@"cardToAmount" sender:self];
    }];
    
}

- (void)selectUMAlertCancelButton {
    [self.umAlertView um_dismissAlertView];
}

-(void)openPopUpNoCouteError
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"No hay coutas a mostrar."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* closeAction = [UIAlertAction actionWithTitle:@"Ok"
                                                          style:UIAlertActionStyleDefault
                                                        handler:nil];
    
    [alert addAction:closeAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}


@end
