//
//  ViewController.m
//  TestWebviewEditor
//
//  Created by  joy on 2020/9/16.
//  Copyright © 2020  joy. All rights reserved.
//

#import "ViewController.h"
#import "TTTWebview.h"

@interface ViewController ()

@property (nonatomic) TTTWebview *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[TTTWebview alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
}


@end
