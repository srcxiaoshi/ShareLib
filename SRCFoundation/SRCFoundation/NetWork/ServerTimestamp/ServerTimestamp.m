//
//  GetNetwork.m
//  SRCFoundation
//
//  Created by 史瑞昌 on 2018/9/10.
//  Copyright © 2018年 史瑞昌. All rights reserved.
//

#import "ServerTimestamp.h"
#import "SRCNetworkWithAF.h"
#import "AppInfo.h"
#import "UIDevice+Hardware.h"
#import "UIDevice+Software.h"
#import "NSMutableString+Safe.h"
#import "NSMutableDictionary+Safe.h"
#import "NSString+Safe.h"
#import "BaseModel.h"

#import "SRCNetworkWithAF.h"

@implementation ServerTimestamp

+(void)getServerTimestamp:(ServerTimestampBlock) block
{
    //构造请求包 这里测试用 这里是头条的URL
    //https://is.snssdk.com/network/get_network/?version_code=6.8.8&tma_jssdk_version=1.1.0.10&app_name=news_article&vid=C68FFB74-9684-4105-9E8C-4954D6022577&device_id=47982195078&channel=App%20Store&resolution=1125*2436&aid=13&ab_version=425531,482423,492612,486950,452158,480751,494120,467892,494152,488820,239097,478798,170988,493249,405356,480871,480610,374119,437000,478529,434624,489317,443148,494128,276205,471720,491311,459645,459993,277770,469537,416055,470630,456488,444653,490552,378450,471406,489423,494124,493908,271178,424178,326524,326532,488147,494966,494280,493825,345191,491700,493461,489827,489968,424606,455646,449327,424176,493596,214069,31245,489331,442255,493747,466936,481984,489511,280447,281291,492476,478591,325611,495162,492470,481568,295308,487448,495353,386888,491935,397990,467515,466888,494011,444464,495208,493925,304488,261580,457480,488925,487522,491262,492520&ab_feature=201616,z2&ab_group=z2,201616&update_version_code=68824&openudid=7c9b9a6b7abcbe4e79054ee4521e172ca5828555&idfv=C68FFB74-9684-4105-9E8C-4954D6022577&ac=WIFI&os_version=11.4.1&ssmix=a&device_platform=iphone&iid=43721270080&ab_client=a1,f2,f7,e1&device_type=iPhone%20X&idfa=B4E58BEB-9B3D-4993-A66F-54D0E949ECF1&as=a2c5cdc95d3d3b4d444433&ts=1536482781
    //
    NSMutableDictionary *dic=[NSMutableDictionary new];
    [dic safe_setObject:[AppInfo app_version] forKey:@"version_code"];
    [dic safe_setObject:[AppInfo app_build] forKey:@"tma_jssdk_version"];
    [dic safe_setObject:[AppInfo app_name] forKey:@"app_name"];
    [dic safe_setObject:[UIDevice deviceUUID] forKey:@"vid"];
    [dic safe_setObject:@"47982195078" forKey:@"device_id"];
    [dic safe_setObject:@"App Store" forKey:@"channel"];//下载渠道
    //NSString *resolution=@"";//1125*2436//分辨率 小*大
    [UIDevice resolutionRatio:^(float big, float little) {
        [dic safe_setObject:[NSString stringWithFormat:@"%f*%f",little,big] forKey:@"resolution"];
    }];
    [dic safe_setObject:@"13" forKey:@"aid"];
    //广告类的参数先不加
//    ab_version=425531,482423,492612,486950,452158,480751,494120,467892,239097,478798,170988,493249,405356,480871,480610,374119,437000,478529,434624,489317,443148,494128,276205,471720,491311,459645,459993,277770,495882,469537,416055,470630,456488,444653,490552,378450,471406,494124,493908,271178,424178,326524,326532,488147,494966,496174,493825,345191,491700,493461,489827,424606,455646,449327,424176,493596,214069,31245,489331,442255,493747,466936,495714,481984,489511,280447,281291,478591,325611,495162,492470,481568,295308,487448,495700,386888,491935,397990,467515,466888,495626,444464,495208,493925,304488,261580,457480,488925,487522,491262,492520
//    ab_feature=201616,z2
//    ab_group=z2,201616
    
    [dic safe_setObject:@"68824" forKey:@"update_version_code"];
    //[dic safe_setObject:[OpenUDID value] forKey:@"openudid"];//7c9b9a6b7abcbe4e79054ee4521e172ca5828555
    [dic safe_setObject:@"C68FFB74-9684-4105-9E8C-4954D6022577" forKey:@"idfv"];
    [dic safe_setObject:[SRCNetworkWithAF reachAbilityString] forKey:@"ac"];//WIFI
    [dic safe_setObject:[UIDevice deviceSystemVersion] forKey:@"os_version"];//11.4.1
//    ssmix=a
    [dic safe_setObject:[UIDevice devicePlatform] forKey:@"device_platform"];//iPhone
    [dic safe_setObject:@"43721270080" forKey:@"iid"];
//    ab_client=a1,f2,f7,e1
    [dic safe_setObject:[UIDevice deviceModel] forKey:@"device_type"];
    
    
    [dic safe_setObject:@"B4E58BEB-9B3D-4993-A66F-54D0E949ECF1" forKey:@"idfa"];
    [dic safe_setObject:@"a2856219a9b65ba3a72518" forKey:@"as"];
    long recordTime = (long)[[NSDate date] timeIntervalSince1970]*1000;
    [dic safe_setObject:[NSString stringWithFormat:@"%ld",recordTime] forKey:@"ts"];//这里是时间戳

    
    [SRCNetworkWithAF requestGetMethodWithPath:@"https://is.snssdk.com/network/get_network/" parameters:[dic copy] withProgress:nil success:^(BOOL isSuccess, NSString *response) {
        //是不是要重传，由外面用户决定
        if(block)
        {
            __autoreleasing JSONModelError *err=nil;
            BaseModel *basemodel=[[BaseModel alloc]safe_initWithString:response error:&err];
            if(err)
            {
                block(isSuccess,nil);
                return;
            }
            else
            {
                block(isSuccess,basemodel);
            }
            
        }
    } failure:^(NSError *error) {
        //是不是要重传，由外面用户决定
        if(block)
        {
            block(NO,nil);
        }
        return;
    }];
}











@end
