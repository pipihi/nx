//
//  ViewController.m
//  qq2
//
//  Created by Beauty-jishu on 2018/11/23.
//  Copyright © 2018年 Beauty-jishu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    NSString * a = [NSBundle mainBundle].bundleIdentifier;
    NSString * b = @"hehe";
    BOOL res = [b isEqualToString:a];
    NSLog(@"%d", res);
 
}


@end

