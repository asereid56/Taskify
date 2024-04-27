//
//  DetailsViewController.h
//  TODO App
//
//  Created by Aser Eid on 17/04/2024.
//

#import <UIKit/UIKit.h>
#import "ToDoDetails.h"
NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController 
@property BOOL isEdit ;
@property ToDoDetails* selectedItem;
@property NSInteger index;
@property NSInteger indexScreen;
@end

NS_ASSUME_NONNULL_END
