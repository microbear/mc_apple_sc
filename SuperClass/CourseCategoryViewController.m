//
//  CourseCategoryViewController.m
//  SuperClass
//
//  Created by xiongwei on 13-6-29.
//
//

#import "CourseCategoryViewController.h"

@interface CourseCategoryViewController ()

@property (nonatomic, strong) UINib *cell_nib;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation CourseCategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.category_tableView.delegate = self;
    self.category_tableView.dataSource = self;
    self.cell_nib = [UINib nibWithNibName:@"CourseCategoryTableViewCell" bundle:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //[self presentModalViewController:oneSentenceViewController animated:YES];
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return  100;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [[self.fetchedResultsController fetchedObjects] count];
    return 3;
}

-(NSString *)getNameFromIndex:(int)index
{
    NSString *name = nil;
    switch (index) {
        case 0:
            name =  @"初级";
            break;
        case 1:
            name =  @"中级";
            break;
        case 2:
            name =  @"高级";
            break;
            
        default:
            name =  @"";
            break;
    }
    return name;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"mycell";
    CourseCategoryTableViewCell *cell = [self.category_tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        [self.cell_nib instantiateWithOwner:self options:nil];
		cell = self.tmpCell;
        self.tmpCell = nil;
        
    }
    
    cell.categoryName_label.text = [self getNameFromIndex:indexPath.row];
    
    
    return cell;
}

@end
