//
//  ZXNavViewController.m
//  ZXHY
//
//  Created by Bern Lin on 2022/4/7.
//

/*
 增加新插件的方法
 1.如果需要有视图的，先在ZXNavViewController的setupSubView里增加对应的视图容器
 
 2.在RoomManager文件夹里面新增插件文件夹（如LivePlugin），并增加插件的类（XXXPlugin）,该插件类需要继承WGRoomBasePlugin，如果需要提供方法给别人调用的话，需要在WGRoomPluginProtocol头文件定义属于该插件的协议，并在WGRoomPluginManagerProtocol协议里添加获取该插件的方法，具体的方法实现在该插件的.m文件实现
 
 3.在WGRoomPluginManager的setupPlugin里面增加插件
 
 细化:
 (1).在ZXNavViewController的setupSubView里增加对应的视图容器
 (2).在RoomManager文件夹里面新增插件文件夹（如LivePlugin)
 (3).在文件夹中添加插件的类（XXXPlugin),注: 该插件类需要继承WGRoomBasePlugin
 (4).如果需要提供方法给别人调用的话，需要:
     1.在WGRoomPluginProtocol头文件定义属于该插件的协议
     2.具体的方法实现在该插件的.m文件实现
 (5).在WGRoomPluginManager的setupPlugin里面增加插件

 

 
 细化:
 (1)ZXNavViewController的功能比较简单，初始化各个插件的试图容器，初始化插件管理器，属于ZXNavViewController的一些交互事件
 (2).插件与插件之间的调用，只能通过WGRoomPluginProtocol里面的方法去实现，或者用通知的方式去实现
 (3)每个插件都继承自WGRoomBasePlugin，里面都有liveController（当前控制器，可通过这个vc来获取对应的view容器）和pluginManager（插件管理器）属性，基本可以满足全部的需求
 (4).setupProperty方法（这个方法调用的时候，确保liveController和pluginManager有值
 (5).liveController和pluginManager都是weak的，可以预防循环引用
 (6)插件相当于一个模块的管理器，属于该模块的功能都要在插件里面实现，不要怕麻烦，等功能越来越多的时候，你会庆幸之前的归类
 
 */


#import "ZXNavViewController.h"
#import "ZXNavViewController+TravelManner.h"

@interface ZXNavViewController ()

//数据
//@property (nonatomic, strong) ZXOpenResultsModel *openResultsModel;
//@property (nonatomic, strong) ZXBlindBoxViewParentlistModel *parentlistModel;


@end

@implementation ZXNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}



#pragma mark - Private Method

//传入数据开始导航
- (void)zx_enterNavControllerWithResultsModel:(ZXOpenResultsModel *)openResultsModel ParentlistModel:(ZXBlindBoxViewParentlistModel *)parentlistModel{
    
    self.openResultsModel = openResultsModel;
    self.parentlistModel = parentlistModel;

    //计算道路并出行
    [self zx_calculateRouteWithPlanrWithResultsModel:openResultsModel ParentlistModel:parentlistModel];

}

//关闭导航页面
- (void)zx_dismissNavViewController{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
