//
//  ShowPictureViewController.m
//  iFlickr
//
//  Created by VitaliyP on 10.10.14.
//  Copyright (c) 2014 VitaliyP. All rights reserved.
//

#import "ShowPictureViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface ShowPictureViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ShowPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.title;
    [MBProgressHUD showHUDAddedTo:self.imageView animated:YES];
    [self p_downloadImage];
}

- (void)p_downloadImage {
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(backgroundQueue, ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageUrl]];
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            [self.imageView setImage:image];
            [MBProgressHUD hideAllHUDsForView:self.imageView animated:YES];
        });
    });
}

@end
