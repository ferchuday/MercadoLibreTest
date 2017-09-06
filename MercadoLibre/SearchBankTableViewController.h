//
//  SearchBankTableViewController.h
//  MercadoLibre
//
//  Created by federico carzoglio on 3/9/17.
//  Copyright © 2017 federico carzoglio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Callback.h"
#import "UMAlertView.h"

@interface SearchBankTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *sbCreditCard;

@property (nonatomic) Callback *callback;
@property (nonatomic) NSMutableArray *bankList;
@property (nonatomic) UMAlertView *umAlertView;

@end
