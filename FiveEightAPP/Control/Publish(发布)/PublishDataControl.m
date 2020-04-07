//
//  PublishDataControl.m
//  FiveEightAPP
//
//  Created by Mac on 2020/3/27.
//  Copyright © 2020 DianHao. All rights reserved.
//

#import "PublishDataControl.h"
#import "GMDCircleLoader.h"

@implementation PublishDataControl
///获取子栏目数据
-(void)getLanMuSonData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back
{
    if(view)
    {
        [GMDCircleLoader setOnView:view withTitle:nil animated:YES];
    }
    HttpManager *httpm = [HttpManager createHttpManager];
    
    [httpm getRequetInterfaceData:dicpush withInterfaceName:@"frontend.channel/sonchannel" andresponseHandler:^(NSURLSessionDataTask *opration, id responceObjct, NSError *error) {
       if(view)
       {
           [GMDCircleLoader hideFromView:view animated:YES];
       }
        BOOL state = NO;
       NSString *describle = @"";
       if (responceObjct==nil) {
           describle = NSLocalizedString(@"networkCancle", nil);
       }else{
           NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
           NSDictionary *dicAll=[str JSONValue];
           describle = dicAll[@"msg"];
           if ([[NSString nullToString:dicAll[@"code"]] intValue] == 1) {
               self->_arrlanmuSon = [dicAll objectForKey:@"data"];
               state = YES;
           }
       }
       back(error,state,describle);
    }];
    
}

///上传图片
-(void)pushImageData:(NSDictionary *)dicpush andimage:(UIImage *)image andshowView:(UIView *)view Callback:(completItemback)back
{
    //URL组拼
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", METHOD_URLSTR, @"frontend.common/upload"];
    NSURL *URL = [NSURL URLWithString:urlStr];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //添加可接受数据类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    if ([User sharedUser].token.length>0) {
        [manager.requestSerializer setValue:[User sharedUser].token forHTTPHeaderField:@"user-token"];
    }
    [manager.requestSerializer setValue:@"v1" forHTTPHeaderField:@"version"];
    [manager.requestSerializer setValue:[Util getUDID] forHTTPHeaderField:@"deviceid"];
    [manager.requestSerializer setValue:[User sharedUser].access_token forHTTPHeaderField:@"access-token"];
    
    //上传图片/文字，只能同POST
    [manager POST:URL.absoluteString parameters:dicpush constructingBodyWithBlock:^(id _Nonnull formData) {
        
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        
        //            NSData *data = UIImagePNGRepresentation(asset.photo);
        //第一个代表文件转换后data数据，第二个代表图片的名字，第三个代表图片放入文件夹的名字，第四个代表文件的类型
        [formData appendPartWithFileData:data name:@"file" fileName:@"file.jpg" mimeType:@"image/jpg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        ResponseData *rd = [ResponseData mj_objectWithKeyValues:responseObject];
        
        if (rd.data) {
            
            back(nil,YES,[rd.data objectForKey:@"url"]);
            }
        else
        {
            back(nil,NO,@"上传失败");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        back(error,NO,@"上传失败");
        
    }];
    
}

///发布
-(void)pushData:(NSDictionary *)dicpush andshowView:(UIView *)view Callback:(completItemback)back
{
    if(view)
    {
        [GMDCircleLoader setOnView:view withTitle:nil animated:YES];
    }
    HttpManager *httpm = [HttpManager createHttpManager];
    
    [httpm postRequetInterfaceData:dicpush withInterfaceName:@"frontend.article/publish" andresponseHandler:^(NSURLSessionDataTask *opration, id responceObjct, NSError *error) {
       if(view)
       {
           [GMDCircleLoader hideFromView:view animated:YES];
       }
        BOOL state = NO;
       NSString *describle = @"";
       if (responceObjct==nil) {
           describle = NSLocalizedString(@"networkCancle", nil);
       }else{
           NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
           NSDictionary *dicAll=[str JSONValue];
           describle = dicAll[@"msg"];
           if ([[NSString nullToString:dicAll[@"code"]] intValue] == 1) {
               state = YES;
           }
       }
       back(error,state,describle);
    }];
    
}


@end
