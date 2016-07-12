//
//  ViewController.m
//  TYADPhotoLoop
//
//  Created by tiny on 16/7/12.
//  Copyright © 2016年 tiny. All rights reserved.
//

#import "ViewController.h"
#import "TYADPhotoLoop.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    TYADPhotoLoop *loop = [[TYADPhotoLoop alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    
    loop.photos =@[@"photo1.jpg",@"photo1.jpg",@"photo1.jpg",@"photo1.jpg",@"photo1.jpg",@"photo1.jpg",@"photo1.jpg",@"photo1.jpg",@"photo1.jpg",@"photo1.jpg"];
    
    [self.view addSubview:loop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
