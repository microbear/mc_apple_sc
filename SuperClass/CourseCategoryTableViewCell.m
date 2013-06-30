//
//  CourseCategoryTableViewCell.m
//  SuperClass
//
//  Created by xiongwei on 13-6-29.
//
//

#import "CourseCategoryTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation CourseCategoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    self.background_imageView.backgroundColor = [UIColor yellowColor];
    CALayer *layer = [self.background_imageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:20];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
