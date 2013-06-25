//
//  RegisterViewController.h
//  SuperClass
//
//  Created by xiongwei on 13-6-21.
//
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController


@property (nonatomic, strong) IBOutlet UITextField *username_textfield;
@property (nonatomic, strong) IBOutlet UITextField *password_textfield;
@property (nonatomic, strong) IBOutlet UITextField *validcode_textfield;
@property (nonatomic, strong) IBOutlet UIButton    *get_validcode_button;
@property (nonatomic, strong) IBOutlet UIButton    *complete_register_button;

@end
