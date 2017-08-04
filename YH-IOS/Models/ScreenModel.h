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

@end

@interface AddressModel : BaseModel

@end
