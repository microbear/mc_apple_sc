//
//  ViewController.h
//  SuperClass
//
//  Created by xiongwei on 13-5-29.
//
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSFetchedResultsControllerDelegate,UITextFieldDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;


@property (nonatomic, strong) IBOutlet UITextField *username_textfield;
@property (nonatomic, strong) IBOutlet UITextField *password_textfield;
@property (nonatomic, strong) IBOutlet UIButton    *login_button;
@property (nonatomic, strong) IBOutlet UIButton    *register_button;

@end
