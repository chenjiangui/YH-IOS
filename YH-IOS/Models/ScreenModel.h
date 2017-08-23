//
//  ScreenModel.h
//  YH-IOS
//
//  Created by cjg on 2017/8/3.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "BaseModel.h"

@class AddressModel;

@interface ScreenModel : BaseModel
@property (nonatomic, strong) NSArray<ScreenModel*>* data;
@property (nonatomic, strong) AddressModel* current_location;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* category;
@property (nonatomic, strong) NSString* rank_index;
@property (nonatomic, strong) NSString* server_param;
@property (nonatomic, strong) ScreenModel* items;
@property (nonatomic, strong) NSString* identifier;


@end

@interface AddressModel : BaseModel

@property (nonatomic, strong) NSString* display;
@property (nonatomic, strong) NSString* district_id;
@property (nonatomic, strong) NSString* district_name;
@property (nonatomic, strong) NSString* area_id;
@property (nonatomic, strong) NSString* area_name;
@property (nonatomic, strong) NSString* store_id;
@property (nonatomic, strong) NSString* store_name;

@end
