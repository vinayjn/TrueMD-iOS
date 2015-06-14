//
//  MedicineDetailsController.m
//  BetterMeds
//
//  Created by Vinay Jain on 5/17/15.
//  Copyright (c) 2015 Vinay Jain. All rights reserved.
//

#import "MedicineInfoController.h"
#import "NetworkManager.h"

@interface MedicineInfoController ()<NetworkDelegate>{

    __weak IBOutlet UIActivityIndicatorView *indicator;
    int tag;
    NSDictionary *medDetails;
    NSArray * medAlternatives;
}
@end

@implementation MedicineInfoController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"medicineDetailsController"];
        
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.medicineLabel.text = self.medicineID;
    [NetworkManager sharedInstance].delegate = self;
    
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
