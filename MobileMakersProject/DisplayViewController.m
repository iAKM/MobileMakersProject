//
//  DisplayViewController.m
//  MobileMakersProject
//
//  Created by Achyut Kumar Maddela on 20/08/15.
//  Copyright (c) 2015 iAKM. All rights reserved.
//

#import "DisplayViewController.h"
#import "AppDelegate.h"
#import "Tag.h"

@interface DisplayViewController ()<UITableViewDataSource, UITableViewDelegate>

@property NSArray *array;
@property NSManagedObjectContext *moc;
@property NSArray *tags;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation DisplayViewController


- (void)viewDidLoad {
    [super viewDidLoad];

  //  [self loadTags];


    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;



}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;

    [self loadTags];

}

-(void)loadTags
{

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];

    self.tags = [self.moc executeFetchRequest:request error:nil];

    NSLog(@"self.tags --- %@", self.tags);

    [self.tableView reloadData];
}

#pragma mark UITableView Datasource & Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tags.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];

    Tag *tag = [self.tags objectAtIndex:indexPath.row];

    cell.textLabel.text = tag.name;



    return cell;

}

-(void)populateWithTagsIfEmpty
{
//    if (self.tags.count <=0)
//    {
//        Tag *tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:self.moc];
//
//        
//    }

    
}





@end
