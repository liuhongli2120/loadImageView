//
//  HLAppInfo.h
//  loadImageView
//
//  Created by 刘宏立 on 16/9/25.
//  Copyright © 2016年 lhl. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HLAppInfo : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *download;
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,strong)UIImage *image;

@end
