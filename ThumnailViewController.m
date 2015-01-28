//
//  ThumnailViewController.m
//  2048Album
//
//  Created by Jzhang on 14-12-19.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import "ThumnailViewController.h"
#import "ThumnailCollectionCell.h"
#import "ThumnailHeaderView.h"
#import "ScanPhotoViewController.h"

#import "AGImagePickerController.h"
#import "AGIPCToolbarItem.h"

#import "UIViewController+MMDrawerController.h"

#import <MobileCoreServices/UTCoreTypes.h>

#import <ImageIO/CGImageProperties.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ThumnailViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CLLocationManagerDelegate,AGImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    AGImagePickerController *ipc;
    
    UIBarButtonItem *editItem;
    UIBarButtonItem *doneItem;
    
    UIBarButtonItem *addPhotos;
    UIBarButtonItem *exportItem;
    UIBarButtonItem *deleteItem;
    
    UIBarButtonItem *flexibleSpace;
    
    BOOL editable;
    
    NSIndexPath *didSelectItem;
    
    NSMutableArray *indexPaths;
}



@property (nonatomic, strong) NSMutableArray *photosArray;

@property (nonatomic, strong) NSMutableArray *videosArray;

@property (nonatomic, strong) NSMutableArray *selectedItemsArray;

@property (nonatomic)         BOOL            canNotUpdate;

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ThumnailViewController

@synthesize menuBarBtn,editBarBtn,segmentControl,contentCollectionView,photosArray,videosArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    addPhotos = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPhotos)];
    editItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
    exportItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Export", nil) style:UIBarButtonItemStylePlain target:self action:@selector(exportPhotosToLocalAlbum:)];
    doneItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    deleteItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deletePhotos:)];
    flexibleSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;
    
    flexibleSpace.enabled = NO;
    exportItem.enabled = NO;
    deleteItem.enabled = NO;
    self.toolbarItems = @[addPhotos,flexibleSpace,exportItem,flexibleSpace,deleteItem];
    
    self.navigationController.toolbarHidden = NO;
    
    // NOTIFICATION 
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoPasswordManagementViewController:) name:kPasswordManagementNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoFunctionIntroduceViewController:) name:kFunctionIntroduceNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoVersionUpdateViewController:) name:kVersionUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoAboutAlbumViewController:) name:kAboutAlbumNotification object:nil];

    [contentCollectionView registerNib:[UINib nibWithNibName:@"ThumnailCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ThumnailCollectionCell"];
    //[contentCollectionView registerNib:[UINib nibWithNibName:@"ThumnailHeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:@"UICollectionElementKindSectionHeader" withReuseIdentifier:@"ThumnailHeaderView"];
    
    //[contentCollectionView registerClass:[ThumnailHeaderView class] forSupplementaryViewOfKind:@"UICollectionElementKindSectionHeader" withReuseIdentifier:@"ThumnailHeaderView"];
    
    photosArray = [[NSMutableArray alloc]init];
    videosArray = [[NSMutableArray alloc]init];
    indexPaths = [[NSMutableArray alloc]init];
    
    //[self prepareAGImagePicker];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([[GeocoderManager sharedGeocoderManager].geoOperaQueue operationCount]>0){
        if (![[GeocoderManager sharedGeocoderManager].geoOperaQueue.operations[0] isExecuting]) {
            [[GeocoderManager sharedGeocoderManager] resume];
        }
        
    }
    else{
        if (segmentControl.selectedSegmentIndex == 0) {
            [[GeocoderManager sharedGeocoderManager] beginGeo:PickerTypePhotos];
        }
        else{
            [[GeocoderManager sharedGeocoderManager] beginGeo:PickerTypeVideos];
        }
    }
    
    self.mm_drawerController.GameBranch = NO;
    self.mm_drawerController.GameIsCenter = NO;
    if (!_canNotUpdate) {
        [self updateCollectionView];
    }
    _canNotUpdate = NO;
}

- (void)updateCollectionView{
    //[[HUDManager shareHUDManager]showWithStatus:@"信息加载中..."];
    
    if (photosArray.count>0) {
        [photosArray removeAllObjects];
    }
    if (videosArray.count>0) {
        [videosArray removeAllObjects];
    }
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [FileManager shareFileManager].delegate=self;
    if (segmentControl.selectedSegmentIndex==0) {
        [[FileManager shareFileManager]selectPhotosWithPassword:appDelegate.password];
    }
    else{
        [[FileManager shareFileManager]selectVideosWithPassword:appDelegate.password];
    }
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - NOTIFICATION
- (void)gotoPasswordManagementViewController:(NSNotification *)notification{
    [self performSegueWithIdentifier:@"gotoPasswordManagementViewController" sender:self];
}

- (void)gotoFunctionIntroduceViewController:(NSNotification *)notification{
    [self performSegueWithIdentifier:@"gotoFunctionIntroduceViewController" sender:self];
}

- (void)gotoVersionUpdateViewController:(NSNotification *)notification{
    [self performSegueWithIdentifier:@"gotoVersionUpdateViewController" sender:self];
}

- (void)gotoAboutAlbumViewController:(NSNotification *)notification{
    [self performSegueWithIdentifier:@"gotoAboutAlbumViewController" sender:self];
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"pushToFullSize"]) {
        ScanPhotoViewController *destinationViewController = segue.destinationViewController;
        //destinationViewController.album = album;
        
        
        
        NSMutableArray *nums = [NSMutableArray array];
        
        NSMutableArray *tempsArray = [NSMutableArray array];
        if (segmentControl.selectedSegmentIndex == 0) {
            for (NSArray *temp in photosArray) {
                [nums addObject:[NSNumber numberWithInteger:temp.count]];
                [tempsArray addObjectsFromArray:temp];
            }
        }
        else{
            for (NSArray *temp in videosArray) {
                [nums addObject:[NSNumber numberWithInteger:temp.count]];
                [tempsArray addObjectsFromArray:temp];
            }
        }
        
        NSInteger row = didSelectItem.item;
        for (int i = 0; i < didSelectItem.section; i++) {
            row += [nums[i] integerValue];
        }
        
        destinationViewController.comingWith = row;
        
        destinationViewController.datasourcesArray = [NSMutableArray arrayWithArray:tempsArray];
        if (segmentControl.selectedSegmentIndex == 0) {
            destinationViewController.showType = PickerTypePhotos;
        }
        else{
            destinationViewController.showType = PickerTypeVideos;
        }
        
        [tempsArray removeAllObjects];
        tempsArray = nil;
    }
}

#pragma mark - AGImagePicker

- (void)pickImageWithType:(PickerType)type{
    AGImagePickerController *imagePicker = [[AGImagePickerController alloc]initWithDelegate:self failureBlock:^(NSError *error) {
        self.canNotUpdate = YES;
        if (error) {
            
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    } successBlock:^(NSArray *info) {
        self.canNotUpdate = YES;
        [self dismissViewControllerAnimated:YES completion:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (segmentControl.selectedSegmentIndex==0) {
                [[HUDManager shareHUDManager]showWithStatus:NSLocalizedString(@"PhotosSaving", nil)];
            }
            else{
                [[HUDManager shareHUDManager]showWithStatus:NSLocalizedString(@"VideosSaving", nil)];
            }
            
        });
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            
            [FileManager shareFileManager].delegate = self;
            if (segmentControl.selectedSegmentIndex==0) {
                [[FileManager shareFileManager]savePhotos:info withPassword:appDelegate.password];
            }
            else{// video
                [[FileManager shareFileManager]saveVideos:info withPassword:appDelegate.password];
            }
            
        });
        
        } maximumNumberOfPhotosToBeSelected:50 shouldChangeStatusBarStyle:YES toolbarItemsForManagingTheSelection:nil andShouldShowSavedPhotosOnTop:NO];
    
    imagePicker.pickerType = type;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)agImagePickerController:(AGImagePickerController *)picker didFail:(NSError *)error{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)agImagePickerController:(AGImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)pickImageByCameraWithType:(PickerType)type{
    /* start location*/
    [self.locationManager startUpdatingLocation];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [_locationManager requestWhenInUseAuthorization];
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    if (type == PickerTypePhotos) {
        [imagePickerController setMediaTypes:@[(NSString*)kUTTypeImage]];
    }
    else {
        [imagePickerController setMediaTypes:@[(NSString*)kUTTypeMovie]];
        [imagePickerController setVideoQuality:UIImagePickerControllerQualityTypeHigh];
        [imagePickerController setVideoMaximumDuration:600.f];
    }
    
    
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *origin =[info objectForKey:UIImagePickerControllerOriginalImage];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    NSDictionary *metadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
    [library writeImageToSavedPhotosAlbum:[origin CGImage] metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        if (!error) {
            [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                PhotoInfo *photo = [[PhotoInfo alloc]init];
                ALAssetRepresentation *rep = [asset defaultRepresentation];
                photo.name = [rep filename];
                photo.date = [TooManager stringFromDate:[asset valueForProperty:ALAssetPropertyDate]];
                //image
                UIImageOrientation orientation = (UIImageOrientation)[rep orientation];
                //CGImageRef orginImageRef = nil;
                photo.image = [UIImage imageWithCGImage:[rep fullResolutionImage] scale:1.0f orientation:orientation];
                photo.thumnailImage = [UIImage imageWithCGImage:asset.thumbnail];
                CLLocation* wgs84Location = [asset valueForProperty:ALAssetPropertyLocation];
                if (wgs84Location) {//判断是否在拍照时有开启定位，只有在开启了定位才能得到地理信息
                    //纬度
                    photo.latitude = [NSString stringWithFormat:@"%f",wgs84Location.coordinate.latitude];
                    //经度
                    photo.longitude = [NSString stringWithFormat:@"%f",wgs84Location.coordinate.longitude];
                    //海拔
                    photo.altitude = [NSString stringWithFormat:@"%f",wgs84Location.horizontalAccuracy];
                }
                else{
                    photo.latitude = [NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.latitude];
                    photo.longitude = [NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.longitude];
                }
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [FileManager shareFileManager].delegate = self;
                [[FileManager shareFileManager] savePhoto:photo withPassword:delegate.password];
                
            } failureBlock:^(NSError *error) {
                
            }];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[HUDManager shareHUDManager]showError:[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"FailedToSavePhotoToPhone", nil),[error description]]];
            });
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //CLLocation * currLocation = [locations lastObject];
    //NSLog(@"didUpdateLocations");
    //NSLog(@"%f,%f",(float)currLocation.coordinate.latitude,(float)currLocation.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    //NSLog(@"locationManager didFailWithError");
}

#pragma UIBar Button Item
- (IBAction)showMenu:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        
    }];
}
- (IBAction)editAction:(id)sender {
    self.navigationItem.rightBarButtonItem = doneItem;
    addPhotos.enabled = NO;
    editable = YES;
    self.selectedItemsArray = [NSMutableArray array];
}

//完成
- (void)doneAction:(id)sender{
    editable = NO;
    addPhotos.enabled = YES;
    self.navigationItem.rightBarButtonItem = editItem;
    
    if (self.selectedItemsArray) {
        [self.selectedItemsArray removeAllObjects];
        self.selectedItemsArray = nil;
    }
    [contentCollectionView reloadData];
}

//添加图片
- (void)addPhotos{
    UIActionSheet *selectPhotosActionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"PhotosImport", nil)  delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ImportFromAlbum", nil),NSLocalizedString(@"ImportFromCamera", nil), nil];
    selectPhotosActionSheet.tag = 1001;
    [selectPhotosActionSheet showInView:self.view];
}

//导出图片到本地相册
- (void)exportPhotosToLocalAlbum:(id)sender{
    NSString *title = nil;
    if (segmentControl.selectedSegmentIndex == 0) {
        title = NSLocalizedString(@"To_export_photos_to_the_local_album", nil);
    }
    else{
        title = NSLocalizedString(@"To_export_videos_to_the_local_album", nil) ;
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"OK", nil];
    actionSheet.tag = 1002;
    [actionSheet showFromBarButtonItem:exportItem animated:YES];

}

//删除相片
- (void)deletePhotos:(id)sender{
    NSString *title = nil;
    if (segmentControl.selectedSegmentIndex == 0) {
        title = NSLocalizedString(@"Delete_the_selected_photos", nil);
    }
    else{
        title = NSLocalizedString(@"Delete_the_selected_videos", nil);
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:NSLocalizedString(@"Delete", nil) otherButtonTitles:nil, nil];
    actionSheet.tag = 1003;
    [actionSheet showFromBarButtonItem:deleteItem animated:YES];
}

#pragma mark - SegmentControl
- (IBAction)segmentControlValueChanged:(id)sender {
    if (self.selectedItemsArray.count>0) {
        [self.selectedItemsArray removeAllObjects];
    }
    [self updateCollectionView];
}

#pragma mark - UICollectionView Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (segmentControl.selectedSegmentIndex==0) {
        return photosArray.count;
    }
    else{
        return videosArray.count;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (segmentControl.selectedSegmentIndex==0) {
        return [photosArray[section] count];
    }
    else{
        return [videosArray[section] count];
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ThumnailCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ThumnailCollectionCell" forIndexPath:indexPath];
    if (segmentControl.selectedSegmentIndex == 0) {
        PhotoInfo *photoInfo = photosArray[indexPath.section][indexPath.row];
        //photoInfo.image =[UIImage imageWithContentsOfFile:photoInfo.directory];
        cell.imageView.image = photoInfo.thumnailImage;//photoInfo.image;
        photoInfo = nil;
    }
    else{
        VideoInfo *videoInfo = videosArray[indexPath.section][indexPath.row];
        cell.imageView.image = videoInfo.thumnailImage;
        videoInfo = nil;
    }
    
    cell.overlayImageView.image = nil;
    if (self.selectedItemsArray.count>0) {
        for (NSIndexPath *tempIndexPath in self.selectedItemsArray) {
            if ([tempIndexPath isEqual:indexPath]) {
                cell.overlayImageView.image = [UIImage imageNamed:@"AGImagePickerController.bundle/AGIPC-Checkmark-iPhone"];
            }
        }
        exportItem.enabled = YES;
        deleteItem.enabled = YES;
    }
    else{
        exportItem.enabled = NO;
        deleteItem.enabled = NO;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    ThumnailHeaderView *headerView = nil;
    if (kind == UICollectionElementKindSectionHeader){
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ThumnailHeaderView" forIndexPath:indexPath];
    }
    if (segmentControl.selectedSegmentIndex == 0) {
        PhotoInfo *photoInfo = photosArray[indexPath.section][0];
        headerView.dateLabel.text = photoInfo.date;
        headerView.placeLabel.text = [NSString stringWithFormat:@"(long:%@,lat:%@)",photoInfo.longitude,photoInfo.latitude];
        photoInfo = nil;
    }
    else{
        VideoInfo *videoInfo = videosArray[indexPath.section][0];
        headerView.dateLabel.text = videoInfo.date;
        headerView.placeLabel.text = [NSString stringWithFormat:@"(long:%@,lat:%@)",videoInfo.longitude,videoInfo.latitude];
        videoInfo = nil;
    }
    
    return headerView;
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"(%li,%li)",(long)indexPath.section,(long)indexPath.row);
    if (editable) {
        if ([self.selectedItemsArray containsObject:indexPath]) {
            [self.selectedItemsArray removeObject:indexPath];
        }
        else{
            [self.selectedItemsArray addObject:indexPath];
        }
        if (self.selectedItemsArray.count >0) {
            deleteItem.enabled = YES;
            exportItem.enabled = YES;
        }
        else {
            deleteItem.enabled = NO;
            exportItem.enabled = NO;
        }
        [contentCollectionView reloadData];
    }
    else{
        didSelectItem = indexPath;
//        if (segmentControl.selectedSegmentIndex == 0) {
        
            
            [self performSegueWithIdentifier:@"pushToFullSize" sender:self];
//        }
//        else{
//            //播放视频
//            [self performSegueWithIdentifier:@"moviePlay" sender:self];
//            
//            NSLog(@"播放视频...");
//        }
        
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath  {
    if (mainScreenSize.width==414) {
        return CGSizeMake(80, 80);
    }
    return CGSizeMake((mainScreenSize.width-6)/4.0, (mainScreenSize.width-6)/4.0);
}


#pragma mark - UIActionSheet Delegate


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1001) {
        switch (buttonIndex) {
            case 0:
                if (self.segmentControl.selectedSegmentIndex==0) {
                    [self pickImageWithType:PickerTypePhotos];
                }
                else{
                    [self pickImageWithType:PickerTypeVideos];
                }
                
                break;
            case 1:
                if (self.segmentControl.selectedSegmentIndex==0) {
                    [self pickImageByCameraWithType:PickerTypePhotos];
                }
                else{
                    [self pickImageByCameraWithType:PickerTypeVideos];
                }
                
                break;
            default:
                break;
        }

    }
    else if (actionSheet.tag == 1002){
        if (buttonIndex == 0) {
            if (segmentControl.selectedSegmentIndex == 0) {
                [[HUDManager shareHUDManager]showWithStatus:[NSString stringWithFormat:@"%lu%@...",(unsigned long)self.selectedItemsArray.count,NSLocalizedString(@"PhotosExporting", nil)]];
            }
            else{
                [[HUDManager shareHUDManager]showWithStatus:[NSString stringWithFormat:@"%lu%@...",(unsigned long)self.selectedItemsArray.count,NSLocalizedString(@"VideosExporting", nil)]];
            }
            if (self.selectedItemsArray.count > 0) {
                for (NSIndexPath *tempIndexPath in self.selectedItemsArray) {
                    @autoreleasepool {
                        if (segmentControl.selectedSegmentIndex == 0) {
                            PhotoInfo *photoInfo = photosArray[tempIndexPath.section][tempIndexPath.item];
                            UIImage *imageToWrite = [UIImage imageWithContentsOfFile:photoInfo.imagePath];
                            UIImageWriteToSavedPhotosAlbum(imageToWrite, self, nil, nil);
                        }
                        else{
                            VideoInfo *videoInfo = videosArray[tempIndexPath.section][tempIndexPath.item];
                            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoInfo.path)) {
                                UISaveVideoAtPathToSavedPhotosAlbum(videoInfo.path, nil, nil, nil);
                            }
                        }
                        
                    }
                }
                [self.selectedItemsArray removeAllObjects];
                [[HUDManager shareHUDManager]showSuccess:[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"Done", nil),NSLocalizedString(@"CheckInLocalAlbum", nil)]];
                [contentCollectionView reloadData];
            }

        }
    }
    else if (actionSheet.tag == 1003){
        if (buttonIndex == 0) {
            if (self.selectedItemsArray.count > 0) {
                NSMutableArray *toDeleteArray = [NSMutableArray array];
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                if (segmentControl.selectedSegmentIndex == 0) {
                    for (NSIndexPath *tempIndexPath in self.selectedItemsArray) {
                        PhotoInfo *photoInfo = photosArray[tempIndexPath.section][tempIndexPath.item];
                        if (photoInfo) {
                            [toDeleteArray addObject:photoInfo];
                        }
                    }
                    if (toDeleteArray.count>0) {
                        [FileManager shareFileManager].delegate = self;
                        [[FileManager shareFileManager]deletePhotosByPassword:appDelegate.password photos:toDeleteArray];
                    }
                    
                }
                else{
                    for (NSIndexPath *tempIndexPath in self.selectedItemsArray) {
                        VideoInfo *videoInfo = videosArray[tempIndexPath.section][tempIndexPath.item];
                        if (videoInfo) {
                            [toDeleteArray addObject:videoInfo];
                        }
                    }
                    if (toDeleteArray.count>0) {
                        [[FileManager shareFileManager]deleteVideos:toDeleteArray byPassword:appDelegate.password];
                    }
                    
                }
                [toDeleteArray removeAllObjects];
                toDeleteArray = nil;
                [self.selectedItemsArray removeAllObjects];
                [self updateCollectionView];
            }
            deleteItem.enabled = NO;
            exportItem.enabled = NO;
        }
    }
}

#pragma mark - FileManager Delegate
#pragma mark - Album
- (void)handleCreatePhotosSuccess:(NSInteger)successCount failedCount:(NSInteger)failedCount{
    // show alert
    dispatch_async(dispatch_get_main_queue(), ^{
        if (successCount>0) {
            [[HUDManager shareHUDManager]showSuccess:[NSString stringWithFormat:@"%@！\n%li/%li %@",NSLocalizedString(@"Done", nil),(long)failedCount,(long)(successCount+failedCount),NSLocalizedString(@"photosFailed", nil)]];
        }
        else{
            [[HUDManager shareHUDManager]showError:[NSString stringWithFormat:@"%@！\n%li/%li %@",NSLocalizedString(@"Done", nil),(long)failedCount,(long)(successCount+failedCount),NSLocalizedString(@"photosFailed", nil)]];
        }
    });
    
    [self updateCollectionView];
}

- (void)handleDeletePhotoWithPasswordSuccessCount:(NSInteger)successCount failedCount:(NSInteger)failedCount{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (successCount>0) {
            [[HUDManager shareHUDManager]showSuccess:[NSString stringWithFormat:@"%@！\n%li/%li %@",NSLocalizedString(@"Done", nil),(long)failedCount,(long)(successCount+failedCount),NSLocalizedString(@"photosFailed", nil)]];
        }
        else{
            [[HUDManager shareHUDManager]showError:[NSString stringWithFormat:@"%@！\n%li/%li %@",NSLocalizedString(@"Done", nil),(long)failedCount,(long)(successCount+failedCount),NSLocalizedString(@"photosFailed", nil)]];
        }
    });

    [self updateCollectionView];
}

- (void)handleSelectPhotos:(NSArray *)photos byPassword:(NSString *)password success:(BOOL)success{
    if (photos.count > 0) {
        //[[HUDManager shareHUDManager]hideHud];
        [photosArray addObjectsFromArray:photos];
    }
    else{
        //[[HUDManager shareHUDManager]showError:@"相册没有图片或加载失败"];
    }
    
    int count = 0;
    for (NSArray *subArr in photosArray) {
        count += subArr.count;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.title = [NSString stringWithFormat:NSLocalizedString(@"", nil),count];
        [self.contentCollectionView reloadData];
    });
}

#pragma mark - Video
- (void)handleCreateVideosSuccess:(NSInteger)successCount failedCount:(NSInteger)failedCount{
    // show alert
    dispatch_async(dispatch_get_main_queue(), ^{
        if (successCount>0) {
            [[HUDManager shareHUDManager]showSuccess:[NSString stringWithFormat:@"%@！\n%li/%li %@",NSLocalizedString(@"Done", nil),(long)failedCount,(long)(successCount+failedCount),NSLocalizedString(@"videosFailed", nil)]];
        }
        else{
            [[HUDManager shareHUDManager]showError:[NSString stringWithFormat:@"%@！\n%li/%li %@",NSLocalizedString(@"Done", nil),(long)failedCount,(long)(successCount+failedCount),NSLocalizedString(@"videosFailed", nil)]];
        }
    });
    
    [self updateCollectionView];
}

- (void)handleSelectVideos:(NSArray *)videos byPassword:(NSString *)password success:(BOOL)success{
    if (videos.count>0) {
        [videosArray addObjectsFromArray:videos];
    }
    
    int count = 0;
    for (NSArray *subArr in videosArray) {
        count += subArr.count;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.title = [NSString stringWithFormat:NSLocalizedString(@"TotalVideos", nil),count];
        [self.contentCollectionView reloadData];
    });
}

- (void)handleDeleteVideosWithPasswordSuccessCount:(NSInteger)successCount failedCount:(NSInteger)failedCount{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (successCount>0) {
            [[HUDManager shareHUDManager]showSuccess:[NSString stringWithFormat:@"%@！\n%li/%li %@",NSLocalizedString(@"Done", nil),(long)failedCount,(long)(successCount+failedCount),NSLocalizedString(@"videosFailed", nil)]];
        }
        else{
            [[HUDManager shareHUDManager]showError:[NSString stringWithFormat:@"%@！\n%li/%li %@",NSLocalizedString(@"Done", nil),(long)failedCount,(long)(successCount+failedCount),NSLocalizedString(@"videosFailed", nil)]];
        }
    });
    
    [self updateCollectionView];

}

- (void)handleCreateANewPhoto:(PhotoInfo *)photoInfo success:(BOOL)success alreadyExist:(BOOL)exist{
    if (success) {
        [self updateCollectionView];
    }
    else{
        if (exist) {
            [[HUDManager shareHUDManager]showError:NSLocalizedString(@"ExistingPhotos", nil)];
        }
        else{
            [[HUDManager shareHUDManager]showError:NSLocalizedString(@"SavingPhotosError", nil)];
        }
    }
}

@end
