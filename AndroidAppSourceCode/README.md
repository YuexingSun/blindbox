# 知行盒一Android管理仓库

### 一、架构

1. #### MVVM + Kotlin

2. #### Jetpack

   - 生命周期：Lifecycle、ProcessLifecycle（可以监听App前后台状态切换）
   - ViewModel
   - 观察者：LiveData（后期使用Flow替换）
   - Databinding双向绑定
   - 协程
   - 数据库：Room
   - 应用启动库：StartUp

3. #### 网络请求：Okhttp + Retrofit2

4. #### 屏幕适配：AutoSize

5. #### 其他

   大部分大厂都使用Java11，Gradle和kotlin除了适配Java11之外，也为后期使用Jetpack Compose替换传统的Xml打基础。

   - Gradle：7.0.2
   - kotlin：1.5.21
   - Java版本：Java11

### 二、包目录

1. #### app

   - initializer

     这里用startUp库提高第三方库初始化速度，部分库延迟初始化。

   - repo

     请求接口的实现。

   - service

     请求接口。

   - ui

   - view_model

   - widget

     存放部分工具类和自定义控件。

2. #### autosize

   屏幕适配。

3. #### common

   存放Basic的内容。

   - base

     基础的类，BaseActivity、BaseFragment等等。

   - core

     这里放了个专门发送全局消息的ViewModel。

   - customView

     自定义控件。

   - ext

     扩展函数。

   - listener

     这里存放了一个全局Activity监听管理类。

   - model

   - net

     网络相关。

   - util

     基础包内的工具。

4. #### network

   网络请求部分的内容

### 三、其他记录

1. MainFragment采用BottomNavigation + ViewPage2，为了保证MainFragment onResume的时候ViewPage2页面不重新刷新，所以MainFragment不会出栈，即ViewPage2内的多个页面也不会销毁。这里带来的问题是，ViewPage2内的页面onResume生命周期可能会提前走完，所以**ViewPage2内的页面一般不要在onResume执行操作**，根据MainFragment的生命周期，然后获取到ViewPage2当前选择的页面，通过单例的LiveData去通知ViewPage2当前页面去做某些操作；