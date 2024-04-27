//
//  ToDoDetails.h
//  TODO App
//
//  Created by JETSMobileLabMini12 on 17/04/2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToDoDetails : NSObject <NSCoding , NSSecureCoding>
@property NSString * title ;
@property NSString * desc;
@property NSString * status;
@property NSString * priority;
@property NSDate * date;
-(instancetype) initWithTitle : (NSString *) title andDescription : (NSString *) description andPriority : (NSString *) priority andStatus : (NSString *) status andDate :(NSDate *) date;
-(void) encodeWithCoder:(NSCoder *)coder;
@end

NS_ASSUME_NONNULL_END
