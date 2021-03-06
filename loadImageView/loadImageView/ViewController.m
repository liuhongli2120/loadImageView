//
//  ViewController.m
//  loadImageView
//
//  Created by 刘宏立 on 16/9/25.
//  Copyright © 2016年 lhl. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <YYModel.h>
#import <UIImageView+WebCache.h>
#import "HLAppInfo.h"
#import "HLAppCell.h"


static NSString *cellId = @"cellId";

@interface ViewController () <UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSArray <HLAppInfo *> *appList;

@end

@implementation ViewController {
    NSOperationQueue *_downloadQueue;
}
- (void)loadView {
    _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    _tableview.dataSource = self;
//    [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    
    [_tableview registerNib:[UINib nibWithNibName:@"HLAppCell" bundle:nil] forCellReuseIdentifier:cellId];
    
    self.view = _tableview;
    _tableview.rowHeight = 100;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _downloadQueue = [[NSOperationQueue alloc]init];
    
    [self loadData];
}

#pragma mark - 实现协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _appList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HLAppCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.textLabel.text = _appList[indexPath.row].name;
    
    
    HLAppInfo *model = [[HLAppInfo alloc]init];
    
    
    if (model.image != nil) {
        cell.iconView.image = model.image;
    } else {
        UIImage *placeholder = [UIImage imageNamed:@"user_default"];
        cell.iconView.image = placeholder;
        
        NSURL *url = [NSURL URLWithString:_appList[indexPath.row].icon];
        
        NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"download %@ image", _appList[indexPath.row].name);
            
            [NSThread sleepForTimeInterval:1.0];
            
            
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            model.image = image;
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                cell.iconView.image = image;
            }];
            
        }];
        
        [_downloadQueue addOperation:op];
        
    }
    
//    [cell.imageView sd_setImageWithURL:url];
    
    return cell;
}

- (void)loadData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置响应的支持的数据类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    [manager GET:@"https://raw.githubusercontent.com/liufan1000/demo/master/apps.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSDictionary *dict in responseObject) {
            HLAppInfo *model = [[HLAppInfo alloc]init];
            
            
            [model setValuesForKeysWithDictionary:dict];
            
            [arrayM addObject:model];
        }
        self.appList = arrayM.copy;
        [self.tableview reloadData];
        
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络请求失败 %@", error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
