//
//  ViewController.m
//  FavoritePhotosChallenge
//
//  Created by GLBMXM0002 on 10/17/14.
//  Copyright (c) 2014 globant. All rights reserved.
//
//TOKEN: 1531915097.daa85f7.1ba43291adb1464fb26c86b8bb775b2a

#import "ViewController.h"
#import "CollectionViewImageCell.h"
#import "ImageViewController.h"
#import "ImageWrapper.h"
#import "FavoritesViewController.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property NSMutableArray *images;
@property NSMutableArray *favoriteImages;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self load];
    self.images = [NSMutableArray array];
    self.favoriteImages = [NSMutableArray array];
}

- (IBAction)searchByArea:(id)sender {
    
    NSString *instagramURL = @"https://api.instagram.com/v1/media/search?lat=48.858844&lng=2.294351&access_token=1531915097.daa85f7.1ba43291adb1464fb26c86b8bb775b2a";
    
    NSURL *url = [NSURL URLWithString:instagramURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError * connectionError) {
        NSLog(@"Error: %@", connectionError);
        NSError *jsonError = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        NSArray *array = [json objectForKey:@"data"];
        for (NSDictionary *dtry in array) {
            NSDictionary *_dtry = dtry;
            NSString *type = [_dtry objectForKey: @"type"];
            if ([type isEqualToString:@"image"]) {
                NSDictionary *imageFormats = [[_dtry objectForKey:@"images"] objectForKey:@"thumbnail"];
                NSString *url = [imageFormats objectForKey:@"url"];
                NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
                UIImage *image = [UIImage imageWithData:imgData];
                ImageWrapper *imgWrapper = [[ImageWrapper alloc] init];
                imgWrapper.image = image;
                imgWrapper.name = [_dtry objectForKey:@"link"];
                [self.images addObject:imgWrapper];
            }
        }
         NSLog(@"Images: %lu" , (unsigned long)self.images.count);
        [self.collectionView reloadData];
    }];
    
}

-(NSURL *) documentsDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager]; //Returns a "Singletone"
    NSArray *files = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]; //As for a URL using Domain Mask
    return files.firstObject; //Asking for all the local directories (Universal Resource Locator)
}

- (void) load {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSURL *url = [[self documentsDirectory] URLByAppendingPathComponent:@"favoriteImages" isDirectory:NO];
    NSLog(@"URL: %@", url);
    
    NSLog(@"date: %@", [userDefaults objectForKey:@"LastSaved"]);

}

-(void) save:(NSData *) imageData {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSURL *url = [[self documentsDirectory] URLByAppendingPathComponent:@"favoriteImages" isDirectory:NO];
    
    if (![imageData writeToFile:url.path atomically:NO]) {
        NSLog(@"Failed to cache image data to disk");
    }
    else
    {
        NSLog(@"Saved");
    }
    
    [userDefaults setObject:[NSDate date] forKey:@"LastSaved"];
    [userDefaults synchronize];

}

- (IBAction)unwindImageViewController:(UIStoryboardSegue *)segue {
    ImageViewController *viewController = segue.sourceViewController;
    ImageWrapper *imgWrapper = [viewController favoriteImage];
    NSData *data = UIImagePNGRepresentation(imgWrapper.image);
    [self.favoriteImages addObject:imgWrapper];
    [self save:data];
    [self.collectionView reloadData];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)collectionImageView {
    NSLog(@"prepareForSegue...");
    if ([segue.identifier isEqualToString:@"details"]) {
        ImageViewController *imgVC = segue.destinationViewController;
        NSIndexPath *iPath = [self.collectionView indexPathForCell:collectionImageView];
        imgVC.imageWrapper = [self.images objectAtIndex:iPath.row];
        //Cool for getting the selected image in the cell:
            //imgVC.imageWrapper.image = [collectionImageView imageView].image;
    } else if ([segue.identifier isEqualToString:@"favorites"]) {
        NSLog(@"My favorites");
        FavoritesViewController *favVC = segue.destinationViewController;
        favVC.favoriteImages = self.favoriteImages;
    } else {
        NSLog(@"Unknown identifier");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    ImageWrapper *imgWrapper = [self.images objectAtIndex:indexPath.row];
    cell.imageView.image = imgWrapper.image;
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

@end
