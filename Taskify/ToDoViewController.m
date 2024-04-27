//
//  ViewController.m
//  TODO App
//
//  Created by Aser Eid on 17/04/2024.
//

#import "ToDoViewController.h"
#import "ToDoDetails.h"
#import "DetailsViewController.h"
@interface ToDoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *filterBtn;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property NSMutableArray<ToDoDetails *> * listOfToDos;
@property NSUserDefaults * userDefault;
@property NSMutableArray<ToDoDetails*>* filteredArray ;
@property NSMutableArray <ToDoDetails*>* searchFilter;
@property BOOL isFiltered ;
@property short numberOfRows;
@property NSMutableArray * lowTasks;
@property NSMutableArray * medTasks;
@property NSMutableArray * highTasks;
@end

@implementation ToDoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isFiltered = NO;
    // Do any additional setup after loading the view.
    UIImage *image = [UIImage imageNamed:@"todo"];
    _myImage.image = image;
    _userDefault = [NSUserDefaults standardUserDefaults];
    
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _searchBar.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target:self action:@selector(addTask:)];
    
    NSData * data = [_userDefault objectForKey:@"listOfToDos"];
    
    _listOfToDos =[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (_listOfToDos.count == 0) {
        _myImage.hidden = NO ;
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status == %@" , @"TODO"];
        _filteredArray = [[_listOfToDos filteredArrayUsingPredicate:predicate] mutableCopy];
        if (_filteredArray.count == 0) {
            _myImage.hidden = NO;
        } else {
            _myImage.hidden = YES;
            [_myTableView reloadData];
        }
    }
    _searchFilter = [_filteredArray mutableCopy];
    [_myTableView reloadData];
    
}

-(void) addTask:(id) sender{
    DetailsViewController *details =[self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    [self.navigationController pushViewController:details animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50; 
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView.numberOfSections == 1) {
        return @"All Tasks";
    }else{
        if (section == 0) {
            return @"Low Tasks";
        }else if (section == 1){
            return @"Medium Tasks";
        }else{
            return @"High Tasks";
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_isFiltered) {
        _numberOfRows = 3;
        return _numberOfRows;
    }else{
        return  1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowCount = 0;
    if (_isFiltered) {
        if(section == 0){
            rowCount = _lowTasks.count;
        }else if (section == 1){
            rowCount = _medTasks.count;
        }else if (section == 2){
            rowCount = _highTasks.count;
        }
    }else{
        rowCount = _searchFilter.count;
    }
    
    return rowCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel * titleLabel = (UILabel *)[cell viewWithTag:1];
    UIImageView * image = (UIImageView *)[cell viewWithTag:0];
    ToDoDetails *toDoDetails ;
    if (_isFiltered) {
        if (indexPath.section == 0) {
            toDoDetails = _lowTasks[indexPath.row];
        }else if (indexPath.section == 1){
            toDoDetails = _medTasks[indexPath.row];
        }else if (indexPath.section == 2){
            toDoDetails = _highTasks[indexPath.row];
        }
    }else{
        toDoDetails = _searchFilter[indexPath.row];
    }
  
    
    titleLabel.text = toDoDetails.title;
    
    if ([toDoDetails.priority isEqual:@"Low"]) {
        image.image = [UIImage imageNamed:@"low"];
    }else if ([toDoDetails.priority isEqual:@"Medium"]){
        image.image = [UIImage imageNamed:@"med"];
    }else{
        image.image = [UIImage imageNamed:@"high"];
    }
    
    
    
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath * indexPath) {
        [self handleEditActionForRowAtIndexPath:indexPath];
    }];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [self handleDeleteActionForRowAtIndexPath:indexPath tableView:tableView];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    return @[deleteAction , editAction ];
}


- (void)handleEditActionForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ToDoDetails *selectedItem = _searchFilter[indexPath.row];
    
    DetailsViewController *edit = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    edit.selectedItem = selectedItem;
    edit.isEdit = YES;
    int index = -1;
    for (int i = 0 ; i < _listOfToDos.count; ++i) {
        if([_listOfToDos[i].title isEqual:selectedItem.title]){
            index = i;
            break;
        }
    }
    edit.index = index;
    [edit setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self.navigationController pushViewController:edit animated:YES];
    
    [_myTableView reloadData];
    
}

-(void)handleDeleteActionForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirm Delete" message:@"Are you sure you want to delete this item?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        ToDoDetails * selectedItem = self->_searchFilter[indexPath.row];
        for (int i = 0; i < self->_listOfToDos.count; i++) {
            if ([self->_listOfToDos[i].title isEqual:selectedItem.title]) {
                [self->_listOfToDos removeObjectAtIndex:i];
            }
        }
        for (int i = 0; i < self->_filteredArray.count; i++) {
            if ([self->_filteredArray[i].title isEqual:selectedItem.title]) {
                [self->_filteredArray removeObjectAtIndex:i];
            }
        }
        
        [self->_searchFilter removeObjectAtIndex:indexPath.row];
        
        NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:_listOfToDos];
        
        [self->_userDefault setObject:encodedArray forKey:@"listOfToDos"];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self->_myTableView reloadData];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@" , searchText];
        _searchFilter = [[_filteredArray filteredArrayUsingPredicate:predicate] mutableCopy];
    }else{
        _searchFilter = [_filteredArray mutableCopy];
    }
    [_myTableView reloadData];
}
@end
