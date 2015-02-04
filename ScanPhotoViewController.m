//
//  ScanPhotoViewController.m
//  2048Album
//
//  Created by Jzhang on 14-12-2.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import "ScanPhotoViewController.h"
#import "ScanCollectionViewCell.h"
#import "UIViewController+MMDrawerController.h"

#import <MediaPlayer/MediaPlayer.h>

@interface ScanPhotoViewController ()<ScanCollectionViewCellDelegate,FileManagerDelegate,UIActionSheetDelegate>{
    NSTimer *toolbarHiddenTimer;
    //UIToolbar *toolbar;
    
    UIBarButtonItem *addressItem;
    
    BOOL canNotUpdate;
    
    UIBarButtonItem *exportToAlbum;
    UIBarButtonItem *trashPhoto;
}

@end

@implementation ScanPhotoViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    canNotUpdate = NO;
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    self.title = [NSString stringWithFormat:@"%li of %lu",self.comingWith+1,(unsigned long)self.datasourcesArray.count];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //self.view.frame = [UIScreen mainScreen].bounds;
//    if (DEBUG) {
//        NSLog(@"collectionViewFrame:(%f,%f,%f,%f)",collectionViewFrame.origin.x,collectionViewFrame.origin.y,collectionViewFrame.size.width,collectionViewFrame.size.height);
//    }
    self.collectionView.pagingEnabled = YES;
    [self.collectionView registerClass:[ScanCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    //toolbarHiddenTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showOrHidden) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view.
    //toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 20, self.view.bounds.size.width, 40)];
    exportToAlbum = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Export", nil) style:UIBarButtonItemStylePlain target:self action:@selector(exportToAlbum:)];
    trashPhoto = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashPhoto:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    addressItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    addressItem.enabled = NO;
    //[toolbar setItems:@[exportToAlbum,space,trashPhoto]];
    
    self.toolbarItems = @[exportToAlbum,space,addressItem,space,trashPhoto];
    self.navigationController.toolbarHidden = NO;
    
    if (self.showType == PickerTypeVideos) {
        UIBarButtonItem *playBarItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playMovie:)];
        self.navigationItem.rightBarButtonItem = playBarItem;
    }
    //[self.navigationItem.backBarButtonItem setTitle:@"Back"];
    //[self.view addSubview:toolbar];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mm_drawerController.GameBranch = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!canNotUpdate) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.comingWith inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    canNotUpdate = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
//    if (self.navigationController.toolbarHidden){
//        self.navigationController.toolbarHidden = NO;
//    }
    
    
    [super viewWillDisappear:animated];
}

- (void)dealloc{
    [self.datasourcesArray removeAllObjects];
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
    self.datasourcesArray = nil;
    self.collectionView = nil;
}

- (void)showOrHidden{
    if (self.navigationController.navigationBar.hidden) {
        [self.navigationController.navigationBar setHidden:NO];
        self.navigationController.toolbarHidden = NO;
    }
    else{
        [self.navigationController.navigationBar setHidden:YES];
        self.navigationController.toolbarHidden = YES;
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (BOOL) prefersStatusBarHidden{
    if (self.navigationController.toolbarHidden) {
        return YES ; //状态栏是否隐藏
    }
    else{
        return NO;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.datasourcesArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ScanCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    //ImageCache *shareImageCache = [ImageCache shareImageCache];
    //NSFileManager *defaultM = [NSFileManager defaultManager];
    
    id tempInfo = [self.datasourcesArray objectAtIndex:indexPath.item];
//    BOOL exi = [defaultM fileExistsAtPath:[tempInfo imagePath]];
//    if (exi) {
//        NSLog(@"exi");
//    }
    //UIImage *iamge = [UIImage imageWithContentsOfFile:[tempInfo imagePath]];
   
    cell.imageView.image = [UIImage imageWithContentsOfFile:[tempInfo imagePath]];
    
    cell.tagIndex = indexPath.item;
    cell.delegate = self;
    tempInfo = nil;
    // Configure the cell
    cell.backgroundColor = [UIColor blackColor];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize collectionSize = self.collectionView.bounds.size;
    return CGSizeMake(collectionSize.width, collectionSize.height);
}

//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int offset = scrollView.contentOffset.x;
    if (offset % (int)(mainScreenSize.width) == 0) {
        self.title = [NSString stringWithFormat:@"%i of %lu",offset/(int)(mainScreenSize.width)+1,(unsigned long)self.datasourcesArray.count];
        id info = [self.datasourcesArray objectAtIndex:offset/mainScreenSize.width];
        [addressItem setTitle:[info locationName]];
    }
    
}

/*
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
 */
/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

- (void)playMovie:(id)sender{
    canNotUpdate = YES;
    ScanCollectionViewCell *cell = self.collectionView.visibleCells[0];
    VideoInfo *tempVideoInfo =[self.datasourcesArray objectAtIndex:cell.tagIndex];
    // play movie
    MPMoviePlayerViewController *mpController =
    [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:tempVideoInfo.path]];
    [mpController. moviePlayer   prepareToPlay ];
    [mpController. moviePlayer   setControlStyle : MPMovieControlStyleFullscreen ];
    mpController.moviePlayer.scalingMode =MPMovieScalingModeAspectFit;
    
    [mpController. view   setBackgroundColor :[ UIColor   clearColor ]];
    
    [mpController. view   setFrame : self . view . bounds ];
    
    [[ NSNotificationCenter   defaultCenter ]  addObserver : self
     
                                                  selector : @selector (movieFinishedCallback:)
     
                                                      name : MPMoviePlayerPlaybackDidFinishNotification
     
                                                    object :mpController. moviePlayer ];
    [self presentMoviePlayerViewControllerAnimated:mpController];

    
}

-( void )movieFinishedCallback:( NSNotification *)notify{
    
    // 视频播放完或者在presentMoviePlayerViewControllerAnimated下的Done按钮被点击响应的通知。
    
    MPMoviePlayerController * theMovie = [notify  object ];
    
    [[ NSNotificationCenter   defaultCenter ]  removeObserver : self
     
                                                         name : MPMoviePlayerPlaybackDidFinishNotification
     
                                                       object :theMovie];
    
    [ self   dismissMoviePlayerViewControllerAnimated ];
    
}


- (void)exportToAlbum:(id)sender{
    
    NSString *title = nil;
    if (self.showType == PickerTypePhotos) {
        title = NSLocalizedString(@"To_export_photos_to_the_local_album", nil);
    }
    else{
        title = NSLocalizedString(@"To_export_videos_to_the_local_album", nil);
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"OK", nil];
    actionSheet.tag = 10001;
    [actionSheet showFromBarButtonItem:exportToAlbum animated:YES];
    
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    if (!error) {
        [[HUDManager shareHUDManager]showSuccess:[NSString stringWithFormat:@"%@!\n%@",NSLocalizedString(@"Done", nil),NSLocalizedString(@"CheckInLocalAlbum", nil)]];
    }
    else{
        [[HUDManager shareHUDManager]showError:[error description]];
    }
}


- (void)video: (NSString *)videoPath didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    if (!error) {
        [[HUDManager shareHUDManager]showSuccess:[NSString stringWithFormat:@"%@!\n%@",NSLocalizedString(@"Done", nil),NSLocalizedString(@"CheckInLocalAlbum", nil)]];
    }
    else{
        [[HUDManager shareHUDManager]showError:[error description]];
    }
}

- (void)trashPhoto:(id)sender{
    //NSLog(@"%i",self.collectionView.visibleCells.count);
    NSString *title = @"";
    if (self.showType == PickerTypePhotos) {
        title = NSLocalizedString(@"DeleteCurrentPhoto", nil);
    }
    else {
        title = NSLocalizedString(@"DeleteCurrentVideo", nil);
    }
    UIActionSheet *trashActionSheet = [[UIActionSheet alloc]initWithTitle:title delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:NSLocalizedString(@"Delete", nil) otherButtonTitles:nil, nil];
    trashActionSheet.tag = 10002;
    [trashActionSheet showFromBarButtonItem:trashPhoto animated:YES];
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 0) {
        ScanCollectionViewCell *cell = self.collectionView.visibleCells[0];
        if (actionSheet.tag == 10001) {
            if (self.showType == PickerTypePhotos) {
                [[HUDManager shareHUDManager]showWithStatus:NSLocalizedString(@"PhotosExporting", nil)];
                UIImageWriteToSavedPhotosAlbum(cell.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            }
            else{
                VideoInfo *video = self.datasourcesArray[cell.tagIndex];
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(video.path)) {
                    [[HUDManager shareHUDManager]showWithStatus:NSLocalizedString(@"VideosExporting", nil)];
                    UISaveVideoAtPathToSavedPhotosAlbum(video.path,self , @selector(video:didFinishSavingWithError:contextInfo:), nil);
                }
            }
        }
        if (actionSheet.tag == 10002) {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            if (self.showType == PickerTypePhotos) {
                [[HUDManager shareHUDManager]showWithStatus:@"Deleting..."];
                [FileManager shareFileManager].delegate = self;
                PhotoInfo *tempPhotoInfo =[self.datasourcesArray objectAtIndex:cell.tagIndex];
                
                [[FileManager shareFileManager] deletePhotosByPassword:appDelegate.password photos:@[tempPhotoInfo]];
                
            }
            else{
                [[HUDManager shareHUDManager]showWithStatus:@"Deleting..."];
                VideoInfo *tempVideoInfo =[self.datasourcesArray objectAtIndex:cell.tagIndex];
                [FileManager shareFileManager].delegate = self;
                [[FileManager shareFileManager] deleteVideos:@[tempVideoInfo] byPassword:appDelegate.password];
            }
        }
    }
}

#pragma mark - CollectionCell Delegate
- (void)tapToHideToolBar:(UITapGestureRecognizer *)tap{
    [self showOrHidden];
}

#pragma mark - FileManager Delegate

- (void)handleDeletePhotoWithPasswordSuccessCount:(NSInteger)successCount failedCount:(NSInteger)failedCount{
    if (successCount>0) {
        ScanCollectionViewCell *cell = self.collectionView.visibleCells[0];
        
        [[HUDManager shareHUDManager]showSuccess:[NSString stringWithFormat:@"%@!",NSLocalizedString(@"Done", nil)]];
        [self.datasourcesArray removeObjectAtIndex:cell.tagIndex];
        int count = (int)self.datasourcesArray.count;
        if (count == 0 || count == 1) {
            self.title = [NSString stringWithFormat:@"%i of %i",count,count];
        }
        else{
            self.title = [NSString stringWithFormat:@"%i of %i",(int)(cell.tagIndex+1),count];
        }
        
        [self.collectionView reloadData];
    }
    else{
        [[HUDManager shareHUDManager]showError:[NSString stringWithFormat:@"%@!",NSLocalizedString(@"Failed", nil)]];
    }
}

- (void)handleDeleteVideosWithPasswordSuccessCount:(NSInteger)successCount failedCount:(NSInteger)failedCount{
    if (successCount>0) {
        ScanCollectionViewCell *cell = self.collectionView.visibleCells[0];
        [[HUDManager shareHUDManager]showSuccess:[NSString stringWithFormat:@"%@!",NSLocalizedString(@"Failed", nil)]];
        [self.datasourcesArray removeObjectAtIndex:cell.tagIndex];
        NSInteger count = self.datasourcesArray.count;
        if (count == 0 || count == 1) {
            self.title = [NSString stringWithFormat:@"%li of %li",(long)count,(long)count];
        }
        else{
            self.title = [NSString stringWithFormat:@"%li of %li",cell.tagIndex+1,(long)count];
        }
        [self.collectionView reloadData];
    }
    else{
        [[HUDManager shareHUDManager]showError:[NSString stringWithFormat:@"%@!",NSLocalizedString(@"Failed", nil)]];
    }
}


@end
