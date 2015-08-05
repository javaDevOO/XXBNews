//
//  ViewController.m
//  XXBNews
//
//  Created by xuxubin on 15/8/5.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property (nonatomic, strong) REMenu *menu;
@property (nonatomic, strong) UIWebView *webView;

@end

#define baiduNewUrl @"http://news.baidu.com"
#define fengNewUrl @"http://3g.ifeng.com"
#define sinaNewUrl @"http://news.sina.cn"
#define tencenNewUrl @"http://info.3g.qq.com"
#define wangyiNewUrl @"http://3g.163.com"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"More" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectMoreView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationController.title = @"新闻";
    
    // 设置menuview
    [self setupMenuView];
    
    // 添加webview
    [self setupWebview];
    
    // 加载网页
    [self loadWebViewUrl:baiduNewUrl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) selectMoreView
{
    if (self.menu.isOpen)
        return [self.menu close];
    
    [self.menu showFromNavigationController:self.navigationController];

}

- (void) setupMenuView
{
    REMenuItem *baiduItem = [[REMenuItem alloc] initWithTitle:@"百度新闻"
                                                     subtitle:@"全球最大的中文新闻平台"
                                                        image:nil
                                             highlightedImage:nil
                                                       action:^(REMenuItem *item) {
                                                           [self loadWebViewUrl:baiduNewUrl];
                                                       }];
    REMenuItem *fengItem = [[REMenuItem alloc] initWithTitle:@"凤凰新闻"
                                                    subtitle:@"24小时提供最及时，最权威，最客观的新闻资讯"
                                                       image:nil
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          [self loadWebViewUrl:fengNewUrl];
                                                      }];
    REMenuItem *sinaItem = [[REMenuItem alloc] initWithTitle:@"新浪新闻"
                                                    subtitle:@"最新，最快头条新闻一网打尽"
                                                       image:nil
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          [self loadWebViewUrl:sinaNewUrl];
                                                      }];
    REMenuItem *tencenItem = [[REMenuItem alloc] initWithTitle:@"腾讯新闻"
                                                      subtitle:@"中国浏览最大的中文门户网站"
                                                         image:nil
                                              highlightedImage:nil
                                                        action:^(REMenuItem *item) {
                                                            [self loadWebViewUrl:tencenNewUrl];
                                                        }];
    REMenuItem *wangyiItem = [[REMenuItem alloc] initWithTitle:@"网易新闻"
                                                      subtitle:@"因新闻最快速，评论最犀利而备受推崇"
                                                         image:nil
                                              highlightedImage:nil
                                                        action:^(REMenuItem *item) {
                                                            [self loadWebViewUrl:wangyiNewUrl];
                                                        }];
    self.menu = [[REMenu alloc] initWithItems:@[fengItem, baiduItem, sinaItem, tencenItem, wangyiItem]];
    self.menu.liveBlur = YES;
    self.menu.liveBlurBackgroundStyle = REMenuLiveBackgroundStyleDark;
    self.menu.textColor = [UIColor whiteColor];
    self.menu.subtitleTextColor = [UIColor whiteColor];
}

- (void) setupWebview
{
    UIWebView *webView = [[UIWebView alloc]init];
    webView.frame = self.view.bounds;
    [self.view addSubview:webView];
    self.webView = webView;
    self.webView.delegate = self;
}

- (void)loadWebViewUrl:(NSString *)strUrl
{
    NSURL *url = [NSURL URLWithString:strUrl];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
}

- (void)dealloc
{
    // 释放webview内存
    [self.webView loadHTMLString:@"" baseURL:nil];
    [self.webView stopLoading];
    self.webView.delegate = nil;
    [self.webView removeFromSuperview];
    self.webView = nil;
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSLog(@"KLNewsViewController dealloc");
}

@end
