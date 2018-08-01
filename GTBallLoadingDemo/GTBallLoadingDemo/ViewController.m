//
//  ViewController.m
//  GTBallLoadingDemo
//
//  Created by law on 2018/8/1.
//  Copyright © 2018年 Goldx4. All rights reserved.
//

#import "ViewController.h"
#import "GTBallSpinLoading.h"
#import "GTBallSwitchLoading.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"hide" style:UIBarButtonItemStylePlain target:self action:@selector(hide)];
}

- (IBAction)showSpinLoading:(UIButton *)sender {
    [GTBallSpinLoading showInView:self.view];
}

- (IBAction)showSwitchLoading:(id)sender {
    [GTBallSwitchLoading showInView:self.view];
}

- (void)hide {
    [GTBallSpinLoading hideInView:self.view];
    [GTBallSwitchLoading hideInView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
