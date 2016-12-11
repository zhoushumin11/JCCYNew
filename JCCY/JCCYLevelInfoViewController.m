//
//  JCCYLevelInfoViewController.m
//  JCCY
//
//  Created by 周书敏 on 2016/11/24.
//
//

#import "JCCYLevelInfoViewController.h"

@interface JCCYLevelInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JCCYLevelInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"等级介绍";
    
    UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth, PPMainViewHeight) style:UITableViewStyleGrouped];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [self.view addSubview:mainTableView];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, PPMainViewWidth, 55)];
    view.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth/2, 55)];
    lable1.textAlignment = NSTextAlignmentCenter;
    lable1.text = @"等级";
    lable1.backgroundColor = [UIColor clearColor];
    lable1.font = [UIFont systemFontOfSize:18];
    [view addSubview:lable1];
   
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(PPMainViewWidth/2, 0, PPMainViewWidth/2, 55)];
    lable2.textAlignment = NSTextAlignmentCenter;
    lable2.text = @"所需积分";
    lable2.backgroundColor = [UIColor clearColor];
    lable2.font = [UIFont systemFontOfSize:18];
    [view addSubview:lable2];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.levelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 54.5, PPMainViewWidth, 0.5)];
    lineLabel.backgroundColor = [UIColor colorFromHexRGB:@"d9d9d9"];
    [cell.contentView addSubview:lineLabel];
    
    if (indexPath.row == self.levelArray.count -1 && indexPath.row%2 != 0) {
        lineLabel.hidden = NO;
    }else{
        lineLabel.hidden = YES;
    }
    

    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth/2, 55)];
    lable1.textAlignment = NSTextAlignmentCenter;
    lable1.text = [[self.levelArray objectAtIndex:indexPath.row] objectForKey:@"level_name"];
    lable1.backgroundColor = [UIColor clearColor];
    lable1.font = [UIFont systemFontOfSize:16];
    [cell.contentView addSubview:lable1];
    
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(PPMainViewWidth/2, 0, PPMainViewWidth/2, 55)];
    lable2.textAlignment = NSTextAlignmentCenter;
    lable2.text = [[self.levelArray objectAtIndex:indexPath.row] objectForKey:@"level_cost"];
    lable2.backgroundColor = [UIColor clearColor];
    lable2.font = [UIFont systemFontOfSize:16];
    [cell.contentView addSubview:lable2];
    
    if ((indexPath.row+1 )% 2 == 0) {
        cell.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    
//    "level_cost" = 0;
//    "level_id" = "Lv.0";
//    "level_name" = "Lv.0";
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
