//
//  ViewController.m
//  WCBarButtonItem
//
//  Created by wesley chen on 15/8/3.
//  Copyright (c) 2015年 wesley chen. All rights reserved.
//

#import "ViewController.h"
#import "WCBarButtonItem.h"
#import "WCNavBackButtonItem.h"

@interface ViewController ()
@property (nonatomic, strong) WCBarButtonItem *rightItem;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    WCBarButtonItem *rightItem = [[WCBarButtonItem alloc] initWithTitle:@"100" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = rightItem;
    _rightItem = rightItem;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [timer fire];
    
    NSString *title = @"Back";
    //title = nil; // for test
    
    WCNavBackButtonItem *backItem = [[WCNavBackButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(backItemClicked:)];
    self.navigationItem.leftBarButtonItems = @[[WCNavBackButtonItem navBackButtonLeadingSpaceItem], backItem];
}

- (void)timerFired:(NSTimer *)timer {
    NSString *randomNumber = [NSString stringWithFormat:@"%u", arc4random() % 100];
    _rightItem.barItemTitle = randomNumber;
}

#pragma mark - Actions

- (void)backItemClicked:(id)sender {
    NSLog(@"sender: %@", sender);
}

@end
