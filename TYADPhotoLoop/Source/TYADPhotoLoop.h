//
//  TYADPhotoLoop.h
//  CollectionView
//
//  Created by tiny on 16/7/12.
//  Copyright © 2016年 tiny. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TYADPhotoLoop;
typedef void(^photoClickEvent)(TYADPhotoLoop *photoLoop,NSInteger selectIndex);

@interface TYADPhotoLoop : UIView

/**
 *  要显示的图片数组 - 有需要的可以传模型 方法同图片数组类似
 */
@property (nonatomic,strong)NSArray *photos;

/**
 *  暴露pageControl 以方便定制位置和颜色
 */
@property (nonatomic,strong)UIPageControl *pageControl;

/**
 *  轮播图定时器是否开启  默认开启
 */
@property (nonatomic,assign) BOOL isEnableLoopTimer;

/**
 *  轮播图定时时间 默认2.5s
 */
@property (nonatomic,assign) NSTimeInterval duration;

-(void)addTouchEvent:(photoClickEvent)event;

@end
