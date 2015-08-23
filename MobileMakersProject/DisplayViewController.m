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
#import "DisplayTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface DisplayViewController ()<UITableViewDataSource, UITableViewDelegate>

@property NSArray *array;
@property NSManagedObjectContext *moc;
@property NSArray *tags;
@property NSArray *imagesFromCoreData;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation DisplayViewController


- (void)viewDidLoad {
    [super viewDidLoad];

  //  [self loadTags];

    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;

    [[self navigationController] setNavigationBarHidden:YES animated:YES]; // this hides the navigation bar.

}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.moc = delegate.managedObjectContext;

    [self loadTags];
    [self loadPhotos];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadPhotos];
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
    return self.imagesFromCoreData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DisplayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    Tag *tag = [self.tags objectAtIndex:indexPath.row];
    Photo *photo = self.imagesFromCoreData[indexPath.row];

    NSData *data = photo.imageData;
    cell.textLabel.text = tag.name;

    UIImage *image = [UIImage imageWithData:data];
    cell.imageView.image = image;

    return cell;

}

-(void)loadPhotos {
    NSFetchRequest *requestPhotos = [[NSFetchRequest alloc]initWithEntityName:@"Photo"];
    [requestPhotos setReturnsObjectsAsFaults:NO];
    [requestPhotos setRelationshipKeyPathsForPrefetching:@[@"comments"]];
    self.imagesFromCoreData = [self.moc executeFetchRequest:requestPhotos error:nil];
    NSLog(@"you have %li photos", self.imagesFromCoreData.count);

    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {

        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];

        Photo *deletedPhoto = [self.imagesFromCoreData objectAtIndex:indexPath.row];
        [self.moc deleteObject:deletedPhoto];
        Tag *deletedTag = [self.tags objectAtIndex:indexPath.row];
        [self.moc deleteObject:deletedTag];

        [self.moc save:nil];
        [self imagesFromCoreData];
        [self tags];
        [self.tableView endUpdates];
    }
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
