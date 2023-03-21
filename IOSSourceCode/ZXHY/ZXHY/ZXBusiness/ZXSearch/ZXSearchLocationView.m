//
//  ZXSearchLocationView.m
//  ZXHY
//
//  Created by Bern Lin on 2021/12/31.
//

#import "ZXSearchLocationView.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "ErrorInfoUtility.h"
#import "ZXSearchLocationTableViewCell.h"

@interface ZXSearchLocationView ()
<
UITextFieldDelegate,
AMapSearchDelegate,
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITextField *searchBarTextField;
@property (nonatomic, strong) WGBaseTableView  *tableView;

@property (nonatomic, strong) AMapSearchAPI  *searchApi;
@property (nonatomic, strong) AMapPOIKeywordsSearchRequest  *poiRequest;
@property (nonatomic, strong) NSMutableArray  *searchList;
//当前经纬度
@property(nonatomic,assign) CLLocationCoordinate2D currentCoordinate;

@end


@implementation ZXSearchLocationView

- (instancetype)initWithFrame:(CGRect)frame withCurrentCoordinate:(CLLocationCoordinate2D) currentCoordinate{
    if(self = [super initWithFrame:frame]){
        
        self.currentCoordinate = currentCoordinate;
        
        [self zx_initializationUI];
        
        //地图搜索
        [self zx_setAMapSearchAPI];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

#pragma mark - Initialization
//初始化UI
- (void)zx_initializationUI{
    

    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0,0, WGNumScreenWidth(), kNavBarHeight)];
    titleView.backgroundColor = UIColor.whiteColor;
    
    //进入编辑状态
//    [self.searchBarTextField becomeFirstResponder];
    [titleView addSubview:self.searchBarTextField];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.titleLabel.font = kFontBold(16);
    cancelButton.frame = CGRectMake(titleView.frame.size.width - 60, kNavBarHeight - 37, 60, 32);
    [cancelButton setTitleColor:WGGrayColor(102) forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.clipsToBounds = YES;
    [cancelButton addTarget:self action:@selector(zx_back:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:cancelButton];
    
    [self addSubview:titleView];
    
    
    //TableView
    CGFloat H = titleView.mj_h;
    self.tableView.frame = CGRectMake(0, H, WGNumScreenWidth(), WGNumScreenHeight() - H);
    [self addSubview:self.tableView];
}


#pragma mark - AMapSearchAPI Lazy
- (void)zx_setAMapSearchAPI{
    if (!self.searchApi){
        self.searchApi = [[AMapSearchAPI alloc] init];
        self.searchApi.delegate = self;
        
        AMapPOIAroundSearchRequest *request  = [[AMapPOIAroundSearchRequest alloc] init];
        request.location                     = [AMapGeoPoint locationWithLatitude:self.currentCoordinate.latitude longitude:self.currentCoordinate.longitude];
        [self.searchApi AMapPOIAroundSearch:request];
        
        
        self.poiRequest = [[AMapPOIKeywordsSearchRequest alloc] init];
        /* 城市限制. */
        self.poiRequest.cityLimit           = YES;
        self.poiRequest.requireSubPOIs      = YES;
        /* 按照距离排序. */
        self.poiRequest.sortrule            = 0;
        self.poiRequest.requireExtension    = YES;
        self.poiRequest.types               = @"";
        
    }
}



#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    
    NSLog(@"Error: %@ - %@", error, [ErrorInfoUtility errorDescriptionWithCode:error.code]);
    [WGUIManager wg_hideHUDWithText:@"搜索错误"];
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0){
        self.tableView.hidden = YES;
        [WGUIManager wg_hideHUDWithText:@"搜索结果为空"];
        return;
    }
    
    self.tableView.hidden = NO;
    
    AMapPOI *obj = [[AMapPOI alloc] init];
    obj.uid = @"不显示地点";
    obj.name = @"不显示地点";
    obj.type = @"0";
    
    
    self.searchList = [NSMutableArray arrayWithObjects:obj, nil];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        if (idx == 0){
            self.poiRequest.city = obj.city;
        }
       
        
        [self.searchList wg_safeAddObject:obj];
        
    }];
    
    [self.tableView reloadData];
    
    [WGUIManager wg_hideHUD];
}

#pragma mark - Private Method
//返回
- (void)zx_back:(UIButton *)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(zx_closeSearchLocationView:)]){
        [self.delegate zx_closeSearchLocationView:self];
    }
}

// UITextField 改变搜索
- (void)zx_textFieldEditingChanged:(UITextField *)textField{
    
    // 键盘输入模式
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {
        // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行搜索
        if (!position) {
            
            [self zx_search];
           
        }
        // 有高亮选择的字符串，则暂不对文字进行搜索
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        
    }

}

//搜索内容方法
- (void)zx_search{
    [WGUIManager wg_showHUD];
    self.poiRequest.keywords = self.searchBarTextField.text;
    if (self.searchBarTextField.text.length != 0){
        [self.searchApi AMapPOIKeywordsSearch:self.poiRequest];
    }else{
        AMapPOIAroundSearchRequest *request  = [[AMapPOIAroundSearchRequest alloc] init];
        request.location                     = [AMapGeoPoint locationWithLatitude:self.currentCoordinate.latitude longitude:self.currentCoordinate.longitude];
        [self.searchApi AMapPOIAroundSearch:request];
        
    }
}


#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self zx_search];
    return  YES;
}


#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AMapPOI *mapPOI = [self.searchList wg_safeObjectAtIndex:indexPath.row];
    
    ZXSearchLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZXSearchLocationTableViewCell wg_cellIdentifier]];
    
    [cell zx_setAMapPOI:mapPOI];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 61;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AMapPOI *mapPOI = [self.searchList wg_safeObjectAtIndex:indexPath.row];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(zx_selectSearchLocationView:AMapPOI:)]){
        [self.delegate zx_selectSearchLocationView:self AMapPOI:mapPOI];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

#pragma mark - layz
- (UITextField *)searchBarTextField{

    if(!_searchBarTextField){
        
        _searchBarTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, kNavBarHeight - 37, WGNumScreenWidth() -70 - 16, 32)];
        _searchBarTextField.tintColor = UIColor.blackColor;
        _searchBarTextField.backgroundColor =  WGGrayColor(239);
        _searchBarTextField.layer.cornerRadius = 16;
        _searchBarTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 搜索地点" attributes:@{NSForegroundColorAttributeName: WGGrayColor(153),NSFontAttributeName:kFontMedium(14)}];
        
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _searchBarTextField.frame.size.height, _searchBarTextField.frame.size.height)];
        UIImageView * searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 18, 18)];
        searchImageView.image = IMAGENAMED(@"search");
        searchImageView.contentMode = UIViewContentModeScaleAspectFit;
        [leftView addSubview:searchImageView];
        _searchBarTextField.leftView = leftView;
        
        _searchBarTextField.leftViewMode = UITextFieldViewModeAlways;
        _searchBarTextField.rightViewMode = UITextFieldViewModeAlways;
        _searchBarTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchBarTextField.clipsToBounds = YES;
        _searchBarTextField.textColor = [UIColor blackColor];
        _searchBarTextField.delegate = self;
        _searchBarTextField.returnKeyType = UIReturnKeySearch;
        _searchBarTextField.font = kFontMedium(15);
        
        _searchBarTextField.delegate = self;
        
        [_searchBarTextField addTarget:self action:@selector(zx_textFieldEditingChanged:) forControlEvents:(UIControlEventEditingChanged)];
       
    }
    return _searchBarTextField;
}

- (WGBaseTableView *)tableView{
    if (!_tableView){
        _tableView = [[WGBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = WGGrayColor(239);
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        [_tableView registerClass:[ZXSearchLocationTableViewCell class] forCellReuseIdentifier:[ZXSearchLocationTableViewCell wg_cellIdentifier]];
    

    }
    return _tableView;
}
@end
