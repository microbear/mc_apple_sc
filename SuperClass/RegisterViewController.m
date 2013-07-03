//
//  RegisterViewController.m
//  SuperClass
//
//  Created by xiongwei on 13-6-21.
//
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark outlet action

- (IBAction)get_validcode:(UIButton *)sender
{
}
- (IBAction)complete_register:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
