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
        h_imgView.layer.cornerRadius = 8;
        h_imgView.contentMode = UIViewContentModeScaleAspectFill;
        [allcontentView addSubview:h_imgView];
        
        
        h_titleLabel.textColor = [UIColor colorFromHexRGB:@"333333"];
        h_titleLabel.font = [UIFont systemFontOfSize:20];
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
    if (PPMainViewWidth < 350) {
        h_titleLabel.frame = CGRectMake(140, 25, self.bounds.size.width-138, 60);
        h_imgView.frame = CGRectMake(10,20, 120,80);
    }else{
        h_titleLabel.frame = CGRectMake(175, 35, self.bounds.size.width-178, 60);
        h_imgView.frame = CGRectMake(10,20, 150,100);
    }


}



@end
