//
//  InstanceViewController.m
//  greengreatwall
//
//  Created by 葛朋 on 2019/12/10.
//  Copyright © 2019 guocaiduigong. All rights reserved.
//

#import "InstanceViewController.h"
#import "InstanceCollectionViewCell.h"
#import "InstanceTableViewCell.h"
#import "GoodsViewController.h"
@interface InstanceViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,SDCycleScrollViewDelegate,CategoryBarDelegate,XDSearchBarViewDelegate>
{
    UIView               *_viewTemp;
    UILabel              *_labelTemp;
    UIButton             *_buttonTemp;
    UIImageView          *_imageViewTemp;
    UITableView          *_tableViewTemp;
    UICollectionView     *_collectionViewTemp;
    UICollectionViewFlowLayout *_flowLayout;
    UIScrollView         *_scrollViewTemp;

    SDCycleScrollView    *_cycleScrollViewTemp;
    CategoryBar          *_categoryBarTemp;
    NavTitleSearchBar    *_searchBarTemp;
    UITextField          *_textFieldTemp;
    UITextView           *_textViewTemp;
    
    NSMutableDictionary *_cellDic;
    NSMutableArray      *_arrayDataSource;
    
    NSString            *_strParameter;
}



@end

static NSString * const ReuseIdentify = @"ReuseIdentify";

@implementation InstanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configInterface];
}

-(instancetype)init
{
    if (self = [super init]) {
        _arrayDataSource = [[NSMutableArray alloc]initWithCapacity:0];
        _strParameter = @"1";
    }
    return self;
}

-(void)dealloc
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBar.hidden = YES;
    //    self.tabBarController.tabBar.hidden = YES;
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setTintColor:kColorTheme];
    //    [self.navigationController.navigationBar setBarTintColor:kColorTheme];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    self.navigationController.navigationBar.hidden = NO;
    //    self.tabBarController.tabBar.hidden = NO;
    //    [self.navigationController.navigationBar setBackgroundImage:CreateImageWithColor(kColorTheme) forBarMetrics:UIBarMetricsDefault];
    //
    //    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //    [self.navigationController.navigationBar setBarTintColor:kColorTheme];
}

- (void)configInterface
{
    //添加搜索框
    _searchBarTemp = [[NavTitleSearchBar alloc]initWithFrame:CGRectMake(10, 5, GPScreenWidth-40, kNavBarHeight -10)];
    _searchBarTemp.searchDelegate = self;
    _searchBarTemp.placeholder = @"搜索商品";
    _searchBarTemp.backgroundColor = rgb(244, 244, 244);
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(10,0,GPScreenWidth-20,kNavBarHeight)];
    [titleView addSubview:_searchBarTemp];
    //Set to titleView
    self.navigationItem.titleView = titleView;
    
    [self setBackButtonWithTarget:self action:@selector(leftClick)];
    [self setLeftNavButtonImage:defaultImage Title:@"" Frame:CGRectMake(0, 0, 30, 30) Target:self action:@selector(leftClick)];
    [self setRightNavButtonWithImage:defaultImage Title:@"" Frame:CGRectMake(0, 0, 30, 30) Target:self action:@selector(rightClick)];
    [self settingNavTitle:@"例子"];
    viewSetBackgroundColor(kColorBasic);
    
    
    _viewTemp = [UIView initViewBackColor:[UIColor whiteColor]];
    [self.view addSubview:_viewTemp];
    [_viewTemp setFrame:CGRectMake(0, 0, GPScreenWidth, 120)];
    
    
    _imageViewTemp = [UIImageView initImageView:@"1"];
    [_viewTemp addSubview:_imageViewTemp];
    [_imageViewTemp setFrame:CGRectMake(10, 10, 60, 60)];
    
    
    _labelTemp = [UILabel initLabelTextFont:FontRegularWithSize(16) textColor:[UIColor blackColor] title:@"this is label"];
    _labelTemp.lineBreakMode = LineBreakModeDefault;
    _labelTemp.backgroundColor = [UIColor clearColor];
    [_viewTemp addSubview:_labelTemp];
    [_labelTemp setFrame:CGRectMake(80, 10, _viewTemp.width - 90, 30)];
    
    
    _buttonTemp = [UIButton initButtonTitleFont:16 titleColor:[UIColor blackColor] titleName:@""];
    _buttonTemp = [UIButton initButtonTitleFont:16 titleColor:[UIColor blackColor] titleName:@"" backgroundColor:[UIColor blueColor] radius:5];
    _buttonTemp = [UIButton initButtonTitleFont:16 titleColor:[UIColor blackColor] backgroundColor:[UIColor blueColor] imageName:@"" titleName:@""];
    [_buttonTemp addTarget:self tag:11 action:@selector(buttonClick:)];
    [_viewTemp addSubview:_buttonTemp];
    [_buttonTemp setFrame:CGRectMake(80, 50, 100, 20)];
    
    
    if (@available(iOS 13.0, *)) {
        _tableViewTemp = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, GPScreenWidth, 200) style:UITableViewStyleInsetGrouped];
    } else {
        // Fallback on earlier versions
        _tableViewTemp = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, GPScreenWidth, 200) style:UITableViewStyleGrouped];//UITableViewStyleGrouped
    }
    _tableViewTemp.showsVerticalScrollIndicator = NO;
    _tableViewTemp.showsHorizontalScrollIndicator = NO;
    _tableViewTemp.dataSource = self;
    _tableViewTemp.delegate = self;
    
    _tableViewTemp.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableViewTemp];
    [_tableViewTemp setFrame:CGRectMake(0, 0, GPScreenWidth, GPScreenHeight - kNavBarAndStatusBarHeight)];
    _tableViewTemp.tableHeaderView = _viewTemp;
    
    // 高度 = 屏幕高度 - 导航栏高度64 - 频道视图高度44
    CGFloat h = GPScreenHeight - kNavBarAndStatusBarHeight - kTabBarHeight ;
    CGRect frame = CGRectMake(0, 0, GPScreenWidth, h);
    
    _collectionViewTemp = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, GPScreenWidth, 200) collectionViewLayout:_flowLayout];
    _collectionViewTemp.delegate = self;
    _collectionViewTemp.dataSource = self;
    _collectionViewTemp.backgroundColor = [UIColor clearColor];
    [_collectionViewTemp registerClass:[InstanceCollectionViewCell class] forCellWithReuseIdentifier:ReuseIdentify];
    
    // 设置cell的大小和细节
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _flowLayout.minimumInteritemSpacing = 5.0;
    _flowLayout.minimumLineSpacing = 5.0;
    _flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    _flowLayout.itemSize = CGSizeMake(_collectionViewTemp.width/2.0-10, (_collectionViewTemp.width/2.0 -10)*(290.0/249.0));
    [_viewTemp addSubview:_collectionViewTemp];
    [_collectionViewTemp setFrame:frame];
    
    
    _scrollViewTemp = [[UIScrollView alloc]init];
    _scrollViewTemp.showsHorizontalScrollIndicator = NO;
    _scrollViewTemp.showsVerticalScrollIndicator = NO;
    _scrollViewTemp.backgroundColor = [UIColor clearColor];
    [_viewTemp addSubview:_scrollViewTemp];
    [_scrollViewTemp setFrame:CGRectMake(80, 50, 100, 20)];
    
    
    _cycleScrollViewTemp = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, GPScreenWidth, 100) delegate:self placeholderImage:defaultImage];
    _cycleScrollViewTemp.autoScrollTimeInterval = 3;
    _cycleScrollViewTemp.backgroundColor = [UIColor clearColor];
    _cycleScrollViewTemp.infiniteLoop = YES;
    _cycleScrollViewTemp.localizationImageNamesGroup = @[@"1",@"2",@"3"];
    [_viewTemp addSubview:_cycleScrollViewTemp];
    [_cycleScrollViewTemp setFrame:CGRectMake(80, 50, 100, 20)];
    
    
    _categoryBarTemp = [[CategoryBar alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, GPScreenWidth , 44)];
    _categoryBarTemp.backgroundColor = [UIColor clearColor];
    _categoryBarTemp.delegate = self;
    _categoryBarTemp.lineColor = rgb(0, 185, 142);
    _categoryBarTemp.itemTitles = @[@"推荐店铺",@"店铺分类"];
    _categoryBarTemp.font = FontRegularWithSize(13);
    _categoryBarTemp.titleColor = rgb(211, 211, 211);
    _categoryBarTemp.fontSelected = FontMediumWithSize(16);
    _categoryBarTemp.titleColorSelected = rgb(0, 185, 142);
    _categoryBarTemp.buttonColor = GPHexColor(0xF5F5F5);
    _categoryBarTemp.buttonColorSelected = GPHexColor(0xFFFFFF);
    _categoryBarTemp.buttonInset = 20;
    _categoryBarTemp.isVertical = NO;
    _categoryBarTemp.isSpread = NO;
    [_categoryBarTemp updateData];
    _categoryBarTemp.currentItemIndex = 0;
    [_viewTemp addSubview:_categoryBarTemp];
    [_categoryBarTemp setFrame:CGRectMake(80, 50, 100, 20)];
    
    _textFieldTemp = [UITextField initTextFieldFont:16 LeftImageName:@"1" Placeholder:@"placeholder"];
    [_viewTemp addSubview:_textFieldTemp];
    [_textFieldTemp setFrame:CGRectMake(80, 50, 100, 20)];
    
    _textViewTemp = [[UITextView alloc]init];
    [_viewTemp addSubview:_textViewTemp];
    [_textViewTemp setFrame:CGRectMake(80, 50, 100, 20)];
}

-(void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightClick
{
    
}

-(void)netRequest
{
    [HPNetManager POSTWithUrlString:HostStorestore_info isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:_stringFunction,@"stringFunction", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);

        if ([response[@"code"] integerValue] == 200) {
            self->_arrayDataSource = [NSMutableArray arrayWithArray:response[@"result"][@"goods_image"]];
            
        }
        else
        {
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
        
    } failureBlock:^(NSError *error) {
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

-(void)tapClick:(UIGestureRecognizer*)tap
{
    NSInteger index = tap.view.tag - 200;
    NSString *strurl = @"asd";
    if (!IsStringEmptyOrNull(strurl))
    {
        
    }
}

-(void)buttonClick:(UIButton*)btn
{
    NSString *buttonName = btn.titleLabel.text;
    if ([buttonName containsString:@"保洁"])
    {
        
    }
    else if([buttonName containsString:@"保姆"])
    {
        
    }
}

- (void)setupRefreshWithScrollView:(UIScrollView *)scrollView
{
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    
    // Set title
    [header setTitle:@"下拉加载最新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松开加载" forState:MJRefreshStatePulling];
    [header setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [header setLastUpdatedTimeText:^NSString *(NSDate *lastUpdatedTime) {
        NSDate *lastTime = lastUpdatedTime;
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        NSInteger hour = [[NSCalendar currentCalendar] component:NSCalendarUnitHour fromDate:lastTime];
        if (hour >12) {
            fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss 下午";
        }else{
            fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss 上午";
        }
        NSString *timeStr = [fmt stringFromDate:lastTime];
        return timeStr;
    }];
    
    // Set font
    header.stateLabel.font = FontRegularWithSize(15);
    header.lastUpdatedTimeLabel.font = FontRegularWithSize(14);
    
    // Set textColor
    header.stateLabel.textColor = kColorFontRegular;
    header.lastUpdatedTimeLabel.textColor = kColorFontRegular;
    
    //头部刷新控件
    scrollView.mj_header = header;
    
    CGFloat _viewh = _viewTemp.bottom;
    scrollView.mj_header.ignoredScrollViewContentInsetTop = _viewh + kScrollViewHeaderIgnored;
    
    MJRefreshBackStateFooter *footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    
    // Set title
    [footer setTitle:@"点击或上拉加载更多数据" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
    
    // Set font
    footer.stateLabel.font = FontRegularWithSize(17);
    
    // Set textColor
    footer.stateLabel.textColor = kColorFontRegular;
    
    //尾部刷新控件
    scrollView.mj_footer = footer;
    scrollView.mj_footer.ignoredScrollViewContentInsetBottom = kScrollViewFooterIgnored;
}



//下拉刷新
- (void)headerRereshing
{
    [self netRequest];
    
    _strParameter = @"1";
    [_arrayDataSource removeAllObjects];
    [_collectionViewTemp reloadData];
    
    [HPNetManager POSTWithUrlString:HostIndexgetCommendGoods isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:_strParameter,@"page", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            if ([[NSArray arrayWithArray:response[@"result"]] count]) {
                [self->_arrayDataSource removeAllObjects];
                [self->_collectionViewTemp reloadData];
                
                [self->_arrayDataSource addObjectsFromArray:[NSArray arrayWithArray:response[@"result"]]];
                [self->_collectionViewTemp reloadData];
                [self->_collectionViewTemp.mj_header endRefreshing];
                self->_strParameter = [NSString stringWithFormat:@"%d",self->_strParameter.intValue+1];
            }
            else
            {
                [self->_collectionViewTemp.mj_header endRefreshing];
            }
        }
        else
        {
            [self->_collectionViewTemp.mj_header endRefreshing];
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
    } failureBlock:^(NSError *error) {
        [self->_collectionViewTemp.mj_header endRefreshing];
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
}

//上拉加载更多
- (void)footerRereshing
{
    [HPNetManager POSTWithUrlString:HostIndexgetCommendGoods isNeedCache:NO parameters:[NSDictionary dictionaryWithObjectsAndKeys:_strParameter,@"page", nil] successBlock:^(id response) {
        //GPDebugLog(@"response:%@",response);
        if ([response[@"code"] integerValue] == 200) {
            if ([[NSArray arrayWithArray:response[@"result"]] count]) {
                [self->_arrayDataSource addObjectsFromArray:[NSArray arrayWithArray:response[@"result"]]];
                [self->_collectionViewTemp reloadData];
                [self->_collectionViewTemp.mj_footer endRefreshing];
                self->_strParameter = [NSString stringWithFormat:@"%d",self->_strParameter.intValue+1];
            }
            else
            {
                [self->_collectionViewTemp.mj_footer endRefreshing];
            }
        }
        else
        {
            [self->_collectionViewTemp.mj_footer endRefreshing];
            [HPAlertTools showTipAlertViewWith:self title:@"提示信息" message:response[@"message"] buttonTitle:@"确定" buttonStyle:HPAlertActionStyleDefault];
        }
    } failureBlock:^(NSError *error) {
        [self->_collectionViewTemp.mj_footer endRefreshing];
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        
    }];
    
}
#pragma mark - textFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    SearchViewController *scVC = [[SearchViewController alloc]init];
    scVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scVC animated:YES];
    return NO;
}

#pragma mark - SDCycleScrollViewDelegate

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    //GPDebugLog(@"tapIndex:%ld",(long)index);
}

#pragma mark - CategoryBarDelegate

- (void)itemDidSelectedWithIndex:(NSInteger)index withCurrentIndex:(NSInteger)currentIndex
{
    [_collectionViewTemp scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}
#pragma mark -XDSearchBarViewDelegate

- (void)XDSearchBarViewShouldReturn:(NSString *)keyword
{
    
}

- (BOOL)XDSearchBarViewShouldBeginEditing:(nonnull UITextField *)textField {
    
    return YES;
}

#pragma mark - scrollViewDelegate
/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

/** 手指滑动CollectionView，滑动结束后调用 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_collectionViewTemp]) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
    }
}

/** 手指点击smallScrollView */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / scrollView.width;
    //GPDebugLog(@"ScrollIndex:%ld",(long)index);
}





#pragma mark - UITableViewDelegate, UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayDataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 360.0*GPCommonLayoutScaleSizeWidthIndex;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InstanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentify];
    if(!cell){
        cell = [[InstanceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseIdentify];
    }
    NSDictionary * dic = _arrayDataSource[indexPath.row];
    cell.dic = dic;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsViewController *vc = [[GoodsViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.goods_id = _arrayDataSource[indexPath.row][@"goods_id"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"%@%@", ReuseIdentify, [NSString stringWithFormat:@"%@", indexPath]];
        [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        [_collectionViewTemp registerClass:[InstanceCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    }
    
    InstanceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.dic = _arrayDataSource[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arrayDataSource.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsViewController *vc = [[GoodsViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    
    vc.goods_id = _arrayDataSource[indexPath.row][@"goods_id"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - lazy load懒加载

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
