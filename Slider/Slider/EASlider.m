




//
//  EASlider.m
//  Slider
//
//  Created by wuyang on 2017/8/25.
//  Copyright © 2017年 wuyang. All rights reserved.
//

#import "EASlider.h"

#define horizLineHeight 1
#define verticalLineWidth horizLineHeight
#define verticalLineHeight 5
#define marginX 10
#define titleLabelBaseTagNumber 4543
#define baseLineY (self.frame.size.height - 5)
@interface EASlider ()

@property (nonatomic) UIImageView *thumbImageView;

@end
@implementation EASlider


+ (EASlider *)slider
{
    EASlider *slider = [[EASlider alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 24 + 5 + 15)];
    
    return slider;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
    }
    return self;
}




#pragma mark -getter & setter

- (CALayer *)horizontalLineAtPoint:(CGPoint )point{
    
    //获得根图层
    CALayer *layer=[[CALayer alloc]init];
    //设置背景颜色,由于QuartzCore是跨平台框架，无法直接使用UIColor
    layer.backgroundColor=[UIColor grayColor].CGColor;
    
    layer.bounds=CGRectMake(0, 0, self.frame.size.width-2*marginX,horizLineHeight);
    
    //设置中心点
    layer.position = point;
    
    
    return layer;
}

- (CALayer *)verticalLineAtPoint:(CGPoint )point{
    CALayer *vertical = [self verticalLine];
    
    vertical.position = CGPointMake(point.x - verticalLineWidth/2, point.y - verticalLineHeight/2);
    return vertical;
}

- (CALayer *)verticalLine{
    
    //获得根图层
    CALayer *layer=[[CALayer alloc]init];
    //设置背景颜色,由于QuartzCore是跨平台框架，无法直接使用UIColor
    layer.backgroundColor=[UIColor grayColor].CGColor;
    //设置中心点
    //    layer.position=CGPointMake(size.width/2, size.height/2);
    //设置大小
    layer.bounds=CGRectMake(0, 0, verticalLineWidth,verticalLineHeight);
    
    return layer;
}

-(UIImageView *)thumbImageView{
    if (_thumbImageView == nil) {
        _thumbImageView =  [[UIImageView alloc] init];
        CGFloat height = 10;
        _thumbImageView.frame = CGRectMake(marginX-height/2, baseLineY-height/2, height, height);
    }
    return _thumbImageView;
}

-(void)setThumbImage:(UIImage *)thumbImage
{
    self.thumbImageView.image = thumbImage;
}

-(void)setSegementTitles:(NSArray *)segementTitles
{
    _segementTitles = segementTitles;
    
    NSAssert(_segementTitles.count >= 2, @"segmentNumber最少要为2");
    
    [self reloadUILayout];
}

-(void)setCurrentSegmentIndex:(NSUInteger)currentSegmentIndex
{
    _currentSegmentIndex = currentSegmentIndex;
    [self hightlightSelectSegementIndexTitle];
}

- (void)setNormalTitleColor:(UIColor *)normalTitleColor
{
    _normalTitleColor = normalTitleColor;
    [self hightlightSelectSegementIndexTitle];
}

-(void)setHightlightTitleColor:(UIColor *)hightlightTitleColor
{
    _hightlightTitleColor = hightlightTitleColor;
    [self hightlightSelectSegementIndexTitle];
}
#pragma mark - private


- (void)reloadUILayout{
    
    for (CALayer *layer in self.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    
    CGSize size = self.frame.size;
    
    // 大横线
    CALayer *horizontal=[self horizontalLineAtPoint:CGPointMake(size.width/2, baseLineY)];
    [self.layer addSublayer:horizontal];
    
    CGFloat separateWidth = (self.frame.size.width- 2*marginX)/(_segementTitles.count - 1);
    // 刻度线
    for (NSInteger i = 0; i < self.segementTitles.count; i++) {
        CGFloat x = marginX + separateWidth * i;
        CALayer *vertical = [self verticalLineAtPoint:CGPointMake(x, baseLineY)];
        [self.layer addSublayer:vertical];
    }
    
    [self addSubview:self.thumbImageView];
    
    
    [self addTitles];
    
    [self hightlightSelectSegementIndexTitle];
}

- (void)addTitles{
    
    for (NSInteger i = 0; i < self.segementTitles.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 24)];
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = self.normalTitleColor;
        label.text = self.segementTitles[i];
        label.tag = titleLabelBaseTagNumber + i;
        label.textAlignment = NSTextAlignmentCenter;
        CGFloat labelWidth = 60;
        
        CGFloat x = 0;
        if (i == 0) {
            x = 0;
            label.textAlignment = NSTextAlignmentLeft;
        }else if (i == self.segementTitles.count - 1)
        {
            x = self.frame.size.width - marginX - labelWidth;
            label.textAlignment = NSTextAlignmentRight;
        }
        else{
            x = marginX + [self segmentPointXWithIndex:i] - labelWidth/2;
        }
        label.frame = CGRectMake(x, 0, labelWidth, 24);
        [self addSubview:label];
    }
}


- (CGPoint)nearestSegmentXWithPoint:(CGPoint)currPoint{
    
    CGFloat separateWidth = (self.frame.size.width- 2*marginX)/(_segementTitles.count - 1);
    
    CGFloat fullWidth = self.frame.size.width - 2*marginX;
    
    NSUInteger beishu = round((currPoint.x - marginX)/separateWidth);
    
    CGFloat destinationX = beishu*(fullWidth/(self.segementTitles.count - 1)) + self.thumbImageView.frame.size.width/2;
    
    return CGPointMake(destinationX,currPoint.y);
}

- (NSUInteger)nearestSegmentIndexWithPoint:(CGPoint)currPoint{
    CGFloat separateWidth = (self.frame.size.width- 2*marginX)/(_segementTitles.count - 1);
    
    CGFloat beishu = round((currPoint.x - marginX)/separateWidth);
    
    return beishu;
}

- (CGFloat)segmentPointXWithIndex:(NSUInteger)index{
    CGFloat separateWidth = (self.frame.size.width- 2*marginX)/(_segementTitles.count - 1);
    
    CGFloat x = index * separateWidth;
    
    return x;
}


- (void)moveThumbToPoint:(CGPoint)currPoint{
    CGFloat thumbWidth = self.thumbImageView.frame.size.width;
    CGFloat thumbHeight = self.thumbImageView.frame.size.height;
    self.thumbImageView.frame = CGRectMake(currPoint.x - thumbWidth/2, self.thumbImageView.frame.origin.y, thumbWidth, thumbHeight);

}



-(void) animateHandlerToNearestSegment:(CGPoint ) point{
    CGPoint toPoint = [self nearestSegmentXWithPoint:point];
    [UIView beginAnimations:nil context:nil];
    [self.thumbImageView setFrame:CGRectMake(toPoint.x, self.thumbImageView.frame.origin.y, self.thumbImageView.frame.size.width, self.thumbImageView.frame.size.height)];
    [UIView commitAnimations];
}

- (void)hightlightSelectSegementIndexTitle{
    for (UILabel *label in self.subviews) {
        if (label.tag >= titleLabelBaseTagNumber && label.tag < titleLabelBaseTagNumber+self.segementTitles.count) {
            if (label.tag == titleLabelBaseTagNumber + self.currentSegmentIndex) {
                label.textColor = self.hightlightTitleColor;
            }else{
                label.textColor = self.normalTitleColor;
            }
            
        }
    }
}

#pragma mark - touch&delegate
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    self.thumbImageView
    CGPoint currPoint = [[touches anyObject] locationInView:self];
    NSLog(@"%@",NSStringFromCGPoint(currPoint));
    currPoint = [self adjustPoint:currPoint];
    [self moveThumbToPoint:currPoint];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint currPoint = [[touches anyObject] locationInView:self];
    NSLog(@"%@",NSStringFromCGPoint(currPoint));
    currPoint = [self adjustPoint:currPoint];
    [self moveThumbToPoint:currPoint];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint currPoint = [[touches anyObject] locationInView:self];
    NSLog(@"%@",NSStringFromCGPoint(currPoint));
    currPoint = [self adjustPoint:currPoint];
//    [self moveThumbToPoint:currPoint];
    self.currentSegmentIndex = [self nearestSegmentIndexWithPoint:currPoint];
    [self animateHandlerToNearestSegment:currPoint];
    [self sendActionsForControlEvents:UIControlEventValueChanged];

}

- (CGPoint)adjustPoint:(CGPoint)currPoint
{
    if (currPoint.x < marginX) {
        currPoint.x = marginX;
    }
    if (currPoint.x > self.frame.size.width - marginX)
    {
        currPoint.x = self.frame.size.width - marginX;
        
    }
    
    return currPoint;
    
}



@end
