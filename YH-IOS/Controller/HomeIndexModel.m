//
//  HomeIndexModel.m
//  SwiftCharts
//
//  Created by CJG on 17/4/6.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "HomeIndexModel.h"
#import "HttpUtils.h"
#import "HttpResponse.h"
#import "User.h"
#import "FileUtils.h"

@interface HomeIndexModel ()

@end

@implementation HomeIndexModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"products":@"HomeIndexItemModel"
             };
}

+ (NSArray*)homeIndexModelWithJson:(id)json withUrl:(NSString *)urlString{
    // 暂时写死json
    NSString *newjson;
    User* user = [[User alloc]init];
    NSString *jsonURL;
    NSString *baseString;
    if ([urlString hasPrefix:@"http"]) {
        baseString = [NSString stringWithFormat:urlString, SafeText(user.groupID)];
        jsonURL = [NSString stringWithFormat:@"%@",baseString];
    }
    else{
        NSArray *urlArray = [urlString componentsSeparatedByString:@"/"];
         baseString = [NSString stringWithFormat:@"/api/v1/group/%@/template/%@/report/%@/json",SafeText(user.groupID),urlArray[6],urlArray[8]];
         jsonURL = [NSString stringWithFormat:@"%@%@",kBaseUrl,baseString];
        
    }
    NSString *javascriptPath = [[FileUtils userspace] stringByAppendingPathComponent:@"HTML"];
    NSString*fileName =  [HttpUtils urlTofilename:baseString suffix:@".json"][0];
    javascriptPath = [javascriptPath stringByAppendingPathComponent:fileName];
    NSMutableArray *models;
    
    if ([HttpUtils isNetworkAvailable3]) {
         HttpResponse *reponse = [HttpUtils httpGet:jsonURL];
        if (fileName.length>0) {
            if ([FileUtils checkFileExist:javascriptPath isDir:NO]) {
                [FileUtils removeFile:javascriptPath];
            }
        }
        newjson = reponse.string;
        BOOL isYes = [NSJSONSerialization isValidJSONObject:reponse.data];
        if (isYes) {
            models = [HomeIndexModel mj_objectArrayWithKeyValuesArray:newjson];
        }
        else{
            models = [[NSMutableArray alloc]init];
        }
        [reponse.string writeToFile:javascriptPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    else{
        newjson = [NSString stringWithContentsOfFile:javascriptPath encoding:NSUTF8StringEncoding error:nil];
         models = [HomeIndexModel mj_objectArrayWithKeyValuesArray:newjson];
    }
    
    return models;
}


@end
