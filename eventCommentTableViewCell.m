//
//  eventCommentTableViewCell.m
//  LTHosting
//
//  Created by Cam Feenstra on 3/27/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "eventCommentTableViewCell.h"

@interface eventCommentTableViewCell(){
    UILabel *textLabel;
    UIImageView *imageView;
    UIImageView *profPicView;
    UIView *bottom;
}

@end

@implementation eventCommentTableViewCell

@dynamic item;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)cellDidLoad{
    [super cellDidLoad];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    bottom=[[UIView alloc] initWithFrame:CGRectMake(0, [eventCommentTableViewCell heightWithItem:self.item tableViewManager:self.tableViewManager]-1.0f, self.tableViewManager.tableView.frame.size.width, 1.0f)];
    [self addSubview:bottom];
    bottom.backgroundColor=[UIColor blackColor];
    CGFloat margin=12.0f;
    CGFloat pwidth=64.0f;
    profPicView=[[UIImageView alloc] initWithFrame:CGRectMake(margin, margin, pwidth, pwidth)];
    profPicView.layer.cornerRadius=profPicView.frame.size.height/2;
    profPicView.layer.masksToBounds=YES;
    textLabel=[[UILabel alloc] initWithFrame:CGRectMake(profPicView.frame.origin.x+profPicView.frame.size.width+margin, profPicView.frame.origin.y, self.tableViewManager.tableView.frame.size.width-(profPicView.frame.origin.x+profPicView.frame.size.width+margin)-margin, 64.0f)];
    textLabel.numberOfLines=0;
    imageView=[[UIImageView alloc] initWithFrame:CGRectMake(margin, textLabel.frame.origin.y+textLabel.frame.size.height+margin, self.tableViewManager.tableView.frame.size.width-margin*2, self.tableViewManager.tableView.frame.size.width-margin*2)];
    [self addSubview:profPicView];
    [self addSubview:textLabel];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    bottom.frame=CGRectMake(0, self.frame.size.height-1.0f, self.frame.size.width, 1.0f);
}

-(void)cellWillAppear{
    [super cellWillAppear];
    [self addSubview:imageView];
    textLabel.attributedText=[[NSAttributedString alloc] initWithString:self.item.comment.text attributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody],NSForegroundColorAttributeName:[UIColor blackColor]}];
    [textLabel setFrame:CGRectMake(textLabel.frame.origin.x, textLabel.frame.origin.y, textLabel.frame.size.width, [textLabel.attributedText boundingRectWithSize:CGSizeMake(textLabel.frame.size.width, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) context:nil].size.height)];
    profPicView.image=self.item.comment.poster.profileImage;
    if(self.item.comment.image!=nil){
        imageView.contentMode=UIViewContentModeScaleAspectFill;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            imageView.image=self.item.comment.image;
        }];
        imageView.layer.masksToBounds=YES;
        imageView.frame=CGRectMake(imageView.frame.origin.x, MAX(textLabel.frame.origin.y+textLabel.frame.size.height,profPicView.frame.origin.y+profPicView.frame.size.height)+imageView.frame.origin.x, imageView.frame.size.width, imageView.frame.size.height);
    }
    else{
        [imageView removeFromSuperview];
    }
}

+(CGFloat)heightWithItem:(eventCommentTableViewItem *)item tableViewManager:(RETableViewManager *)tableViewManager{
    if(item==nil){
        return 0;
    }
    CGFloat width=tableViewManager.tableView.frame.size.width;
    CGFloat margin=12.0f;
    BOOL hasImage=item.comment.image!=nil;
    CGFloat profPicWidth=64.0f;
    CGFloat textWidth=width-margin*3-profPicWidth;
    UIFont *font=[UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    NSAttributedString *text=[[NSAttributedString alloc] initWithString:item.comment.text attributes:@{NSFontAttributeName:font}];
    CGFloat textHeight=[text boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) context:nil].size.height;
    if(!hasImage){
        NSLog(@"no image");
        return margin*2+MAX(textHeight,profPicWidth);
    }
    else{
        return margin*3+MAX(textHeight, profPicWidth)+width-margin*2;
    }
}

@end