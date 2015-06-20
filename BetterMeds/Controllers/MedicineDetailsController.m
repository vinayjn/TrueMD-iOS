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

@interface MedicineDetailsController ()<NetworkDelegate,UITableViewDataSource,UITableViewDelegate>{
    int tag;
}
@property (weak, nonatomic) IBOutlet UILabel *medicineName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *composition;
@property (weak, nonatomic) IBOutlet UILabel *manufacturer;
@property (weak, nonatomic) IBOutlet UILabel *tablets;
@property (weak, nonatomic) IBOutlet UILabel *tabletType;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *centralIndicator;
@property (weak, nonatomic) IBOutlet UITableView *medicineTableView;

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
    
    self.manufacturer.text = [self.medicineDetails valueForKeyPath:@"medicine.manufacturer"];
    
    self.tablets.text = [NSString stringWithFormat:@"%@ Tablets",[self.medicineDetails valueForKeyPath:@"medicine.package_qty"]];
    
    self.price.text = [NSString stringWithFormat:@"%@ Rs",[self.medicineDetails valueForKeyPath:@"medicine.package_price"]];
    
    self.composition.text = [NSString stringWithFormat:@"%@ (%@)",[[self.medicineDetails valueForKeyPath:@"constituents.name"] objectAtIndex:0],[[self.medicineDetails valueForKeyPath:@"constituents.strength"] objectAtIndex:0]];
    
    self.tabletType.text = [self.medicineDetails valueForKeyPath:@"medicine.unit_type"];
    
    [[NetworkManager sharedInstance] getMedicineAlternativesForID:[self.medicineDetails valueForKeyPath:@"medicine.brand"]];
    [self.indicator startAnimating];
    
}

#pragma mark - TableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([self.tableData count]) {
        return [self.tableData count];
    }
    else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AlternateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlternateCell"];
    
    NSDictionary *data = [self.tableData objectAtIndex:indexPath.row];
    
    cell.alterName.text = [data valueForKey:@"brand"];
    
    
    
    
    cell.alterPrice.text = [NSString stringWithFormat:@"%@ Rs",[data valueForKey:@"package_price"]];
    
    if ([self.price.text integerValue] > [cell.alterPrice.text integerValue]) {
        [cell.alterPrice setTextColor:[UIColor greenColor]];
    }
    else if ([self.price.text integerValue] < [cell.alterPrice.text integerValue]) {
        [cell.alterPrice setTextColor:[UIColor redColor]];
    }
    else {
        [cell.alterPrice setTextColor:[UIColor blueColor]];
    }
    cell.alterTablets.text = [NSString stringWithFormat:@"%@ Tablets",[data valueForKey:@"package_qty"]];
    
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    return cell;
    
}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AlternateCell *cell = (AlternateCell*)[tableView cellForRowAtIndexPath:indexPath];
    tag = 2;
    [self.centralIndicator startAnimating];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [[NetworkManager sharedInstance] getMedicineDetailsForID:cell.alterName.text];
    
}

-(void)updateDataSourceWith:(id)dataSource{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (tag == 2) {
            [self.centralIndicator stopAnimating];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            MedicineDetailsController *medicineDetailsController = [MedicineDetailsController new];
            medicineDetailsController.medicineDetails = (NSDictionary *)dataSource;
            [self.navigationController pushViewController:medicineDetailsController animated:YES];
            
        }
        else{
        [self.indicator stopAnimating];
        self.tableData = (NSArray *) dataSource;
        [self.medicineTableView reloadData];
        }
    });
}

@end
