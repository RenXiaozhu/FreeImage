//
//  FreedomImage.m
//  UIControlDemo
//
//  Created by MacMini2 on 2017/9/1.
//  Copyright © 2017年 MacMini2. All rights reserved.
//

#import "FreedomImage.h"
#import <math.h>

#define Square(ptr) ptr*ptr
#define xWidth self.bounds.size.width
@interface FreedomImage ()
@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, assign) BOOL isFirstTime;
@property (nonatomic, assign) CGRect initFrame;
@property (nonatomic, strong) NSMutableArray *nearByImgs;
@end

@implementation FreedomImage


- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    [UIView animateWithDuration:5.0 animations:^{
        [self setAlpha:1.0];
        [self.layer setCornerRadius:self.initFrame.size.width/2];
        [self setFrame:CGRectMake(self.center.x - self.initFrame.size.width/2, self.center.y - self.initFrame.size.height/2, self.initFrame.size.width, self.initFrame.size.height)];
    }];
}

- (void)upDateFrame
{
    NSMutableArray *subViews = [NSMutableArray arrayWithArray:[self.superview subviews]];
    [subViews removeObject:self];
    for (UIView *subview in subViews)
    {
        if (![subview isKindOfClass:[self class]])
            continue;
        CGFloat centerLength = sqrtf(Square((subview.center.x - self.center.x)) + Square((subview.center.y - self.center.y)));
        
        if (centerLength < (self.bounds.size.width + subview.bounds.size.width)/2)
        {
            [self.nearByImgs addObject:subview];
        }
    }
    
    NSLog(@"%@",self.nearByImgs);
    if (self.nearByImgs.count == 0)
        return;
    
    // 相对self的center位置在相对坐标系的所在象限
    BOOL isInQuadrant_1 = NO; // 第一象限
    BOOL isInQuadrant_2 = NO; // 第二象限
    BOOL isInQuadrant_3 = NO; // 第三象限
    BOOL isInQuadrant_4 = NO; // 第四象限
    BOOL isInAxis_X_Right = NO; // X正半轴
    BOOL isInAxis_X_Left = NO; // X负半轴
    BOOL isInAxis_Y_Up = NO; // Y正半轴
    BOOL isInAxis_Y_Down = NO; // Y负半轴
    BOOL isInCenter = NO; // 两点重合
    
    for (UIView *subView in self.nearByImgs)
    {
        CGFloat relativeX = self.center.x - subView.center.x;
        CGFloat relativeY = self.center.y - subView.center.y;
        
        if (relativeX > 0 && relativeY > 0)
        {
            isInQuadrant_3 = YES;
        }
        else if (relativeX > 0 && relativeY < 0)
        {
            isInQuadrant_2 = YES;
        }
        else if (relativeX < 0 && relativeY > 0)
        {
            isInQuadrant_1 = YES;
        }
        else if (relativeX > 0 && relativeY > 0)
        {
            isInQuadrant_4 = YES;
        }
        else if (relativeX == 0 && relativeY > 0)
        {
            isInAxis_Y_Down = YES;
        }
        else if (relativeX == 0 && relativeY < 0)
        {
            isInAxis_Y_Up = YES;
        }
        else if (relativeX < 0 && relativeY == 0)
        {
            isInAxis_X_Right = YES;
        }
        else if (relativeX > 0 && relativeY == 0)
        {
            isInAxis_X_Left = YES;
        }
        else
        {
            isInCenter = YES;
        }
    }
    
    if (isInQuadrant_1 && isInQuadrant_2 && isInQuadrant_3 && isInQuadrant_4)
        return;

    if (isInAxis_X_Left && isInAxis_X_Right && isInAxis_Y_Up && isInAxis_Y_Down)
        return;
    
   __block CGPoint offsetPoint;

    // 第一象限空白
    if (!isInQuadrant_1 && isInQuadrant_2 && isInQuadrant_3 && isInQuadrant_4)
    {
        offsetPoint = CGPointMake(arc4random()%(int)xWidth, -arc4random()%(int)xWidth);
    }
    // 第二象限空白
    if (isInQuadrant_1 && !isInQuadrant_2 && isInQuadrant_3 && isInQuadrant_4)
    {
        offsetPoint = CGPointMake(-arc4random()%(int)xWidth, -arc4random()%(int)xWidth);
    }
    // 第三象限空白
    if (isInQuadrant_1 && isInQuadrant_2 && !isInQuadrant_3 && isInQuadrant_4)
    {
        offsetPoint = CGPointMake(-arc4random()%(int)xWidth, arc4random()%(int)xWidth);
    }
    // 第四象限空白
    if (isInQuadrant_1 && isInQuadrant_2 && isInQuadrant_3 && !isInQuadrant_4)
    {
        offsetPoint = CGPointMake(arc4random()%(int)xWidth, arc4random()%(int)xWidth);
    }
    // 第1，2象限空白
    if (!isInQuadrant_1 && !isInQuadrant_2 && isInQuadrant_3 && isInQuadrant_4)
    {
        if (arc4random()%2)
        {
            offsetPoint = CGPointMake( arc4random()%(int)xWidth, -arc4random()%(int)xWidth);
        }
        else
        {
            offsetPoint = CGPointMake( -arc4random()%(int)xWidth, -arc4random()%(int)xWidth);
        }
    }
    // 第1,3象限空白
    if (!isInQuadrant_1 && isInQuadrant_2 && !isInQuadrant_3 && isInQuadrant_4)
    {
        if (arc4random()%2)
        {
            offsetPoint = CGPointMake( arc4random()%(int)xWidth, -arc4random()%(int)xWidth);
        }
        else
        {
            offsetPoint = CGPointMake( -arc4random()%(int)xWidth, arc4random()%(int)xWidth);
        }
    }
    // 第1,4象限空白
    if (!isInQuadrant_1 && isInQuadrant_2 && isInQuadrant_3 && !isInQuadrant_4)
    {
        if (arc4random()%2)
        {
            offsetPoint = CGPointMake( arc4random()%(int)xWidth, -arc4random()%(int)xWidth);
        }
        else
        {
            offsetPoint = CGPointMake( arc4random()%(int)xWidth, arc4random()%(int)xWidth);
        }
    }
    // 第2,3象限空白
    if (isInQuadrant_1 && !isInQuadrant_2 && !isInQuadrant_3 && isInQuadrant_4)
    {
        if (arc4random()%2)
        {
            offsetPoint = CGPointMake( -arc4random()%(int)xWidth, -arc4random()%(int)xWidth);
        }
        else
        {
            offsetPoint = CGPointMake( -arc4random()%(int)xWidth, arc4random()%(int)xWidth);
        }
    }
    // 第2,4象限空白
    if (isInQuadrant_1 && !isInQuadrant_2 && isInQuadrant_3 && !isInQuadrant_4)
    {
        if (arc4random()%2)
        {
            offsetPoint = CGPointMake( arc4random()%(int)xWidth, arc4random()%(int)xWidth);
        }
        else
        {
            offsetPoint = CGPointMake( -arc4random()%(int)xWidth, -arc4random()%(int)xWidth);
        }
    }
    // 第3,4象限空白
    if (isInQuadrant_1 && isInQuadrant_2 && !isInQuadrant_3 && !isInQuadrant_4)
    {
        if (arc4random()%2)
        {
            offsetPoint = CGPointMake( arc4random()%(int)xWidth, arc4random()%(int)xWidth);
        }
        else
        {
            offsetPoint = CGPointMake( -arc4random()%(int)xWidth, arc4random()%(int)xWidth);
        }
    }
    // 第1,2,3象限空白
    if (!isInQuadrant_1 && !isInQuadrant_2 && !isInQuadrant_3 && isInQuadrant_4)
    {
        switch (arc4random()%3)
        {
            case 0:
            {
                offsetPoint = CGPointMake(arc4random()%(int)xWidth, -arc4random()%(int)xWidth);
            }
                break;
            case 1:
            {
                offsetPoint = CGPointMake(-arc4random()%(int)xWidth, arc4random()%(int)xWidth);
            }
                break;
            case 2:
            {
                offsetPoint = CGPointMake(-arc4random()%(int)xWidth, arc4random()%(int)xWidth);
            }
                break;
                
            default:
                break;
        }

    }
    // 第1,2,4象限空白
    if (!isInQuadrant_1 && !isInQuadrant_2 && isInQuadrant_3 && !isInQuadrant_4)
    {
        switch (arc4random()%3)
        {
            case 0:
            {
                offsetPoint = CGPointMake(arc4random()%(int)xWidth, -arc4random()%(int)xWidth);
            }
                break;
            case 1:
            {
                offsetPoint = CGPointMake(-arc4random()%(int)xWidth, -arc4random()%(int)xWidth);
            }
                break;
            case 2:
            {
                offsetPoint = CGPointMake(arc4random()%(int)xWidth, arc4random()%(int)xWidth);
            }
                break;
                
            default:
                break;
        }

    }
    // 第1,3,4象限空白
    if (!isInQuadrant_1 && isInQuadrant_2 && !isInQuadrant_3 && !isInQuadrant_4)
    {
        switch (arc4random()%3)
        {
            case 0:
            {
                offsetPoint = CGPointMake(arc4random()%(int)xWidth, -arc4random()%(int)xWidth);
            }
                break;
            case 1:
            {
                offsetPoint = CGPointMake(-arc4random()%(int)xWidth, arc4random()%(int)xWidth);
            }
                break;
            case 2:
            {
                offsetPoint = CGPointMake(arc4random()%(int)xWidth, arc4random()%(int)xWidth);
            }
                break;
                
            default:
                break;
        }

    }
    // 第2,3,4象限空白
    if (isInQuadrant_1 && !isInQuadrant_2 && !isInQuadrant_3 && !isInQuadrant_4)
    {
        switch (arc4random()%3)
        {
            case 0:
            {
                offsetPoint = CGPointMake(-arc4random()%(int)xWidth, -arc4random()%(int)xWidth);
            }
                break;
            case 1:
            {
                offsetPoint = CGPointMake(-arc4random()%(int)xWidth, arc4random()%(int)xWidth);
            }
                break;
            case 2:
            {
                offsetPoint = CGPointMake(arc4random()%(int)xWidth, arc4random()%(int)xWidth);
            }
                break;
                
            default:
                break;
        }
        
    }
    // x负半轴空白
    if (!isInAxis_X_Left && isInAxis_X_Right && isInAxis_Y_Up && isInAxis_Y_Down)
    {
        offsetPoint = CGPointMake(-arc4random()%(int)xWidth, 0);
    }
    // x正半轴空白
    if (isInAxis_X_Left && !isInAxis_X_Right && isInAxis_Y_Up && isInAxis_Y_Down)
    {
        offsetPoint = CGPointMake(arc4random()%(int)xWidth, 0);
    }
    // Y正半轴空白
    if (isInAxis_X_Left && isInAxis_X_Right && !isInAxis_Y_Up && isInAxis_Y_Down)
    {
        offsetPoint = CGPointMake(0, -arc4random()%(int)xWidth);
    }
    // Y负半轴空白
    if (isInAxis_X_Left && isInAxis_X_Right && isInAxis_Y_Up && !isInAxis_Y_Down)
    {
        offsetPoint = CGPointMake(0, arc4random()%(int)xWidth);
    }
    // x正负半轴空白
    if (!isInAxis_X_Left && !isInAxis_X_Right && isInAxis_Y_Up && isInAxis_Y_Down)
    {
        if (arc4random()%2)
        {
            offsetPoint = CGPointMake(arc4random()%(int)xWidth, 0);
        }
        else
        {
            offsetPoint = CGPointMake(arc4random()%(int)xWidth, 0);
        }
        
    }
    // x负半轴 Y正半轴空白
    if (!isInAxis_X_Left && isInAxis_X_Right && !isInAxis_Y_Up && isInAxis_Y_Down)
    {
        if (arc4random()%2)
        {
            offsetPoint = CGPointMake(-arc4random()%(int)xWidth, 0);
        }
        else
        {
            offsetPoint = CGPointMake(0, -arc4random()%(int)xWidth);
        }
    }
    // x负半轴 Y负半轴空白
    if (!isInAxis_X_Left && isInAxis_X_Right && isInAxis_Y_Up && !isInAxis_Y_Down)
    {
        if (arc4random()%2)
        {
            offsetPoint = CGPointMake(-arc4random()%(int)xWidth, 0);
        }
        else
        {
            offsetPoint = CGPointMake(0, arc4random()%(int)xWidth);
        }
    }
    // x正半轴,Y正半轴空白
    if (isInAxis_X_Left && !isInAxis_X_Right && !isInAxis_Y_Up && isInAxis_Y_Down)
    {
        if (arc4random()%2)
        {
            offsetPoint = CGPointMake(arc4random()%(int)xWidth, 0);
        }
        else
        {
            offsetPoint = CGPointMake(0, arc4random()%(int)xWidth);
        }
    }
    // x正半轴,Y负半轴空白
    if (isInAxis_X_Left && !isInAxis_X_Right && isInAxis_Y_Up && !isInAxis_Y_Down)
    {
        if (arc4random()%2)
        {
            offsetPoint = CGPointMake(arc4random()%(int)xWidth, 0);
        }
        else
        {
            offsetPoint = CGPointMake(0, -arc4random()%(int)xWidth);
        }
    }
    // Y正负半轴空白
    if (isInAxis_X_Left && isInAxis_X_Right && !isInAxis_Y_Up && !isInAxis_Y_Down)
    {
        if (arc4random()%2)
        {
            offsetPoint = CGPointMake(0, arc4random()%(int)xWidth);
        }
        else
        {
            offsetPoint = CGPointMake(0, -arc4random()%(int)xWidth);
        }
    }
    // x正负半轴 ，Y正半轴空白
    if (!isInAxis_X_Left && !isInAxis_X_Right && !isInAxis_Y_Up && isInAxis_Y_Down)
    {
        switch (arc4random()%3)
        {
            case 0:
            {
                offsetPoint = CGPointMake(arc4random()%(int)xWidth, 0);
            }
                break;
            case 1:
            {
                offsetPoint = CGPointMake(-arc4random()%(int)xWidth, 0);
            }
                break;
            case 2:
            {
                offsetPoint = CGPointMake(0, -arc4random()%(int)xWidth);
            }
                break;
            default:
                break;
        }
    }
    // x正负半轴，Y负半轴空白
    if (!isInAxis_X_Left && !isInAxis_X_Right && isInAxis_Y_Up && !isInAxis_Y_Down)
    {
        switch (arc4random()%3)
        {
            case 0:
            {
                offsetPoint = CGPointMake(arc4random()%(int)xWidth, 0);
            }
                break;
            case 1:
            {
                offsetPoint = CGPointMake(-arc4random()%(int)xWidth, 0);
            }
                break;
            case 2:
            {
                offsetPoint = CGPointMake(0, arc4random()%(int)xWidth);
            }
                break;
            default:
                break;
        }

    }
    // x负半轴, Y正负半轴空白
    if (!isInAxis_X_Left && isInAxis_X_Right && !isInAxis_Y_Up && !isInAxis_Y_Down)
    {
        switch (arc4random()%3)
        {
            case 0:
            {
                offsetPoint = CGPointMake(-arc4random()%(int)xWidth, 0);
            }
                break;
            case 1:
            {
                offsetPoint = CGPointMake(0, arc4random()%(int)xWidth);
            }
                break;
            case 2:
            {
                offsetPoint = CGPointMake(0, -arc4random()%(int)xWidth);
            }
                break;
            default:
                break;
        }

    }
    // x正半轴，Y正负半轴空白
    if (isInAxis_X_Left && !isInAxis_X_Right && !isInAxis_Y_Up && !isInAxis_Y_Down)
    {
        switch (arc4random()%3)
        {
            case 0:
            {
                offsetPoint = CGPointMake(arc4random()%(int)xWidth, 0);
            }
                break;
            case 1:
            {
                offsetPoint = CGPointMake(0, arc4random()%(int)xWidth);
            }
                break;
            case 2:
            {
                offsetPoint = CGPointMake(0, -arc4random()%(int)xWidth);
            }
                break;
            default:
                break;
        }

    }
    [self.nearByImgs removeAllObjects];
    
    if ((self.isFirstTime && !self.isFinished) || self.isFinished)
    {
        [UIView animateWithDuration:1.0 animations:^{
            [self setCenter:CGPointMake(self.center.x+offsetPoint.x, self.center.y+offsetPoint.y)];
        }
                         completion:^(BOOL finished)
         {
             self.isFinished = finished;
             if (finished)
             {
                 [self.nearByImgs removeAllObjects];
             }
         }];
    }
   
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.alpha = 0.0;
        self.initFrame = frame;
        self.isFinished = NO;
        self.isFirstTime = YES;
        [self setFrame:CGRectMake(frame.origin.x+frame.size.width/2, frame.origin.y+frame.size.height/2,1,1)];
        
        [NSTimer scheduledTimerWithTimeInterval:0.26 target:self selector:@selector(upDateFrame) userInfo:nil repeats:YES];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super initWithImage:image])
    {
        [NSTimer scheduledTimerWithTimeInterval:0.26 target:self selector:@selector(upDateFrame) userInfo:nil repeats:YES];
    }
    return self;
}

- (NSMutableArray *)nearByImgs
{
    if (_nearByImgs == nil)
    {
        _nearByImgs = [[NSMutableArray alloc] init];
    }
    return _nearByImgs;
}

- (void)dealloc
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
