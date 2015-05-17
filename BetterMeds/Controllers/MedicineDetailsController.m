//
//  MedicineDetailsController.m
//  BetterMeds
//
//  Created by Vinay Jain on 5/17/15.
//  Copyright (c) 2015 Vinay Jain. All rights reserved.
//

#import "MedicineDetailsController.h"
#import "NetworkManager.h"

@interface MedicineDetailsController ()<NetworkDelegate>{
    NSDictionary *medDetails;
    __weak IBOutlet UIActivityIndicatorView *indicator;
    __weak IBOutlet UIImageView *pillImage;

}


@end

@implementation MedicineDetailsController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"medicineDetailsController"];
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [NetworkManager sharedInstance].delegate = self;
    [[NetworkManager sharedInstance] getMedicineDetailsForID:self.medicineID];
    
}

-(void)updateDataSourceWith:(id)dataSource{
    medDetails = dataSource;
    self.medicineLabel.text = self.medicineID;
    dispatch_async(dispatch_get_main_queue(), ^{
        [indicator stopAnimating];
        pillImage.hidden = false;
        self.medicineLabel.hidden = false;
    });
}

@end
