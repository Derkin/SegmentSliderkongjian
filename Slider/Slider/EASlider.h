//
//  EASlider.h
//  Slider
//
//  Created by wuyang on 2017/8/25.
//  Copyright © 2017年 wuyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EASlider : UIControl

@property (nonatomic) UIImage *thumbImage;

//@property (nonatomic,assign) NSUInteger segmentNumber;

@property (nonatomic,strong) NSArray<NSString *> *segementTitles;

@property (nonatomic,assign) NSUInteger currentSegmentIndex;

@property (nonatomic)       UIColor *normalTitleColor;
@property (nonatomic)       UIColor *hightlightTitleColor;

+ (EASlider *)slider;

@end
