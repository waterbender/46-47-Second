//
//  AuthorizationViewController.m
//  46-47 Client API
//
//  Created by  ZHEKA on 30.07.15.
//  Copyright (c) 2015 Pasko Eugene. All rights reserved.
//

#import "AuthorizationViewController.h"

@interface AuthorizationViewController () <UIWebViewDelegate>

@property (copy, nonatomic) BlockToken blockToken;
@property (strong, nonatomic) UIWebView *webView;

@end

@implementation AuthorizationViewController


- (instancetype)initWithBlock : (BlockToken) tokenBlock {

    self = [super init];
    
    if (self) {
        
        self.blockToken = tokenBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect = self.view.frame;
    
    rect.origin = CGPointZero;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:rect];
    
    self.webView = webView;
    
    webView.delegate = self;
    
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    NSString *urlString = @"https://oauth.vk.com/authorize?"
    "client_id=5011482&"
    "redirect_uri=https://oauth.vk.com/blank.html&"
    "display=mobile&"
    "scope=139286&" //1989787
    "response_type=token&"
    "v=5.35";
    
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
    
    self.navigationItem.title = @"Login";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelView:)];
    
    self.navigationItem.rightBarButtonItem = item;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mar - Actions

- (void) cancelView :  (UIBarButtonItem*) item {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    AccessToken *token = [[AccessToken alloc] init];
    
    if ([[[request URL] description] rangeOfString:@"access_token"].location != NSNotFound) {
        
        NSString *query = [[request URL] description];
        NSArray *array = [query componentsSeparatedByString:@"#"];
        
        if ([array count] > 1) {
            
            query = [array lastObject];
        }
        
        NSArray *pairs = [query componentsSeparatedByString:@"&"];
        
        for (NSString *pair in pairs) {
            
            NSArray *values = [pair componentsSeparatedByString:@"="];
            
            if ([values count] == 2) {
                
                NSString *key = [values firstObject];
                
                if ([key isEqualToString:@"access_token"]) {
                    
                    token.token = [values lastObject];
                } else if ([key isEqualToString:@"expires_in"]) {
                    
                    double expires = [[values lastObject] doubleValue];
                    token.expires = [NSDate dateWithTimeIntervalSinceNow:expires];
                } else if ([key isEqualToString:@"user_id"]) {
                    
                    token.id = [values lastObject];
                }
                
            }
        }
        
        self.webView.delegate = nil;
        
        if (self.blockToken) {
            self.blockToken(token);
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        return NO;
    }
    

    NSLog(@"%@", request);
    
    
    return YES;
}

@end
