//
//  YDImagePicker.m
//  FitnewAPP
//
//  Created by Yudong on 2016/11/7.
//  Copyright © 2016年 xida. All rights reserved.
//

#import "YDImagePicker.h"

#import "MSSheetView.h"

@interface YDImagePicker()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, copy) YDImagePickerFinishAction finishAction;
@property (nonatomic, assign) BOOL allowsEditing;

@end


static YDImagePicker *bdImagePickerInstance = nil;

@implementation YDImagePicker

+ (void)showImagePickerFromViewController:(UIViewController *)viewController allowsEditing:(BOOL)allowsEditing finishAction:(YDImagePickerFinishAction)finishAction {
    if (bdImagePickerInstance == nil) {
        bdImagePickerInstance = [[YDImagePicker alloc] init];
    }
    
    [bdImagePickerInstance showImagePickerFromViewController:viewController
                                               allowsEditing:allowsEditing
                                                finishAction:finishAction];
}

- (void)showImagePickerFromViewController:(UIViewController *)viewController
                            allowsEditing:(BOOL)allowsEditing
                             finishAction:(YDImagePickerFinishAction)finishAction {
    _viewController = viewController;
    _finishAction = finishAction;
    _allowsEditing = allowsEditing;
    
    UIAlertController *alertController = nil;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        
        MSSheetAction *sheetAction = [[MSSheetAction alloc] init];
        [sheetAction initLeftImage:nil andContent:NSLocalizedString(@"paizhao", nil) andRightImage:nil];
        [sheetAction setBtnClickBlock:^(){
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing = NO;
            picker.modalPresentationStyle  = UIModalPresentationFullScreen;
            [_viewController presentViewController:picker animated:YES completion:nil];
            
        }];
        
        
        MSSheetAction *sheetAction1 = [[MSSheetAction alloc] init];
        [sheetAction1 initLeftImage:nil andContent:NSLocalizedString(@"chongxiangcezhongxuanz", nil) andRightImage:nil];
        [sheetAction1 setBtnClickBlock:^(){
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = allowsEditing;
            picker.modalPresentationStyle  = UIModalPresentationFullScreen;
            [_viewController presentViewController:picker animated:YES completion:nil];
            
        }];
        
        
        MSSheetView *sheetView = [MSSheetView sharedView];
        sheetView.title = NSLocalizedString(@"xuanzhetupian", nil);
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:sheetView];
        
        [sheetView addSheetAction:sheetAction];
        [sheetView addSheetAction:sheetAction1];
        
        [sheetView show];
        
        
    } else {
        
        MSSheetAction *sheetAction1 = [[MSSheetAction alloc] init];
        [sheetAction1 initLeftImage:nil andContent:NSLocalizedString(@"chongxiangcezhongxuanz", nil) andRightImage:nil];
        [sheetAction1 setBtnClickBlock:^(){
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = allowsEditing;
            picker.modalPresentationStyle  = UIModalPresentationFullScreen;
            [_viewController presentViewController:picker animated:YES completion:nil];
            
        }];
        
        
        MSSheetView *sheetView = [MSSheetView sharedView];
        sheetView.title = NSLocalizedString(@"xuanzhetupian", nil);
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:sheetView];
        
        [sheetView addSheetAction:sheetAction1];
        
        [sheetView show];
    }
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (image == nil) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    if (_finishAction) {
        _finishAction(image);
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    bdImagePickerInstance = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (_finishAction) {
        _finishAction(nil);
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    bdImagePickerInstance = nil;
}

@end
