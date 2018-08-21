//
//  TestViewController.m
//  GTBallLoadingDemo
//
//  Created by law on 2018/8/9.
//  Copyright © 2018年 Goldx4. All rights reserved.
//

#import "TestViewController.h"
#import "GTBallLoadingArcSwitch.h"
#import "GTBallLoadingHorizontalSwitch.h"
#import "GTBallLoadingArcRotate.h"

@interface TestViewController ()
@property (nonatomic, strong) UIImageView *bgImageView;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // bg image view
    self.bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.bgImageView.image = [UIImage imageNamed:@"zelda"];
    [self.view addSubview:self.bgImageView];
    
    // hide button
    UIBarButtonItem *showItem = [[UIBarButtonItem alloc] initWithTitle:@"show" style:(UIBarButtonItemStylePlain) target:self action:@selector(showTheLoading)];
    UIBarButtonItem *dismissItem = [[UIBarButtonItem alloc] initWithTitle:@"dismiss" style:(UIBarButtonItemStylePlain) target:self action:@selector(hideTheLoading)];
    self.navigationItem.rightBarButtonItems = @[dismissItem, showItem];
    
    // show loading
    [self showTheLoading];
}

- (void)showTheLoading {
    switch (_style) {
        case 0:
            [GTBallLoadingArcSwitch showInView:self.view];
            break;
        case 1:
            [GTBallLoadingHorizontalSwitch showInView:self.view];
            break;
        case 2:
            [GTBallLoadingArcRotate showInView:self.view];
            break;
    }
}

- (void)hideTheLoading {
    switch (_style) {
        case 0:
            [GTBallLoadingArcSwitch hideInView:self.view];
            break;
        case 1:
            [GTBallLoadingHorizontalSwitch hideInView:self.view];
            break;
        case 2:
            [GTBallLoadingArcRotate hideInView:self.view];
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
