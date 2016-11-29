//
//  ThreeViewController.m
//  JCCY
//
//  Created by 周书敏 on 2016/11/18.
//
//

#import "RedPacketViewController.h"

#import "RedPacketTableViewCell.h"

#import "JCCYBuyVipViewController.h"

@interface RedPacketViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *mainTableView;

@property(nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation RedPacketViewController
@synthesize mainTableView,dataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"红包";
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorFromHexRGB:@"e60013"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    dataArray = [NSMutableArray array];
    
    NSString *ZANSHANG_USE_CONTENT  = [[NSUserDefaults standardUserDefaults] objectForKey:@"ZANSHANG_USE_CONTENT"];
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"redPacket_zangshang",@"imgName",@"赞赏",@"title",@"ffa800",@"color",ZANSHANG_USE_CONTENT,@"info",@"剩余26天",@"endDays", nil];
    [dataArray addObject:dic1];
    
    NSString *ZUANSHI_USE_CONTENT  = [[NSUserDefaults standardUserDefaults] objectForKey:@"ZUANSHI_USE_CONTENT"];
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:@"redPacket_zuanshi",@"imgName",@"钻石",@"title",@"18a3dc",@"color",ZUANSHI_USE_CONTENT,@"info",@"剩余26天",@"endDays", nil];
    [dataArray addObject:dic2];
    
    NSString *HUANGJIN_USE_CONTENT  = [[NSUserDefaults standardUserDefaults] objectForKey:@"HUANGJIN_USE_CONTENT"];
    NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys:@"redPacket_huangjin",@"imgName",@"黄金",@"title",@"ff6e4e",@"color",HUANGJIN_USE_CONTENT,@"info",@"剩余26天",@"endDays", nil];
    [dataArray addObject:dic3];
    
    [self creatMainView];
}

//创建主视图
-(void)creatMainView{
    self.view.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, PPMainViewWidth,self.view.bounds.size.height+2) style:UITableViewStylePlain];
    mainTableView.backgroundColor = [UIColor clearColor];
    mainTableView.separatorInset = UIEdgeInsetsZero;
    //        _bulletinlistTableView.tableHeaderView = [[UIView alloc] init];
    if ([mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [mainTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [mainTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    mainTableView.separatorColor = [UIColor colorFromHexRGB:@"f0f0f0"];
    MJRefreshNormalHeader *cmheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView)];//@selector(loadMylogList)
    cmheader.lastUpdatedTimeLabel.hidden = YES;
    
    mainTableView.mj_footer.hidden = YES;
    
    mainTableView.mj_header = cmheader;
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    
    [self.view addSubview:mainTableView];
    
    [mainTableView  reloadData];
    
}

-(void)refreshTableView{
    if ([mainTableView.mj_header isRefreshing]) {
        [mainTableView.mj_header endRefreshing];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"RedPacketTableViewCell";
    
    RedPacketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        cell = [[RedPacketTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.contentView.backgroundColor = [UIColor colorFromHexRGB:@"f0f0f0"];
    
    cell.allcontentView.frame = CGRectMake(0, 0, PPMainViewWidth, 135);
    
    [cell.r_imgBtn setImage:[UIImage imageNamed:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"imgName"]] forState:UIControlStateNormal];
    cell.r_titleLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.r_EndDaysLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"endDays"];
    cell.r_enterInBtn.backgroundColor = [UIColor colorFromHexRGB:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"color"]];
    [cell.r_buyBtn setTitleColor:[UIColor colorFromHexRGB:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"color"]] forState:UIControlStateNormal];
    cell.r_buyBtn.layer.borderColor=[UIColor colorFromHexRGB:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"color"]].CGColor;

    cell.r_UseInfoLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"info"];
    cell.r_buyBtn.tag = indexPath.row+100;
    [cell.r_buyBtn addTarget:self action:@selector(rBuyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.r_enterInBtn.tag = indexPath.row+200;
    [cell.r_enterInBtn addTarget:self action:@selector(rEnterBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

//点击购买
-(void)rBuyBtnAction:(UIButton *)btn{
    
    JCCYBuyVipViewController *jCCYBuyVipViewController = [[JCCYBuyVipViewController alloc] init];
    jCCYBuyVipViewController.hidesBottomBarWhenPushed = YES;
    jCCYBuyVipViewController.buyType = btn.tag - 100;
    [self.navigationController pushViewController:jCCYBuyVipViewController animated:YES];
}

//点击进入
-(void)rEnterBtnAction:(UIButton *)btn{
    if (btn.tag == 200) {
        
    }else if (btn.tag == 201){
        
    }else if (btn.tag == 202){
        
    }
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
