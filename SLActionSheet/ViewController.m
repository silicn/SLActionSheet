//
//  ViewController.m
//  SLActionSheet
//
//  Created by jiahao on 15/11/2.
//  Copyright © 2015年 silicn. All rights reserved.
//

#import "ViewController.h"

#import "SLActionSheet.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor = [UIColor orangeColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:@"iphone.jpg"];
    [self.view insertSubview:imageView atIndex:0];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)click:(UIButton *)sender {
    SLActionSheet *sheet = [[SLActionSheet alloc]initWithTitle:@"提示" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册",@"其他",nil];
       [sheet showInView:self.view];
//    sheet.destructiveButtonIndex = 1;
//    sheet.cancelColor = [UIColor blueColor];


}


- (IBAction)sheetClick:(UIButton *)sender {
    
//    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"提示" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
//    
//    [sheet showInView:self.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
