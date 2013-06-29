//
//  CourseCategoryViewController.h
//  SuperClass
//
//  Created by xiongwei on 13-6-29.
//
//

#import <UIKit/UIKit.h>
#import "CourseCategoryTableViewCell.h"

@interface CourseCategoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *background_imageView;
@property (nonatomic, strong) IBOutlet UIImageView *header_imageView;
@property (nonatomic, strong) IBOutlet UITableView *category_tableView;

@property (nonatomic, retain) IBOutlet CourseCategoryTableViewCell *tmpCell;


@end
