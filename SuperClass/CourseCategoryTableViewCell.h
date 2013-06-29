//
//  CourseCategoryTableViewCell.h
//  SuperClass
//
//  Created by xiongwei on 13-6-29.
//
//

#import <UIKit/UIKit.h>

@interface CourseCategoryTableViewCell : UITableViewCell
{
    
}
@property (nonatomic, strong) IBOutlet UIImageView *background_imageView;
@property (nonatomic, strong) IBOutlet UILabel *categoryName_label;
@property (nonatomic, strong) IBOutlet UILabel *studyPoints_label;
@property (nonatomic, strong) IBOutlet UIProgressView *studyProgress_progressView;
@end
