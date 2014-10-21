//
//  ImageViewController.m
//  FavoritePhotosChallenge
//
//  Created by GLBMXM0002 on 10/17/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ImageViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = self.imageWrapper.image;
}

- (ImageWrapper *) favoriteImage {
    return self.imageWrapper;
}

@end