//
//  MdicineDetailsController.m
//  BetterMeds
//
//  Created by Vinay Jain on 6/14/15.
//  Copyright (c) 2015 Vinay Jain. All rights reserved.
//

#import "MedicineDetailsController.h"
#import "NetworkManager.h"

@interface AlternateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *alterName;
@property (weak, nonatomic) IBOutlet UILabel *alterTablets;
@property (weak, nonatomic) IBOutlet UILabel *alterPrice;
@end

@implementation AlternateCell

@end

@interface MedicineDetailsController ()<NetworkDelegate>
@property (weak, nonatomic) IBOutlet UILabel *medicineName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *composition;
@property (weak, nonatomic) IBOutlet UILabel *manufacturer;
@property (weak, nonatomic) IBOutlet UILabel *tablets;
@property (weak, nonatomic) IBOutlet UILabel *tabletType;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong,nonatomic) NSArray *tableData;

@end

@implementation MedicineDetailsController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MedicineDetailsController"];
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [NetworkManager sharedInstance].delegate = self;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor] };
    self.title = @"Medicine Details";
    
    self.medicineName.text = [self.medicineDetails valueForKeyPath:@"medicine.brand"];
}

-(void)updateDataSourceWith:(id)dataSource{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.indicator stopAnimating];
        
        self.tableData = (NSArray *)dataSource;
        
    });
}

@end
