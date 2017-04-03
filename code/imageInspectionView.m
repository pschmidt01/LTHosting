//
//  imageInspectionView.m
//  LTHosting
//
//  Created by Cam Feenstra on 3/30/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "imageInspectionView.h"

@interface imageInspectionView(){
    UIImageView *imageView;
    UIScrollView *contentView;
    NSDate *last;
    UIButton *xButton;
    CGFloat drag;
}

@end

@implementation imageInspectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    [self fakeInit];
    last=nil;
    drag=0.5f;
    return self;
}

-(id)init{
    self=[super init];
    [self fakeInit];
    return self;
}

-(void)fakeInit{
    imageView=nil;
    contentView=[[UIScrollView alloc] init];
    contentView.delegate=self;
    contentView.minimumZoomScale=1.0f;
    contentView.maximumZoomScale=5.0f;
    [self addSubview:contentView];
    self.backgroundColor=[UIColor blackColor];
    xButton=[[UIButton alloc] init];
    xButton.frame=CGRectMake(0, 0, 32, 32);
    [xButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"X" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],NSStrokeColorAttributeName:[UIColor blackColor],NSStrokeWidthAttributeName:[NSNumber numberWithFloat:-2.0f]}] forState:UIControlStateNormal];
    [xButton addTarget:self action:@selector(xPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:xButton];
    UITapGestureRecognizer *doubleTap=[[UITapGestureRecognizer alloc] init];
    doubleTap.numberOfTapsRequired=2;
    [doubleTap addTarget:self action:@selector(doubleTapped:)];
    [self addGestureRecognizer:doubleTap];
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    [self addGestureRecognizer:pan];
}

-(void)panned:(UIPanGestureRecognizer*)pan{
    if(pan.state==UIGestureRecognizerStateEnded){
        [self draggingEnded:pan];
    }
    else if(pan.state==UIGestureRecognizerStateBegan){
        [self draggingBegan:pan];
    }
    else{
        [self draggingChanged:pan];
    }
}

-(void)draggingEnded:(UIPanGestureRecognizer*)pan{
    NSLog(@"ended");
    NSTimeInterval decelInt=.15f;
    [self beginDecelerationWithVelocity:[pan velocityInView:self].y*(1.0f-drag) timeInterval:decelInt endBlock:^{
        if(fabs(self.frame.origin.y)>[self maxCenterDistance]){
            [self dismissSelf];
        }
        else{
            [UIView transitionWithView:self duration:.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            }completion:^(BOOL finished){
                
            }];
        }
    }];
}

-(void)beginDecelerationWithVelocity:(CGFloat)velocity timeInterval:(NSTimeInterval)time endBlock:(void(^)())endBlock{
    CGFloat aconst=3.0f;
    CGFloat acceleration=aconst*(velocity>0?-1.0f:1.0f);
    CGFloat (^x)(CGFloat t)=^CGFloat(CGFloat t){
        return velocity*t+0.5f*(acceleration*t*t);
    };
    CGFloat (^v)(CGFloat t)=^CGFloat(CGFloat t){
        return velocity+(acceleration*t);
    };
    [UIView animateWithDuration:time animations:^{
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y+x(time), self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished){
        if(fabs(v(time))>0.01f||(v(time)>=0)!=(velocity>=0)){
            if(endBlock!=nil){
                endBlock();
            }
        }
        else{
            [self beginDecelerationWithVelocity:v(time) timeInterval:time endBlock:endBlock];
        }
    }];
}

-(void)draggingChanged:(UIPanGestureRecognizer*)pan{
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y+([pan velocityInView:self].y*[[NSDate date] timeIntervalSinceDate:last]*(1.0f-drag)), self.frame.size.width, self.frame.size.height);
    last=[NSDate date];
}

-(void)draggingBegan:(UIPanGestureRecognizer*)pan{
    last=[NSDate date];
}

-(void)doubleTapped:(UITapGestureRecognizer*)tap{
    if(contentView.zoomScale==1.0f){
        [UIView animateWithDuration:.25 animations:^{
            [contentView setZoomScale:3.0f];
            [self setZoomCenter:[tap locationInView:self]];
        }];
    }
    else{
        [UIView animateWithDuration:.25 animations:^{
            [contentView setZoomScale:1.0f];
        }];
    }
}

-(void)setZoomCenter:(CGPoint)center{
    CGFloat scale=contentView.zoomScale;
    CGPoint effectiveCenter=CGPointMake(center.x*scale, center.y*scale);
    [contentView setContentOffset:CGPointMake(effectiveCenter.x-self.frame.size.width/2, effectiveCenter.y-self.frame.size.height/2)];
}

-(void)xPressed:(UIButton*)xbut{
    [self dismissSelf];
}

-(void)dismissSelf{
    [UIView animateWithDuration:.25 animations:^{
        self.frame=CGRectMake(0, self.frame.origin.y>[self maxCenterDistance]?self.frame.size.height:-self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished){
        if(_delegate!=nil){
            [_delegate inspectionViewDidDismiss:self];
        }
    }];
}

-(CGFloat)maxCenterDistance{
    return self.frame.size.height/2;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    contentView.frame=self.bounds;
    xButton.center=CGPointMake(self.frame.size.width-xButton.frame.size.width/2, xButton.frame.size.height/2+20.0f);
}

-(UIImageView*)imageView{
    return imageView;
}

-(void)setImageView:(UIImageView *)imView{
    if(imageView!=nil){
        [imageView removeFromSuperview];
    }
    CGRect initFrame=[imView convertRect:imView.bounds toView:self];
    imageView=imView;
    imageView.frame=initFrame;
    
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    [contentView addSubview:imageView];
    [UIView animateWithDuration:.25 animations:^{
        imageView.frame=self.bounds;
    } completion:^(BOOL finished){
        NSLog(@"%@",finished?@"Yes":@"No");
    }];
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return imageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
}

-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    
}

@end