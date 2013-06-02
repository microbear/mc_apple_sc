//
//  ViewController.h
//  SuperClass
//
//  Created by xiongwei on 13-5-29.
//
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end
