//
//  ViewController.m
//  BetterMeds
//
//  Created by Vinay Jain on 5/11/15.
//  Copyright (c) 2015 Vinay Jain. All rights reserved.
//http://www.truemd.in/api/medicine_alternatives/?key=fab7267c813d0fe819437deef957ac&id=crocin&limit=10

#import "ViewController.h"
#import "NetworkManager.h"

@interface ViewController ()<UITextFieldDelegate,NetworkDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchField;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *headers;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;

@end

@implementation ViewController

-(void)viewDidLoad{
    
    [NetworkManager sharedInstance].delegate = self;
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

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.8 animations:^{
        [self.view layoutIfNeeded];
        self.topSpace.constant = 200;
        for (UILabel *label in self.headers) {
            label.alpha = 1;
        }
        [self.view layoutIfNeeded];
        
    }];
    return true;
}

-(void)updateDataSourceWith:(id)dataSource{
    
    NSLog(@"%@",dataSource);
    
    
}
@end
