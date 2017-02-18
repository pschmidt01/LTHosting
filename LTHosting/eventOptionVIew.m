//
//  eventOptionVIew.m
//  LTHosting
//
//  Created by Cam Feenstra on 2/7/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "eventOptionVIew.h"
#import "stackView.h"

@interface eventOptionView(){
    
    BOOL accessoryShowing;
    
    CGFloat barHeight;
}
@end

@implementation eventOptionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

BOOL hasAddedBaseline=NO;

-(id)initWithFrame:(CGRect)frame
{
    self=[self initWithFrame:frame barHeight:60];
    return self;
}

-(id)initWithFrame:(CGRect)frame barHeight:(CGFloat)barHeigh
{
    self=[super initWithFrame:frame];
    barHeight=barHeigh;
    accessoryShowing=NO;
    _barView=[self defaultBarView];
    [self insertArrangedSubview:_barView atIndex:0];
    _myDelegate=nil;
    _accessoryView=nil;
    self.axis=UILayoutConstraintAxisVertical;
    self.distribution=UIStackViewDistributionFill;
    self.alignment=UIStackViewAlignmentFill;
    return self;
}

-(UIView*)defaultBarView
{
    stackView *new=[[stackView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, barHeight)];;
    [new setBackgroundColor:[UIColor flatWhiteColor]];
    CGFloat width=0.5f;
    UIView *bottom=[[UIView alloc] initWithFrame:CGRectMake(0, new.frame.size.height-width, new.frame.size.width, width)];
    [bottom setBackgroundColor:[UIColor blackColor]];
    [new addSubview:bottom];
    UIView *top=[[UIView alloc] initWithFrame:CGRectMake(0, 0, new.frame.size.width, width)];
    [top setBackgroundColor:[UIColor blackColor]];
    [new addSubview:top];
    [new addSubview:bottom];
    [new.layer setShadowColor:[UIColor darkGrayColor].CGColor];
    [new.layer setShadowRadius:8.0f];
    [new.layer setShadowOpacity:.5f];
    if([self hasAccessoryView])
    {
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [new addGestureRecognizer:tap];
        tap.delegate=self;
    }
    return new;
}

-(IBAction)tapped:(id)sender{
    [self tapBar];
}

-(BOOL)hasAccessoryView
{
    return _accessoryView!=nil;
}

-(BOOL)isAccessoryViewShowing
{
    return accessoryShowing;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)tapBar
{
    if(_accessoryView!=nil)
    {
        if(_myDelegate!=nil)
        {
            [_myDelegate accessoryShowingWillChangeForEventOptionView:self];
        }
        [UIView animateWithDuration:.25 animations:^{
            _accessoryView.hidden=!_accessoryView.hidden;
        } completion:^(BOOL finished){
            accessoryShowing=!_accessoryView.hidden;
            if(_myDelegate!=nil)
            {
                [_myDelegate accessoryShowingDidChangeForEventOptionView:self];
            }
        }];
        
    }
}

-(void)setBarHeight:(CGFloat)barHeigh
{
    barHeight=barHeigh;
    if(_barView!=nil)
    {
        [_barView removeFromSuperview];
        
    }
}

-(CGFloat)barHeight
{
    return barHeight;
}

-(UIView*)inputAccessoryView
{
    UIView *test=[[UIView alloc] initWithFrame:self.barView.frame];
    [test setBackgroundColor:[UIColor blackColor]];
    return nil;
}

-(void)detailEditingWillEnd
{
    
}

@end
