//
//  ViewController.m
//  BetterMeds
//
//  Created by Vinay Jain on 5/11/15.
//  Copyright (c) 2015 Vinay Jain. All rights reserved.
//http://www.truemd.in/api/medicine_alternatives/?key=fab7267c813d0fe819437deef957ac&id=crocin&limit=10

#import "ViewController.h"
#import "MedicineInfoController.h"
#import "NetworkManager.h"

@interface ViewController ()<UITextFieldDelegate,NetworkDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    NSArray *medicineData;
    __weak IBOutlet UITableView *medicines;
}

@property (weak, nonatomic) IBOutlet UITextField *searchField;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *headers;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;

@end

@implementation ViewController

-(void)viewDidLoad{
    
    [NetworkManager sharedInstance].delegate = self;
    self.navigationController.navigationBarHidden= true;
}

-(void)viewDidLayoutSubviews{
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, self.searchField.frame.size.height - 1, self.searchField.frame.size.width, 1);
    bottomBorder.backgroundColor = [UIColor darkGrayColor].CGColor;
    self.searchField.delegate = self;
    
    [self.searchField addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.searchField.layer addSublayer:bottomBorder];
}

-(void)textFieldTextDidChange:(UITextField *)textField{
    if (textField.text.length > 2 ) {
        [[NetworkManager sharedInstance] getMedicineSuggestionsForID:textField.text];
    }
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.8 animations:^{
        [self.view layoutIfNeeded];
        self.topSpace.constant = 35;
        for (UILabel *label in self.headers) {
            label.alpha = 0;
        }
        [self.view layoutIfNeeded];
        
    }];
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    if ([textField.text isEqualToString:@""]) {
        medicineData = nil;
        [medicines reloadData];
    }
    
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.8 animations:^{
        [self.view layoutIfNeeded];
        self.topSpace.constant = 170;
        for (UILabel *label in self.headers) {
            label.alpha = 1;
        }
        [self.view layoutIfNeeded];
        
    }];
    return true;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([medicineData count]) {
        return [medicineData count];
    }
    else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [[medicineData objectAtIndex:indexPath.row] valueForKey:@"suggestion"];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MedicineInfoController *medicieDetailsController = [MedicineInfoController new];
    
    medicieDetailsController.medicineID= [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
    [self.navigationController showViewController:medicieDetailsController sender:nil];
    
}

-(void)updateDataSourceWith:(id)dataSource{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        medicineData = (NSArray*)dataSource;
        [medicines reloadData];
    });
    
}
@end
