//
//  ImageViewController.h
//  FavoritePhotosChallenge
//
//  Created by GLBMXM0002 on 10/17/14.
//  Copyright (c) 2014 globant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageWrapper.h"

@interface ImageViewController : UIViewController
@property ImageWrapper *imageWrapper;

- (ImageWrapper *) favoriteImage;

@end
