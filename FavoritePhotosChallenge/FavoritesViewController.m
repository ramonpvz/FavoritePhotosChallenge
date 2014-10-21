//
//  FavoritesViewController.m
//  FavoritePhotosChallenge
//
//  Created by GLBMXM0002 on 10/18/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import "FavoritesViewController.h"
#import "ImageWrapper.h"

@interface  FavoritesViewController() <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation FavoritesViewController

- (void) viewDidLoad {
    [self.tableView reloadData];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.favoriteImages.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCellID"];
    ImageWrapper *imageWrapper = [self.favoriteImages objectAtIndex:indexPath.row];
    cell.textLabel.text = imageWrapper.name;
    return cell;
}

@end