//
//  ToDoDetails.m
//  TODO App
//
//  Created by JETSMobileLabMini12 on 17/04/2024.
//

#import "ToDoDetails.h"

@implementation ToDoDetails

- (instancetype)initWithTitle:(NSString *)title andDescription:(NSString *)description andPriority:(NSString *)priority andStatus:(NSString *)status andDate:(NSDate *)date
{
    self = [super init];
    
    _title = title;
    _desc = description;
    _priority = priority;
    _status = status;
    _date = date;
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.desc forKey:@"desc"];
    [coder encodeObject:self.priority forKey:@"priority"];
    [coder encodeObject:self.status forKey:@"status"];
    [coder encodeObject:self.date forKey:@"date"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    self = [super init];
    if (self) {
        self.title = [coder decodeObjectForKey:@"title"];
        self.desc = [coder decodeObjectForKey:@"desc"];
        self.priority = [coder decodeObjectForKey:@"priority"];
        self.status = [coder decodeObjectForKey:@"status"];
        self.date = [coder decodeObjectForKey:@"date"];
    }
    return self;
}
+(BOOL)supportsSecureCoding{
    return YES;
}
@end
