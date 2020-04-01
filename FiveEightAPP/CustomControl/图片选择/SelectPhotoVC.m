//
//  SelectPhotoVC.m
//  FitnewAPP
//
//  Created by Yudong on 2016/11/3.
//  Copyright © 2016年 xida. All rights reserved.
//

#import "SelectPhotoVC.h"

#import "JKImagePickerController.h"
#import "ImageCollectionCell.h"

#import "NSString+TimeStamp.h"
#import "UIImage+fixOrientation.h"

#import "ShowImagesController.h"

#define ALOGDebug(...) NSLog(__VA_ARGS__)

@interface SelectPhotoVC ()


@end

@implementation SelectPhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationBarTitle:nil leftImage:nil andRightImage:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPictures:) name:@"REFRESHPICTURES" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionView*)photoView {
    if (!_photoView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumInteritemSpacing = 6.0;
        layout.minimumLineSpacing = 6.0;
        if (DEVICE_Width == 414) {
            layout.minimumInteritemSpacing = 2.0;
            layout.minimumLineSpacing = 2.0;
        }
        
        _photoView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 100, DEVICE_Width-30, 60) collectionViewLayout:layout];
        _photoView.delegate = self;
        _photoView.dataSource = self;
        _photoView.backgroundColor = [UIColor whiteColor];
        _photoView.opaque = NO;
        [self.view addSubview:_photoView];
        
        [_photoView registerClass:[ImageCollectionCell class] forCellWithReuseIdentifier:@"imageCell"];
    }
    return _photoView;
}

- (NSMutableArray *)editArray {
    if (!_editArray) {
        _editArray = [NSMutableArray array];
    }
    return _editArray;
}

- (NSMutableArray *)photoArray {
    
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

- (NSMutableArray *)imageNameArray {
    if (!_imageNameArray) {
        _imageNameArray =[NSMutableArray array];
    }
    return _imageNameArray;
}

// 拍照
- (void)takePhotos {
    
    
    // 判断图片张数
    if (self.photoArray.count >= 9) {
//        [SVProgressHUD showErrorWithStatus:@"最多上传9张图片"];
        return;
    }
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
    NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];//Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
    ipc.mediaTypes = [NSArray arrayWithObject:availableMedia[0]];//设置媒体类型为public.movie
    ipc.modalPresentationStyle  = UIModalPresentationFullScreen;
    [self presentViewController:ipc animated:YES completion:nil];
    ipc.videoMaximumDuration = 60.0f;//60秒
    ipc.delegate = self;//设置委托
}

// 图片
- (void)selectPhoto
{
    NSInteger m = 0;
    for (id obj in self.photoArray) {
        if ([obj isKindOfClass:[UIImage class]] && !self.videoData) {  // 拍的照片
            m++;
        }
    }
    
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = NO;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 9-m;
    if (self.photoArray.count <= 0) {
        imagePickerController.selectedAssetArray = nil;
    } else {
        NSMutableArray *mutArr = [NSMutableArray array];
        for (id obj in self.photoArray) {
            if ([obj isKindOfClass:[JKAssets class]]) {
                [mutArr addObject:obj];
            }
        }
        if (mutArr.count == 0) {
            imagePickerController.selectedAssetArray = nil;
        } else {
            imagePickerController.selectedAssetArray = mutArr;
        }
    }
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    navigationController.modalPresentationStyle  = UIModalPresentationFullScreen;
    [self presentViewController:navigationController animated:YES completion:NULL];
}

// 视频
- (void)takeVideos {
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
    //Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
    ipc.mediaTypes = [NSArray arrayWithObject:@"public.movie"];//设置媒体类型为public.movie
    ipc.modalPresentationStyle  = UIModalPresentationFullScreen;
    [self presentViewController:ipc animated:YES completion:nil];
    ipc.videoMaximumDuration = 60.0f;//60秒
    ipc.delegate = self;//设置委托
}


- (NSString *)getDocumentDirectory {
    NSString * documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * path = [documentsDirectory stringByAppendingPathComponent:@"MSImage/"];
    return path;
}

#pragma mark - ===================== JKImagePickerControllerDelegate =====================

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker {
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source {
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    
    // 动态计算collectionView的高度
    NSInteger n = 1;  // 行
    NSInteger m = 0;  // 余数
    NSUInteger count = [assets count];
    if (DEVICE_Width == 320) {
        n = count/4;
        m = count%4;
    }
    else if (DEVICE_Width == 375) {  // 6/6s
        n = count/5;
        m = count%5;
    }
    else if (DEVICE_Width == 414) { // 6+/6s+
        n = count/6;
        m = count%6;
    }
    
    if (m > 0) {
        n++;
    }
    
    CGRect rect = self.photoView.frame;
    rect.size.height = 60 + (n-1)*(60 + 6/*行间距*/);
    self.photoView.frame = rect;
    
    
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    // 图片和视频只能上传一种，删除视频 和 图片(图片限制上传9张 为避免第二次选中重复图片，每次选图片，就把上次选的删除)
    if (assets.count > 0 && self.photoArray.count > 0) {
        // 删除图片
        NSString *filePath = [self getDocumentDirectory];
        
        if ([fm fileExistsAtPath:filePath]) {
            
            NSInteger n = self.photoArray.count;
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:0];
            
            for (NSUInteger idx = 0; idx < n; idx++) {
                id obj = [self.photoArray objectAtIndex:idx];
                
                // 只删除选择的相册的图片  不删除拍照的图片
                if ([obj isKindOfClass:[JKAssets class]]) {
                    NSString *filname = self.imageNameArray[idx];
                    NSError *error = nil;
                    BOOL res = [fm removeItemAtPath:[filePath stringByAppendingPathComponent:filname] error:&error];
                    if (!res) {
                        ALOGDebug(@"删除失败 error = %@", error);
                    }
                }
                else {
                    [array addObject:obj];
                    [array1 addObject:self.imageNameArray[idx]];
                }
            }
            
            [self.photoArray removeAllObjects];
            [self.imageNameArray removeAllObjects];
            [self.photoArray addObjectsFromArray:array];
            [self.imageNameArray addObjectsFromArray:array1];
        }
    }
    
    // 如果是视频的图片，则删除视频的图片和视频
    if (self.videoData) {
        [self.photoArray removeAllObjects];
    }
    self.videoData = nil;
    self.videoImage = nil;
    self.videoName = nil;
    
    [assets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JKAssets *asset = (JKAssets *)obj;
        UIImage *result = asset.photo;
        NSData *data;
        if (UIImagePNGRepresentation(result) == nil) {
            data = UIImageJPEGRepresentation(result, 1);
        } else {
            data = UIImagePNGRepresentation(result);
        }
        
        // 保存图片
        NSString *filePath = [self getDocumentDirectory];
        [fm createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *fileName = [NSString stringWithFormat:@"image-%lu-%@.png", (unsigned long)idx, [NSString getUniqueStrByUUID]];
        BOOL res = [data writeToFile:[filePath stringByAppendingPathComponent:fileName] atomically:NO];
        if (!res) {
            ALOGDebug(@"存储图片失败");
        } else {
            // 刷新界面
            [self.imageNameArray addObject:fileName];
            if (![self.photoArray containsObject:asset]) {
                [self.photoArray addObject:asset];
            }
        }
    }];
    [self.photoView reloadData];
}

- (void)refreshPictures:(NSNotification *)noti {
    [self.editArray addObjectsFromArray:noti.object];
    [self.photoArray removeAllObjects];
    [self.photoArray addObjectsFromArray:self.editArray];
    [_photoView reloadData];
}

// 选择视频 \ 或者拍照 (图片和视频只能上传一种)
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    NSString *type = [info objectForKey:@"UIImagePickerControllerMediaType"];
    
    // 拍照
    if ([type isEqualToString:@"public.image"]) {
        self.isCamrea = YES;
        if (self.videoData) {
            [self.photoArray removeAllObjects];
        }
        // 删除视频
        self.videoData = nil;
        self.videoImage = nil;
        self.videoName = nil;
        
        // 获取照片
        UIImage *imageTemp = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *imgData = UIImageJPEGRepresentation(imageTemp, 0);
        
        UIImage *image = [imageTemp fixOrientation];
        NSData *imgData1 = UIImageJPEGRepresentation(image, 0);
        
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            data = UIImageJPEGRepresentation(image, 1);
        } else {
            data = UIImagePNGRepresentation(image);
        }
        // 保存照片
        NSString *filePath = [self getDocumentDirectory];
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *fileName = [NSString stringWithFormat:@"image-camera-%@.png", [NSString getUniqueStrByUUID]];
        BOOL res = [data writeToFile:[filePath stringByAppendingPathComponent:fileName] atomically:NO];
        if (!res) {
            ALOGDebug(@"存储图片失败");
        }
        else {
            // 刷新界面
            [self.imageNameArray addObject:fileName];
            [self.photoArray addObject:image];
            [self.photoView reloadData];
        }
    }
    // 视频
    else {
        // 删除图片
        NSString *filePath = [self getDocumentDirectory];
        
        if ([fileManager fileExistsAtPath:filePath]) {
            [self.photoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSString *filname = self.imageNameArray[idx];
                BOOL res = [fileManager removeItemAtPath:[filePath stringByAppendingPathComponent:filname] error:nil];
                if (!res) {
                    ALOGDebug(@"删除图片失败");
                }
            }];
        }
        [self.photoArray removeAllObjects];
        [self.imageNameArray removeAllObjects];
        
        // 删除视频
        self.videoData = nil;
        self.videoImage = nil;
        self.videoName = nil;
        
        // 获取视频
        NSURL *path = [info objectForKey:@"UIImagePickerControllerMediaURL"];
        NSData *createData = [NSData dataWithContentsOfURL:path];
        self.videoLength = createData.length;
        
        // 判断视频大小
        if (self.videoLength > 15*1024*1024) {
//            [SVProgressHUD showErrorWithStatus:@"上传视频不能超过15M"];x
            return;
        }
        
        self.videoData = createData;
        self.videoImage = [self getImage:path];
        self.videoName = [NSString stringWithFormat:@"video-camera-%@.MOV", [NSString getUniqueStrByUUID]];
        [self.photoArray addObject:self.videoImage];
        [self.photoView reloadData];
    }
}

//获取本地视频缩略图，网上说需要添加AVFoundation.framework
- (UIImage *)getImage:(NSURL *)URL{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:URL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    
    return thumb;
}

#pragma mark - ===================== UICollectionViewDataSource =====================

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
   
        ImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
        id obj = [self.photoArray objectAtIndex:indexPath.item];
        if ([obj isKindOfClass:[UIImage class]]) {
            cell.imageView.image = obj;
        } else {
            JKAssets *asset = (JKAssets *)obj;
            cell.imageView.image = asset.photo;
        }
        
        return cell;
    
}

#pragma mark - ===================== UICollectionViewDelegate =====================

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.editArray removeAllObjects];
    
        ShowImagesController *imageVC = [[ShowImagesController alloc] init];
        imageVC.imageArray = self.photoArray;
        imageVC.imageNameArray = self.imageNameArray;
        imageVC.selectedIndex = indexPath.item;
        imageVC.modalPresentationStyle  = UIModalPresentationFullScreen;
        [self presentViewController:imageVC animated:YES completion:nil];
    
}


- (IBAction)selectPhotoBtnOnTouch:(id)sender {
    [self selectPhoto];
}

- (IBAction)cameraBtnOnTouch:(id)sender {
    [self takePhotos];
}

- (IBAction)audioBtnOnTouch:(id)sender {
    
    [self takeVideos];
}
@end
