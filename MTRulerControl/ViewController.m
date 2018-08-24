//
//  ViewController.m
//  MTRulerControl
//
//  Created by Mac on 2018/8/24.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ViewController.h"
#import "MTRulerControl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    MTRulerControl *control = [[MTRulerControl alloc] initWithFrame:(CGRect){0, 100, 200, 300} numerArray:@[@"1/24000", @"1/500", @"1/15", @"10"]];
    
    MTRulerControl *control = [[MTRulerControl alloc] initWithFrame:(CGRect){0, 100, 200, 300}
                                                                min:@"1/24000"
                                                                max:@"1/3"];

    control.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:control];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
