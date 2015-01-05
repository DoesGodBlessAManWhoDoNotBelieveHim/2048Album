//
//  ScanPhotoViewController.m
//  2048Album
//
//  Created by Jzhang on 14-12-2.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import "ScanPhotoViewController.h"
#import "ScanCollectionViewCell.h"
#import "ImageCache.h"
#import "UIViewController+MMDrawerController.h"

@interface ScanPhotoViewController ()<ScanCollectionViewCellDelegate,FileManagerDelegate>{
    NSTimer *toolbarHiddenTimer;
    //UIToolbar *toolbar;
    
    UIBarButtonItem *addressItem;
}

@end

@implementation ScanPhotoViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    self.title = [NSString stringWithFormat:@"%i of %i",self.comingWith+1,self.photosArray.count];
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
    UIBarButtonItem *exportToAlbum = [[UIBarButtonItem alloc]initWithTitle:@"导出" style:UIBarButtonItemStylePlain target:self action:@selector(exportToAlbum:)];
    UIBarButtonItem *trashPhoto = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashPhoto:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    addressItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    addressItem.enabled = NO;
    //[toolbar setItems:@[exportToAlbum,space,trashPhoto]];
    
    self.toolbarItems = @[exportToAlbum,space,addressItem,space,trashPhoto];
    self.navigationController.toolbarHidden = NO;
    
    //[self.view addSubview:toolbar];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mm_drawerController.GameBranch = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.comingWith inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    if (self.navigationController.toolbarHidden){
        self.navigationController.toolbarHidden = NO;
    }
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
    
    [super viewWillDisappear:animated];
}

- (void)dealloc{
    [self.photosArray removeAllObjects];
    self.photosArray = nil;
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
    return self.photosArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ScanCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    ImageCache *shareImageCache = [ImageCache shareImageCache];
    PhotoInfo *tempPhotoInfo = [self.photosArray objectAtIndex:indexPath.item];
    //UIImage *iamge = [shareImageCache objectForKey:tempPhotoInfo.name];
    cell.imageView.image = [UIImage imageWithContentsOfFile:[shareImageCache objectForKey:tempPhotoInfo.name]];
    cell.tagIndex = indexPath.item;
    cell.delegate = self;
    tempPhotoInfo = nil;
    //self.title = self.title = [NSString stringWithFormat:@"%i of %i",indexPath.item+1,self.photosArray.count];
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
//    self.title = [NSString stringWithFormat:@"%i of %i",indexPath.item+1,self.photosArray.count];
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int offset = scrollView.contentOffset.x;
    if (offset % 320 == 0) {
        self.title = [NSString stringWithFormat:@"%i of %i",offset/320+1,self.photosArray.count];
        PhotoInfo *photo = [self.photosArray objectAtIndex:offset/320];
        [addressItem setTitle:photo.locationName];
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

- (void)exportToAlbum:(id)sender{
    [[HUDManager shareHUDManager]showWithStatus:@"图片导出中..."];
    ScanCollectionViewCell *cell = self.collectionView.visibleCells[0];
    UIImageWriteToSavedPhotosAlbum(cell.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    if (!error) {
        [[HUDManager shareHUDManager]showSuccess:@"完成!\n请前往本地相册查看"];
    }
    else{
        [[HUDManager shareHUDManager]showError:[error description]];
    }
}

- (void)trashPhoto:(id)sender{
    NSLog(@"%i",self.collectionView.visibleCells.count);
    [[HUDManager shareHUDManager]showWithStatus:@"图片删除中..."];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    ScanCollectionViewCell *cell = self.collectionView.visibleCells[0];
    PhotoInfo *tempPhotoInfo =[self.photosArray objectAtIndex:cell.tagIndex];
    
    [FileManager shareFileManager].delegate = self;
    [[FileManager shareFileManager] deletePhotosByPassword:appDelegate.password photos:@[tempPhotoInfo]];
}
#pragma mark - CollectionCell Delegate
- (void)tapToHideToolBar:(UITapGestureRecognizer *)tap{
    [self showOrHidden];
}

#pragma mark - FileManager Delegate

- (void)handleDeletePhotoWithPasswordSuccessCount:(NSInteger)successCount failedCount:(NSInteger)failedCount{
    if (successCount>0) {
        ScanCollectionViewCell *cell = self.collectionView.visibleCells[0];
        [[HUDManager shareHUDManager]showSuccess:@"完成！"];
        [self.photosArray removeObjectAtIndex:cell.tagIndex];
        [self.collectionView reloadData];
    }
    else{
        [[HUDManager shareHUDManager]showSuccess:@"失败！"];
    }
}


@end
