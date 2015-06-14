//
//  MedicineDetailsController.m
//  BetterMeds
//
//  Created by Vinay Jain on 5/17/15.
//  Copyright (c) 2015 Vinay Jain. All rights reserved.
//

#import "MedicineInfoController.h"
#import "MedicineDetailsController.h"
#import "NetworkManager.h"

@interface MedicineInfoController ()<NetworkDelegate>{

    __weak IBOutlet UIActivityIndicatorView *indicator;
    int tag;
    NSDictionary *medDetails;
    NSArray * medAlternatives;
}

@property (weak, nonatomic) IBOutlet UIButton *detailsButton;
@property (weak, nonatomic) IBOutlet UIButton *alternativeButton;
@end

@implementation MedicineInfoController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MedicineInfoController"];
        
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.medicineLabel.text = self.medicineID;
    [NetworkManager sharedInstance].delegate = self;
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor] };
    self.title = @"Medicine Info";
    
    self.detailsButton.layer.borderColor = [UIColor colorWithRed:0.241 green:0.513 blue:0.751 alpha:1].CGColor;
    self.alternativeButton.layer.borderColor = [UIColor colorWithRed:0.241 green:0.513 blue:0.751 alpha:1].CGColor;
}
- (IBAction)getMedAlternates:(UIButton *)sender {
    
    [indicator startAnimating];
    
    [[NetworkManager sharedInstance]getMedicineAlternativesForID:self.medicineID];
    tag = 0;
    
    
}
- (IBAction)getMedDetails:(id)sender {
    
    [indicator startAnimating];
    
    [[NetworkManager sharedInstance] getMedicineDetailsForID:self.medicineID];
    
    tag = 1;
    
}

-(void)updateDataSourceWith:(id)dataSource{
    
    if (tag) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            medDetails = dataSource;
            MedicineDetailsController *obj = [MedicineDetailsController new];
            obj.medicineDetails = medDetails;
            [self.navigationController pushViewController:obj animated:YES];
            
        });
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            medAlternatives = dataSource;
        });
    }
}

@end
