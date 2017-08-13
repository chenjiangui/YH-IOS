//
//  ToolModel.h
//  YH-IOS
//
//  Created by cjg on 2017/7/28.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "BaseModel.h"

@interface ToolModel : BaseModel

@property (nonatomic, strong) NSArray<ToolModel*>* data;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* category;
@property (nonatomic, strong) NSString* group_name;
@property (nonatomic, strong) NSString* link_path;
@property (nonatomic, strong) NSString* publicly;
@property (nonatomic, strong) NSString* icon;
@property (nonatomic, strong) NSString* icon_link;
@property (nonatomic, strong) NSString* group_id;
@property (nonatomic, strong) NSString* health_value;
@property (nonatomic, strong) NSString* group_order;
@property (nonatomic, strong) NSString* item_order;
@property (nonatomic, strong) NSString* created_at;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* content;
@property (nonatomic, strong) NSString* report_title;


@end
