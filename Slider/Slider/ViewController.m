//
//  ViewController.m
//  Slider
//
//  Created by wuyang on 2017/8/25.
//  Copyright © 2017年 wuyang. All rights reserved.
//

#import "ViewController.h"
#import "EASlider.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    EASlider *slier = [EASlider slider];
    slier.thumbImage = [UIImage imageNamed:@"shop_btn_origin"];
    slier.currentSegmentIndex = 2;
    slier.segementTitles = @[@"1km",@"2km",@"3km",@"4km",@"5km",];
    slier.hightlightTitleColor = [UIColor blueColor];
    slier.normalTitleColor = [UIColor blackColor];
    
    [slier addTarget:self action:@selector(changed:) forControlEvents:UIControlEventValueChanged];
 
    [self.view addSubview:slier];
}

- (void)changed:(EASlider *)slider{
    NSLog(@"%@",@(slider.currentSegmentIndex));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
