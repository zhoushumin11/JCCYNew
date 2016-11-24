//
//  HomeFirstCell.m
//  JCCY
//
//  Created by 周书敏 on 2016/11/23.
//
//

#import "HomeFirstCell.h"

@implementation HomeFirstCell
@synthesize h_imgView,h_titleLabel,allcontentView;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        //        self.selectionStyle = UITableViewCellSelectionStyleNone;
        h_imgView = [[UIImageView alloc] init];
        allcontentView = [[UIView alloc] init];
        h_titleLabel = [[UILabel alloc] init];

        
        allcontentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:allcontentView];
        
        
        h_imgView.contentMode = UIViewContentModeScaleAspectFit;
        h_imgView.clipsToBounds = YES;
        h_imgView.contentMode = UIViewContentModeScaleAspectFill;
        [allcontentView addSubview:h_imgView];
        
        
        h_titleLabel.textColor = [UIColor blackColor];
        h_titleLabel.font = SystemFont(15);
        h_titleLabel.numberOfLines = 2;
        h_titleLabel.textAlignment = NSTextAlignmentLeft;
        [allcontentView addSubview:h_titleLabel];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    allcontentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    h_titleLabel.frame = CGRectMake(120, 20, self.bounds.size.width-140, 50);
    h_imgView.frame = CGRectMake(10,10, 100,70);

}



@end
