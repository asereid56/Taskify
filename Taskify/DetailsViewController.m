//
//  DetailsViewController.m
//  TODO App
//
//  Created by Aser Eid on 17/04/2024.
//

#import "DetailsViewController.h"
#import "ToDoDetails.h"
#import "ToDoViewController.h"
@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleDetails;
@property (weak, nonatomic) IBOutlet UITextView *descDetails;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priorityDetails;
@property (weak, nonatomic) IBOutlet UISegmentedControl *statusDetails;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateDetails;
@property NSMutableArray<ToDoDetails *>* listOfToDos;
@property NSUserDefaults * userDefault;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIImageView *myImage;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _userDefault = [NSUserDefaults standardUserDefaults];
    
    
    _dateDetails.minimumDate = [NSDate date];
    
    if (_isEdit) {
        if (_indexScreen == 2) {
            [_statusDetails setEnabled:NO forSegmentAtIndex:0];
        }else if (_indexScreen == 3){
            [_statusDetails setEnabled:NO forSegmentAtIndex:0];
            [_statusDetails setEnabled:NO forSegmentAtIndex:1];
            _titleDetails.enabled = NO;
            _descDetails.editable = NO;
            _priorityDetails.enabled = NO;
            _statusDetails.enabled = NO;
            _dateDetails.userInteractionEnabled = NO;
            _addBtn.hidden = YES;

        }
        _addBtn.titleLabel.text = @"Edit";
        _titleDetails.text =  _selectedItem.title;
        _descDetails.text = _selectedItem.desc;
        if ([_selectedItem.priority isEqualToString:@"Low"]) {
            _priorityDetails.selectedSegmentIndex = 0;
        }else if ([_selectedItem.priority isEqualToString:@"Medium"]){
            _priorityDetails.selectedSegmentIndex = 1;
        }else{
            _priorityDetails.selectedSegmentIndex = 2;
        }
        if ([_selectedItem.status isEqualToString:@"TODO"]) {
            _statusDetails.selectedSegmentIndex = 0;
        }else if ([_selectedItem.status isEqualToString:@"InProgress"]){
            _statusDetails.selectedSegmentIndex = 1;
        }else{
            _statusDetails.selectedSegmentIndex = 2;
        }
        _dateDetails.date = _selectedItem.date;
    }else{
        [_statusDetails setEnabled:NO forSegmentAtIndex:1];
        [_statusDetails setEnabled:NO forSegmentAtIndex:2];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    NSData *data = [_userDefault objectForKey:@"listOfToDos"];
    NSMutableArray<ToDoDetails *> * existinglist = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (!existinglist) {
        existinglist = [NSMutableArray new];
    }
    
    if ([_selectedItem.priority isEqual:@"Low"]) {
        _myImage.image = [UIImage imageNamed:@"low"];
    }else if ([_selectedItem.priority isEqual:@"Medium"]){
        _myImage.image = [UIImage imageNamed:@"med"];
    }else if([_selectedItem.priority isEqual:@"high"]){
        _myImage.image = [UIImage imageNamed:@"high"];
    }
    
    
    
    _listOfToDos = existinglist;
}

- (IBAction)priorityChange:(id)sender {
    if (_priorityDetails.selectedSegmentIndex == 0) {
        _myImage.image = [UIImage imageNamed:@"low"];
    }else if (_priorityDetails.selectedSegmentIndex == 1){
        _myImage.image = [UIImage imageNamed:@"med"];
    }else{
        _myImage.image = [UIImage imageNamed:@"high"];
    }
}

- (IBAction)addToDo:(id)sender {
    
    if (_titleDetails.text.length >0 && _descDetails.text.length > 0) {
        if (_isEdit) {
            [_listOfToDos replaceObjectAtIndex:_index withObject:[[ToDoDetails alloc] initWithTitle:self.titleDetails.text andDescription:self.descDetails.text andPriority:[self.priorityDetails titleForSegmentAtIndex:self.priorityDetails.selectedSegmentIndex] andStatus:[self.statusDetails titleForSegmentAtIndex:self.statusDetails.selectedSegmentIndex] andDate:self.dateDetails.date]];
            
            UIAlertController *editedAlert = [UIAlertController alertControllerWithTitle:@"Item Edited" message:@"The item has been successfully edited." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [editedAlert addAction:okAction];
            [self presentViewController:editedAlert animated:YES completion:nil];
            
        } else {
            ToDoDetails *toDoDetails = [[ToDoDetails alloc] initWithTitle:self.titleDetails.text andDescription:self.descDetails.text andPriority:[self.priorityDetails titleForSegmentAtIndex:self.priorityDetails.selectedSegmentIndex] andStatus:[self.statusDetails titleForSegmentAtIndex:self.statusDetails.selectedSegmentIndex] andDate:self.dateDetails.date];
            
            [_listOfToDos addObject:toDoDetails];
        }
        
        NSData *archivedData = [NSKeyedArchiver  archivedDataWithRootObject:self.listOfToDos];
        [_userDefault setObject:archivedData forKey:@"listOfToDos"];
        
        
        
        ToDoViewController * toDoScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"todo" ];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please fill in all required fields."preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
