//
//  TYADPhotoLoop.m
//  CollectionView
//
//  Created by tiny on 16/7/12.
//  Copyright © 2016年 tiny. All rights reserved.
//

#import "TYADPhotoLoop.h"
#import "TYCustomCell.h"

#define kMaxSection  100
#define kViewWidth self.frame.size.width
#define kViewHeight self.frame.size.height
@interface TYPageControl ()
@property (nonatomic, strong)UIImage *currentImage;
@property (nonatomic, strong)UIImage *inactiveImage;
@end

@implementation TYPageControl

- (instancetype)initWithFrame:(CGRect)frame
             currentImageName:(NSString *)currentImageName
           indicatorImageName:(NSString *)indicatorImageName {
    self = [super initWithFrame:frame];
    if (self) {
        self.currentImage = [UIImage imageNamed:currentImageName];
        self.inactiveImage = [UIImage imageNamed:indicatorImageName];
    }
    return self;
}

//图片切换时，改变pagecontrol 的图片
- (void)updateDots {
    for (int i = 0; i < [self.subviews count]; i++) {
        UIImageView * dot = [self imageViewForSubview:  [self.subviews objectAtIndex: i]];
        if (i == self.currentPage) dot.image = self.currentImage;
        else dot.image = self.inactiveImage;
    }
}

- (UIImageView *)imageViewForSubview:(UIView *) view {
    UIImageView * dot = nil;
    if ([view isKindOfClass: [UIView class]]) {
        for (UIView* subview in view.subviews) {
            if ([subview isKindOfClass:[UIImageView class]]) {
                dot = (UIImageView *)subview;
                break;
            }
        }
        if (dot == nil) {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height)];
            [view addSubview:dot];
        }
    }else {
        dot = (UIImageView *) view;
    }
    
    return dot;
}

- (void)setCurrentPage:(NSInteger)currentPage {
    [super setCurrentPage:currentPage];
    [self updateDots];
}

@end



@interface TYADPhotoLoop ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,strong)UICollectionViewFlowLayout *flowLayout;

@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic,copy) photoClickEvent clickEvent;

@end

@implementation TYADPhotoLoop

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initialize];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self initialize];
        
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
    self.flowLayout.itemSize = CGSizeMake(kViewWidth, kViewHeight);
    self.pageControl.center = CGPointMake(self.center.x, kViewHeight - 20);
}


-(void)setPhotos:(NSArray *)photos
{
    if (_photos == photos) { return ;}
    
    _photos = photos;
    
    _pageControl.numberOfPages = photos.count;
    //更新图片，更新布局
    
}

-(void)initialize
{
    //初始化collectionView
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.itemSize = CGSizeMake(kViewWidth, kViewHeight);
    flowlayout.minimumLineSpacing = 0;
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout = flowlayout;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowlayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerNib:[UINib nibWithNibName:@"TYCustomCell" bundle:nil] forCellWithReuseIdentifier:@"customCell"];
    collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:collectionView];
    _collectionView = collectionView;

    //PageControl
    TYPageControl *pageControl = [[TYPageControl alloc] initWithFrame:CGRectMake(10, kViewHeight - 20, kViewWidth - 20, 20) currentImageName:@"point_sel" indicatorImageName:@"point"];
    //    pageControl.backgroundColor = [UIColor redColor];
    
    _pageControl.currentPage = 0;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.userInteractionEnabled = YES;
    _pageControl = pageControl;
    [self addSubview:pageControl];
    
    //初始化基本参数
    self.duration = 2.5f;
    self.isEnableLoopTimer = YES;
}

-(void)setIsEnableLoopTimer:(BOOL)isEnableLoopTimer
{
    if (_isEnableLoopTimer == isEnableLoopTimer) {
        return;
    }
    
    _isEnableLoopTimer = isEnableLoopTimer;
    if (_isEnableLoopTimer) {
        [self timer];
    }
    else
    {
        if ([_timer isValid]) {
            [_timer invalidate];
            _timer = nil;
        }
    }
}


-(NSTimer *)timer
{
    if (_timer == nil) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.duration target:self selector:@selector(timeLoop) userInfo:nil repeats:YES];
    }
    return _timer;
}


-(void)timeLoop
{
    if (self.photos.count == 0) {
        return;
    }
    
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:kMaxSection/2];
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    NSInteger nextItem = currentIndexPathReset.item +1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem==self.photos.count) {
        nextItem=0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    self.pageControl.currentPage  = nextItem;
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}


-(void)addTouchEvent:(photoClickEvent)event
{
    self.clickEvent = event;
}



#pragma mark - UICollectionViewDelegate & UICollectionViewDateSoure
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return kMaxSection;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TYCustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"customCell" forIndexPath:indexPath];
    
    //在这里设置图片显示的内容，如果cell还需要其他元素可以在customCell中自由定制UiView
    
    cell.imgView.image = [UIImage imageNamed:self.photos[indexPath.row]];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    //将点击事件传递出去
    if (self.clickEvent) {
        self.clickEvent(self,indexPath.row);
    }
    
}

#pragma mark - scollView滚动代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.photos.count <=0) {
        return;
    }
    //拿到当前滚动的Index
    NSInteger index = (int)(scrollView.contentOffset.x/kViewWidth +0.5) % self.photos.count ;
    //防止数组越界
    if (index <0) {
        index = 0;
    }
    if (index > self.photos.count - 1) {
        index = self.photos.count -1;
    }
    
    //这里配置相关属性
    self.pageControl.currentPage = index;
}

@end
