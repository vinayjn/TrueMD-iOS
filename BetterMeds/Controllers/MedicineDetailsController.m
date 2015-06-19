//
//  MdicineDetailsController.m
//  BetterMeds
//
//  Created by Vinay Jain on 6/14/15.
//  Copyright (c) 2015 Vinay Jain. All rights reserved.
//

#import "MedicineDetailsController.h"

@interface AlternateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *alterName;
@property (weak, nonatomic) IBOutlet UILabel *alterTablets;
@property (weak, nonatomic) IBOutlet UILabel *alterPrice;

@end

@implementation AlternateCell

@end

@interface MedicineDetailsController ()
@property (weak, nonatomic) IBOutlet UILabel *medicineName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *composition;
@property (weak, nonatomic) IBOutlet UILabel *manufacturer;
@property (weak, nonatomic) IBOutlet UILabel *tablets;
@property (weak, nonatomic) IBOutlet UILabel *tabletType;

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
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor] };
    self.title = @"Medicine Details";
    //self.medicineName.text = [self.medicineDetails valueForKeyPath:@"medicine.brand"];
    
    
    
}

@end
