//
//  ViewController.m
//  2048Album
//
//  Created by Jzhang on 14-10-15.
//  Copyright (c) 2014年 hket.com. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "CellLabel.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import <StoreKit/StoreKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UIViewController+MMDrawerController.h"
#import "FileManager.h"
#import "BestFiveImage.h"

#import "SecurityViewController.h"


#define animationDuration 0.1f
@interface ViewController ()<UIGestureRecognizerDelegate,MFMailComposeViewControllerDelegate,SKStoreProductViewControllerDelegate>{
    SystemSoundID effectSoundID;
    BOOL effectSoundEnable;
    
    int score;
    int bestScore;
    
    
    /////////////////////////合并状态
    BOOL canBeMerged[4][4];
    
    BOOL canBornNewLabel;
    
    UIView *menuView;
    UIView *maskView;
    
    float mapLocationY;
}
@property (strong, nonatomic) IBOutlet UIView *iconView;
@property (strong, nonatomic) IBOutlet UIView *scoreView;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *bestLabel;

@property (strong, nonatomic) IBOutlet UIView *bestView;
@property (strong, nonatomic) IBOutlet UIButton *reset;

@property (strong, nonatomic) IBOutlet UIButton *menu;
@property (strong, nonatomic) IBOutlet UIButton *effect;

@property (nonatomic, strong) NSMutableArray *existLabelsArray;//已存在的
@property (nonatomic, strong) NSMutableArray *emptySpaceArray;//空余的

@property (nonatomic, strong) NSArray       *placeArray;//全部的

@property (nonatomic, strong) NSString *filePath;

- (IBAction)shiftEffectState:(id)sender;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *iconViewTopSpaceToSuperView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightOfIconView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightOf2Label;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *menuButtonTopSpaceToIconView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tipLabelTopSpaceToMenuButton;


@end

@implementation ViewController
- (IBAction)menuAction:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    self.mm_drawerController.Gaming = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)gotoRate:(id)sender{
    /*
    SKStoreProductViewController *store = [[SKStoreProductViewController alloc]init];
    store.delegate = self;
    [store loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : @"587767923"} completionBlock:^(BOOL result, NSError *error) {
        if (error) {
            [[[UIAlertView alloc]initWithTitle:@"Cannot open Apps Store" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
        }
        else{
            UIActivityIndicatorView *indicatior = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [indicatior startAnimating];
            indicatior.color = [UIColor blackColor];
            [indicatior setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 15, [UIScreen mainScreen].bounds.size.height/2 - 15, 30, 30)];
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.window addSubview:indicatior];
            [self presentViewController:store animated:YES completion:^{
                [indicatior stopAnimating];
                [indicatior removeFromSuperview];
            }];
        }
    }];*/
    /*
    NSString *str2 = [NSString stringWithFormat:
                      @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",
                      @"346703830"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str2]];
     */
}
#pragma mark - SKStoreProductViewControllerDelegate
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)resetAction:(id)sender {
    bestScore = (int)[[NSUserDefaults standardUserDefaults]integerForKey:kBestScore];
    [self.bestLabel setText:[NSString stringWithFormat:@"%i",bestScore]];
    [self initGame];
}

- (void)shiftEffectState:(id)sender{
    if (effectSoundEnable) {
        [self.effect setTitle:NSLocalizedString(@"EffectOn", nil) forState:UIControlStateNormal];
    }
    else {
        [self.effect setTitle:NSLocalizedString(@"EffectOff", nil) forState:UIControlStateNormal];
    }
    effectSoundEnable = !effectSoundEnable;
    [[NSUserDefaults standardUserDefaults]setBool:effectSoundEnable forKey:kEffectSoundEnable];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (IBAction)effectSoundPlay:(id)sender {
    if (effectSoundEnable) {
        AudioServicesPlaySystemSound(effectSoundID);
    }
}

- (void)resetLabelsMergeState{
    for (CellLabel *tempLabel in self.existLabelsArray) {
        tempLabel.canBeMerged = YES;
    }
}
#pragma mark - self
- (void)viewDidLoad
{
    [super viewDidLoad];
    mapLocationY = [(AppDelegate *)([UIApplication sharedApplication].delegate) mapLocationY];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoGuideViewController:) name:kGuideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoLeaderBoardViewController:) name:kLeaderBoardNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoFeedbackViewController:) name:kFeedbackNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoAboutViewController:) name:kAboutNotification object:nil];
    
    self.placeArray = @[[NSNumber numberWithInteger:11],[NSNumber numberWithInteger:21],[NSNumber numberWithInteger:31],                [NSNumber numberWithInteger:41], // 1 行  [x,y]
                        [NSNumber numberWithInteger:12],[NSNumber numberWithInteger:22],[NSNumber numberWithInteger:32],[NSNumber numberWithInteger:42], //
                        [NSNumber numberWithInteger:13],[NSNumber numberWithInteger:23],[NSNumber numberWithInteger:33],[NSNumber numberWithInteger:43],
                        [NSNumber numberWithInteger:14],[NSNumber numberWithInteger:24],[NSNumber numberWithInteger:34],[NSNumber numberWithInteger:44]];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *soundPath = [[NSBundle mainBundle]pathForResource:@"swipSound" ofType:@"caf"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)([NSURL fileURLWithPath:soundPath]), &effectSoundID);
    effectSoundEnable = NO;//[[NSUserDefaults standardUserDefaults]boolForKey:kEffectSoundEnable];
    
    if (mainScreenSize.height==480) {
        // iconView
        self.iconViewTopSpaceToSuperView.constant = 5;
        self.constraintHeightOf2Label.constant = 40.0;
        self.constraintHeightOfIconView.constant = 80.0f;
        
        self.menuButtonTopSpaceToIconView.constant = 5.0f;
        self.tipLabelTopSpaceToMenuButton.constant = 0.0f;
        //self.lockViewTopSpaceToTipLabel.constant = 5.0f;
    }
    
    [self rectifyTheStateOfEffectSound];
    
    [self drawMap];
    [self initGame];

    
    //[self createGameResultImageFilePath];
    
    //[self test];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self.view bringSubviewToFront:self.lockView];
    self.lockView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.mm_drawerController.GameIsCenter = YES;
    self.mm_drawerController.GameBranch = NO;
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    //[self drawMap];
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (BOOL)shouldAutomaticallyForwardRotationMethods{
    return NO;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
}

/*
- (void)test{
    [self createGameResultImageFilePath];
    [self saveGameResult];
}
*/
- (void)drawMap{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, mapLocationY, [UIScreen mainScreen].bounds.size.width - 20, [UIScreen mainScreen].bounds.size.width - 20)];
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:220/255.0 alpha:1];
    imageView.alpha = 0.2;
    [self.view addSubview:imageView];
    
    UIGraphicsBeginImageContext(CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, [UIScreen mainScreen].bounds.size.width - 20));
    [imageView.image drawInRect:imageView.bounds];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapButt);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), cellSpace);
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0/255.0, 0/255.0, 0/255.0, 1.0);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    
    //边框
    //横线
    for (int i = 0; i < 5; i ++) {
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 0, (cellSpace + cellSize)*i+2);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), [UIScreen mainScreen].bounds.size.width - 10, (cellSpace + cellSize)*i+2);
    }
    //竖线
    for (int i = 0; i < 5 ; i ++) {
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), (cellSpace + cellSize)*i+2, 0);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), (cellSpace + cellSize)*i+2, imageView.bounds.size.height);
    }
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // add swipGesture
    UISwipeGestureRecognizer *swip;
    //上
    swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiped:)];
    swip.direction = UISwipeGestureRecognizerDirectionUp;
    [imageView addGestureRecognizer:swip];
    //下
    swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiped:)];
    swip.direction = UISwipeGestureRecognizerDirectionDown;
    [imageView addGestureRecognizer:swip];
    //左
    swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiped:)];
    swip.direction = UISwipeGestureRecognizerDirectionLeft;
    [imageView addGestureRecognizer:swip];
    //右
    swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiped:)];
    swip.direction = UISwipeGestureRecognizerDirectionRight;
    [imageView addGestureRecognizer:swip];
    
    UITapGestureRecognizer *doubleFingerDoubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openAlbum:)];
    doubleFingerDoubleTap.numberOfTapsRequired = 3;
    [doubleFingerDoubleTap setNumberOfTouchesRequired:2];
    [imageView addGestureRecognizer:doubleFingerDoubleTap];
}

- (void)openAlbum:(UITapGestureRecognizer *)tap{
    SecurityViewController *securityViewController = [[SecurityViewController alloc]initWithType:LockViewTypeLogin];
    UINavigationController *securityNavigation = [[UINavigationController alloc]initWithRootViewController:securityViewController];
    [self presentViewController:securityNavigation animated:NO completion:nil];
}

- (void)initGame{
    /*
     placeXY :
     11     21      31      41
     12     22      32      42
     13     23      33      43
     14     24      34      44
     */
    self.emptySpaceArray = [NSMutableArray arrayWithObjects:
    [NSNumber numberWithInteger:11],[NSNumber numberWithInteger:21],[NSNumber numberWithInteger:31],[NSNumber numberWithInteger:41], // 1 行  [x,y]
    [NSNumber numberWithInteger:12],[NSNumber numberWithInteger:22],[NSNumber numberWithInteger:32],[NSNumber numberWithInteger:42], //
    [NSNumber numberWithInteger:13],[NSNumber numberWithInteger:23],[NSNumber numberWithInteger:33],[NSNumber numberWithInteger:43],
    [NSNumber numberWithInteger:14],[NSNumber numberWithInteger:24],[NSNumber numberWithInteger:34],[NSNumber numberWithInteger:44],nil];
    
    if (self.existLabelsArray) {
        for (CellLabel *cellLabel in self.existLabelsArray) {
            [cellLabel removeFromSuperview];
        }
        [self.existLabelsArray removeAllObjects];
        self.existLabelsArray = nil;
    }
    self.existLabelsArray = [NSMutableArray arrayWithCapacity:16];
    
    bestScore = (int)[[NSUserDefaults standardUserDefaults]integerForKey:kBestScore];
    [self.bestLabel setText:[NSString stringWithFormat:@"%i",bestScore]];
    
    score = 0;
    [self updateSocre];
    [self bornNewNumber:YES];
}

- (void)bornNewNumber:(BOOL)first{ // first == yes 表示是首次产生两个label
    
    if (self.emptySpaceArray) {
        [self.emptySpaceArray removeAllObjects];
        self.emptySpaceArray = nil;
    }
    self.emptySpaceArray = [NSMutableArray arrayWithObjects:
                            [NSNumber numberWithInteger:11],[NSNumber numberWithInteger:21],[NSNumber numberWithInteger:31],[NSNumber numberWithInteger:41], // 1 行  [x,y]
                            [NSNumber numberWithInteger:12],[NSNumber numberWithInteger:22],[NSNumber numberWithInteger:32],[NSNumber numberWithInteger:42], //
                            [NSNumber numberWithInteger:13],[NSNumber numberWithInteger:23],[NSNumber numberWithInteger:33],[NSNumber numberWithInteger:43],
                            [NSNumber numberWithInteger:14],[NSNumber numberWithInteger:24],[NSNumber numberWithInteger:34],[NSNumber numberWithInteger:44],nil];
    if (self.existLabelsArray && self.existLabelsArray.count > 0) { // 除了首次，从第二次开始要清除已存在的label
        for (CellLabel *tempLabel in self.existLabelsArray) {
            [self.emptySpaceArray removeObject:[NSNumber numberWithInt:tempLabel.placeXY]];
        }
    }
    
    int random;
    int bornCount = 1;
    if (first) {
        bornCount = 2;
    }
    
    for (int i = 0; i < bornCount; i ++) {
        random = arc4random()%self.emptySpaceArray.count;
        //  frame
        NSLog(@"self.emptySpaceArray.count:%li--rand:%i",(unsigned long)self.emptySpaceArray.count,random);
        NSNumber *placeXY = [self.emptySpaceArray objectAtIndex:random];
        [self.emptySpaceArray removeObjectAtIndex:random];
        CellLabel *cellLabel = [[CellLabel alloc]init];
        
       // CGPoint realLocation = [self coverToRealLocationFromPlaceXY:[placeXY integerValue]];
        cellLabel.frame = CGRectMake(0, 0, cellSize, cellSize);
        cellLabel.placeXY = [placeXY intValue];

        if (i == 1) {
            random = 2;
        }
        else{
            random = arc4random()%2 == 0?2:4;
        }
        
        [cellLabel setNumber:random];
        
        //
        [self.existLabelsArray addObject:cellLabel];
        [self.view addSubview:cellLabel];
        cellLabel.alpha = 0;
        [UIView animateWithDuration:animationDuration delay:animationDuration options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cellLabel.alpha = 1;
        } completion:^(BOOL finished) {
            if (self.existLabelsArray.count >=16) {
                if ([self checkGameOver]) {
                    [self gameOver];
                }
            }
        }];
    }
    
    [self effectSoundPlay:nil];
    [self resetLabelsMergeState];
}

- (void)gameOver{
    
    [self saveGameResult];
    [[[UIAlertView alloc]initWithTitle:@"Game Over" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil] show];
}

//存储分数最高的五局图片
- (void)saveGameResult{
    if (bestScore > [[NSUserDefaults standardUserDefaults]integerForKey:kBestScore]) {
        [[NSUserDefaults standardUserDefaults]setInteger:bestScore forKey:kBestScore];
    }
    BestFiveImage *bestImage = [[BestFiveImage alloc]init];
    bestImage.image = [self renderGameView];
    bestImage.score = score;
    FileManager *shareFileManager = [FileManager shareFileManager];
    int imageCount = [shareFileManager countOfScoreImages];
    if (imageCount <5) {
        [shareFileManager saveSocreImage:bestImage];
    }
    else{
        if (score > [shareFileManager selectLowestSocre]) {
            [shareFileManager saveSocreImage:bestImage];
            [shareFileManager deleteLowestSocreImage];
        }
    }
    bestImage = nil;
    /*
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *bestSocreImages = [fileManager subpathsAtPath:_filePath];
    for (NSString *bes in bestSocreImages) {
        NSLog(@"%@",bes);
    }
    if (bestSocreImages.count >=5) {
        int temp = [[[bestSocreImages[0] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
        for (int i = 1; i < 5; i ++) {
            int scoreName = [[[bestSocreImages[i] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
            NSLog(@"%i",scoreName);
            if (temp > scoreName) {
                temp = scoreName;
            }
        }
        if (score > temp) {
            [self saveGameOverImage];
        }
        
    }
    else{
        [self saveGameOverImage];
    }
    */
}
/*
- (void)saveGameOverImage{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (bestScore > [[NSUserDefaults standardUserDefaults]integerForKey:kBestScore]) {
        [[NSUserDefaults standardUserDefaults]setInteger:bestScore forKey:kBestScore];
    }
    
    NSData *imageData = UIImageJPEGRepresentation([self renderGameView], 0.5);
    NSString *resultImagePath = [NSString stringWithFormat:@"%@/%i.jpg",_filePath,score];
    [fileManager createFileAtPath:resultImagePath contents:imageData attributes:nil];
}

- (void)createGameResultImageFilePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *str1 = NSHomeDirectory();
    _filePath = [NSString stringWithFormat:@"%@/Documents/game/leaderboard",str1];
    if (DEBUG) {
        NSLog(@"filePath:%@",_filePath);
    }
    if(![fileManager fileExistsAtPath:_filePath]){
        
        [fileManager createDirectoryAtPath:_filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
*/
- (UIImage *)renderGameView{
    CGRect rect =self.view.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    float originX = 10;
    float originy = mapLocationY;
    float width = [UIScreen mainScreen].bounds.size.width - originX*2;
    float height = width;
    //你需要的区域起点,宽,高;
    
    CGRect rect1 = CGRectMake(originX , originy , width , height);
    return [UIImage imageWithCGImage:CGImageCreateWithImageInRect([img CGImage], rect1)];
}

- (BOOL)checkGameOver{
    for (NSNumber *placeXY in self.placeArray) {
        if (placeXY.integerValue % 10 < 4) {//第一,二，三行,x = 1，2，3 ,y = 1,2,3,4
            if (placeXY.integerValue / 10 < 4) {
                if ([self cheackLabelButtomAndRight:placeXY.intValue direction:1]) {
                    return NO;
                }
            }
            if ([self cheackLabelButtomAndRight:placeXY.intValue direction:2]) {
                return NO;
            }
        }else{//第4行，x=4,只需检测右边的值
            if (placeXY.integerValue / 10 < 4) {// 只需检查前三个
                if ([self cheackLabelButtomAndRight:placeXY.intValue direction:1]) {
                    return NO;
                }
            }
        }
    }
    
    return YES;
}


// 此方法只在 判断是否gameover使用
- (BOOL)cheackLabelButtomAndRight:(int)placeXY direction:(int)direction{// 检查PlaceXY处的label是否可与它下面或者右边的label合并,direction :1 right, 2 buttom
    

    int labelNumber = 0;
    int nextLabelNumber = 3;
    int nextLabelPlaceXY;
    //int indexOffset;
    /*
    if (direction == 1) {
        indexOffset = 1;
    }
    else{
        indexOffset = 4;
    }
     */
    /*
    for (int i = 0; i < self.existLabelsArray.count; i ++) {
        NSLog(@"self.existLabelsArray.count:%i,\n(i:%i+indexOffset:%i)=%i",self.existLabelsArray.count,i,indexOffset,i+indexOffset);
//        if (i + indexOffset >= self.existLabelsArray.count) {
//            continue ;
//        }
        CellLabel *tempLabel = (CellLabel *)[self.existLabelsArray objectAtIndex:i];
        
        if (tempLabel.placeXY == placeXY) {
            labelNumber = tempLabel.number;
     
            CellLabel *tempNextLabel = (CellLabel *)[self.existLabelsArray objectAtIndex:i + indexOffset];
            nextLabelNumber = tempNextLabel.number;
            if (labelNumber == nextLabelNumber) {
                return YES;
            }
            return NO;
     
        }

    }
    
    for (int i = 0; i < self.existLabelsArray.count; i ++) {
        NSLog(@"self.existLabelsArray.count:%i,\n(i:%i+indexOffset:%i)=%i",self.existLabelsArray.count,i,indexOffset,i+indexOffset);
        if (i + indexOffset >= self.existLabelsArray.count) {
            continue ;
        }
        CellLabel *tempNextLabel = (CellLabel *)[self.existLabelsArray objectAtIndex:i];
        
        if (tempNextLabel.placeXY == placeXY + direction==1?10:1) {
            nextLabelNumber = tempNextLabel.number;
        }
        
    }
    */
    if (direction == 1) {
        nextLabelPlaceXY = placeXY + 10;
    }
    else {
        nextLabelPlaceXY = placeXY + 1;
    }
    for (CellLabel *tempLabel in self.existLabelsArray) {
        if (tempLabel.placeXY == placeXY) {
            labelNumber = tempLabel.number;
            continue;
        }
        //nextLabelPlaceXY = placeXY + (direction == 1?10:1);
        if (tempLabel.placeXY == nextLabelPlaceXY) {
            nextLabelNumber = tempLabel.number;
        }
    }
    
    if (labelNumber == nextLabelNumber) {
        return YES;// 可以合并，游戏未结束
    }else{
        return NO;//不能合并
    }
    
}
/*
- (CGPoint)coverToRealLocationFromPlaceXY:(int)placeXY{
    CGPoint realLocation = CGPointZero;
    realLocation.x = 10 + (cellSize + cellSpace)*(placeXY/10 - 1) + cellSpace;
    realLocation.y = mapLocationY + (cellSpace + cellSize)*(placeXY%10 - 1) + cellSpace;
    return realLocation;
}
*/
- (void)swiped:(UISwipeGestureRecognizer *)swip{
    
    NSMutableArray *array1 = [[NSMutableArray alloc]initWithCapacity:4];// 首
    NSMutableArray *array2 = [[NSMutableArray alloc]initWithCapacity:4];// 二
    NSMutableArray *array3 = [[NSMutableArray alloc]initWithCapacity:4];// 三
    NSMutableArray *array4 = [[NSMutableArray alloc]initWithCapacity:4];// 四
    
    switch (swip.direction) {
        case UISwipeGestureRecognizerDirectionUp:{
            
            for (CellLabel *tempLabel in self.existLabelsArray) {
                if (tempLabel.placeXY % 10 == 2) {
                    [array2 addObject:tempLabel];
                }
                if (tempLabel.placeXY % 10 == 3) {
                    [array3 addObject:tempLabel];
                }
                if (tempLabel.placeXY % 10 == 4) {
                    [array4 addObject:tempLabel];
                }
            }
            
            for (CellLabel *tempLabel in array2) {// 第二行
                [self cheackTopLabel:tempLabel];
            }
            
            for (CellLabel *tempLabel in array3){//第三行
                [self cheackTopLabel:tempLabel];
            }
            
            for (CellLabel *tempLabel in array4){//第四行
                [self cheackTopLabel:tempLabel];
            }

        }
            NSLog(@"上滑");
            break;
        case UISwipeGestureRecognizerDirectionDown:{
            
            for (CellLabel *tempLabel in self.existLabelsArray) {
                if (tempLabel.placeXY % 10 == 1) {
                    [array1 addObject:tempLabel];
                }
                if (tempLabel.placeXY % 10 == 2) {
                    [array2 addObject:tempLabel];
                }
                if (tempLabel.placeXY % 10 == 3) {
                    [array3 addObject:tempLabel];
                }
                
            }

            
            for (CellLabel *tempLabel in array3) {// 第二行
                [self cheackButtomLabel:tempLabel];
            }
            
            for (CellLabel *tempLabel in array2){//第三行
                [self cheackButtomLabel:tempLabel];
            }
            
            for (CellLabel *tempLabel in array1){//第四行
                [self cheackButtomLabel:tempLabel];
            }

        }
            NSLog(@"下滑");
            break;
        case UISwipeGestureRecognizerDirectionLeft:{
            for (CellLabel *tempLabel in self.existLabelsArray) {
                if (tempLabel.placeXY / 10 == 2) {
                    [array2 addObject:tempLabel];
                }
                if (tempLabel.placeXY / 10 == 3) {
                    [array3 addObject:tempLabel];
                }
                if (tempLabel.placeXY / 10 == 4) {
                    [array4 addObject:tempLabel];
                }
            }
            for (CellLabel *tempLabel in array2) {// 第二行
                [self cheackLeftLabel:tempLabel];
            }
            
            for (CellLabel *tempLabel in array3){//第三行
               [self cheackLeftLabel:tempLabel];
            }
            
            for (CellLabel *tempLabel in array4){//第四行
                [self cheackLeftLabel:tempLabel];
            }

        }
            NSLog(@"左滑");
            break;
        case UISwipeGestureRecognizerDirectionRight:{
            for (CellLabel *tempLabel in self.existLabelsArray) {
                if (tempLabel.placeXY / 10 == 2) {
                    [array2 addObject:tempLabel];
                }
                if (tempLabel.placeXY / 10 == 3) {
                    [array3 addObject:tempLabel];
                }
                if (tempLabel.placeXY / 10 == 1) {
                    [array1 addObject:tempLabel];
                }
            }
            for (CellLabel *tempLabel in array3) {// 第二行
                
                [self cheackRightLabel:tempLabel];
            }
            
            for (CellLabel *tempLabel in array2){//第2行
                [self cheackRightLabel:tempLabel];
            }
            
            for (CellLabel *tempLabel in array1){//第1行
                [self cheackRightLabel:tempLabel];
            }

        }
            NSLog(@"右滑");
            break;
        default:
            break;
    }
    if (self.existLabelsArray.count < 16 && canBornNewLabel) {
        [self bornNewNumber:NO];
        canBornNewLabel = NO;
    }
    
}

// 1，有且不同 2 有且相同 3 无
- (BOOL)cheackTopLabel:(CellLabel *)cellLabel{// label是否可上移
    
    for (CellLabel *tempLabel in self.existLabelsArray) {
        if (tempLabel.placeXY == cellLabel.placeXY - 1) { //代表此label的上面有label
            if (tempLabel.number == cellLabel.number) {// 两个label数值相等
                if (!tempLabel.canBeMerged) {
                    return NO;
                }
                [self.existLabelsArray removeObject:tempLabel];
                //[tempLabel removeFromSuperview];
                
                /*
                [UIView animateWithDuration:animationDuration animations:^{
                    
                    cellLabel.placeXY = cellLabel.placeXY - 1;
                }];
                */
                [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    cellLabel.placeXY = cellLabel.placeXY - 1;
                    tempLabel.alpha = 0.3;
                } completion:^(BOOL finished) {
                    cellLabel.number = cellLabel.number * 2;
                    score += cellLabel.number;
                    [self updateSocre];
                    [tempLabel removeFromSuperview];
                }];
                
                //canBeMerged[cellLabel.placeXY / 10 - 1][cellLabel.placeXY % 10 - 1] = NO;
                cellLabel.canBeMerged = NO;
                //[self.existLabelsArray addObject:cellLabel];
                canBornNewLabel = YES;
                return YES;
            }
            else{// 两个label数值不同
                return NO;
            }
        }
    }
    // 3 无
    if (cellLabel.placeXY % 10 - 1 == 1) {//第二行
        canBornNewLabel = YES;
        [UIView animateWithDuration:animationDuration animations:^{
            cellLabel.placeXY = cellLabel.placeXY - 1;
        }];
        
    }
    else{
        canBornNewLabel = YES;
        [UIView animateWithDuration:animationDuration animations:^{
            cellLabel.placeXY = cellLabel.placeXY - 1;
        }];
        if (cellLabel.canBeMerged/*canBeMerged[cellLabel.placeXY / 10 - 1][cellLabel.placeXY % 10 - 1]*/) {
            [self cheackTopLabel:cellLabel];
        }
    }

    return YES;
}

- (BOOL)cheackButtomLabel:(CellLabel *)cellLabel{// label是否可下移
    for (CellLabel *tempLabel in self.existLabelsArray) {
        if (tempLabel.placeXY == cellLabel.placeXY + 1) { //代表此label的上面有label
            if (tempLabel.number == cellLabel.number) {// 两个label数值相等
                if (!tempLabel.canBeMerged) {
                    return NO;
                }
                [self.existLabelsArray removeObject:tempLabel];
                
                /*
                [UIView animateWithDuration:.5f animations:^{
                    cellLabel.number = cellLabel.number * 2;
                    
                    cellLabel.placeXY = cellLabel.placeXY + 1;
                }];
                */
                [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    cellLabel.placeXY = cellLabel.placeXY + 1;
                    tempLabel.alpha = 0.3f;
                } completion:^(BOOL finished) {
                    cellLabel.number = cellLabel.number * 2;
                    score += cellLabel.number;
                    [self updateSocre];
                    [tempLabel removeFromSuperview];
                }];
                //canBeMerged[cellLabel.placeXY / 10 - 1][cellLabel.placeXY % 10 - 1] = NO;
                cellLabel.canBeMerged = NO;
                //[self.existLabelsArray addObject:cellLabel];
                canBornNewLabel = YES;
                return YES;
            }
            else{// 两个label数值不同
                return NO;
            }
        }
    }
    // 3 无
    if (cellLabel.placeXY % 10 + 1 == 4) {//第三行
        canBornNewLabel = YES;
        [UIView animateWithDuration:animationDuration animations:^{
            cellLabel.placeXY = cellLabel.placeXY + 1;
        }];
        
    }
    else{
        canBornNewLabel = YES;
        [UIView animateWithDuration:animationDuration animations:^{
            cellLabel.placeXY = cellLabel.placeXY + 1;
        }];
        if (cellLabel.canBeMerged/*canBeMerged[cellLabel.placeXY / 10 - 1][cellLabel.placeXY % 10 - 1]*/) {
            [self cheackButtomLabel:cellLabel];
        }
    }

    return NO;
}

- (BOOL)cheackLeftLabel:(CellLabel *)cellLabel{// label是否可左移
    for (CellLabel *tempLabel in self.existLabelsArray) {
        if (tempLabel.placeXY == cellLabel.placeXY - 10) { //代表此label的上面有label
            if (tempLabel.number == cellLabel.number) {// 两个label数值相等
                if (!tempLabel.canBeMerged) {
                    return NO;
                }
                [self.existLabelsArray removeObject:tempLabel];
                
                /*
                [UIView animateWithDuration:animationDuration animations:^{
                    cellLabel.number = cellLabel.number * 2;
                    cellLabel.placeXY = cellLabel.placeXY - 10;
                }];
                */
                [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    cellLabel.placeXY = cellLabel.placeXY - 10;
                    tempLabel.alpha = 0.3f;
                } completion:^(BOOL finished) {
                    cellLabel.number *= 2;
                    score += cellLabel.number;
                    [self updateSocre];
                    [tempLabel removeFromSuperview];
                }];
                //canBeMerged[cellLabel.placeXY / 10 - 1][cellLabel.placeXY % 10 - 1] = NO;
                cellLabel.canBeMerged = NO;
                //[self.existLabelsArray addObject:cellLabel];
                canBornNewLabel = YES;
                return YES;
            }
            else{// 两个label数值不同
                return NO;
            }
        }
    }
    // 3 无
    if (cellLabel.placeXY / 10 - 1 == 1) {//第2列
        canBornNewLabel = YES;
        [UIView animateWithDuration:animationDuration animations:^{
            cellLabel.placeXY = cellLabel.placeXY - 10;
        }];
        //[self.emptySpaceArray removeObject:[NSNumber numberWithInt:cellLabel.placeXY]];
    }
    else{
        canBornNewLabel = YES;
        [UIView animateWithDuration:animationDuration animations:^{
            cellLabel.placeXY = cellLabel.placeXY - 10;
        }];
        if (cellLabel.canBeMerged/*canBeMerged[cellLabel.placeXY / 10 - 1][cellLabel.placeXY % 10 - 1]*/) {
            [self cheackLeftLabel:cellLabel];
        }
    }
    
    return NO;
}


- (BOOL)cheackRightLabel:(CellLabel *)cellLabel{// label是否可右移
    for (CellLabel *tempLabel in self.existLabelsArray) {
        if (tempLabel.placeXY == cellLabel.placeXY + 10) { //代表此label的上面有label
            if (tempLabel.number == cellLabel.number) {// 两个label数值相等
                
                if (!tempLabel.canBeMerged) {
                    return NO;
                }
                
                [self.existLabelsArray removeObject:tempLabel];
                /*
                [UIView animateWithDuration:.5f animations:^{
                    cellLabel.number = cellLabel.number * 2;
                    cellLabel.placeXY = cellLabel.placeXY + 10;
                }];
                */
                [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    cellLabel.placeXY += 10;
                    tempLabel.alpha = 0.3f;
                } completion:^(BOOL finished) {
                    cellLabel.number *= 2;
                    score += cellLabel.number;
                    [self updateSocre];
                    [tempLabel removeFromSuperview];
                }];
                //canBeMerged[cellLabel.placeXY / 10 - 1][cellLabel.placeXY % 10 - 1] = NO;
                cellLabel.canBeMerged = NO;
                //[self.existLabelsArray addObject:cellLabel];
                canBornNewLabel = YES;
                return YES;
            }
            else{// 两个label数值不同
                return NO;
            }
        }
    }
    // 3 无
    if (cellLabel.placeXY / 10 + 1 == 4) {//第三列
        canBornNewLabel = YES;
        [UIView animateWithDuration:animationDuration animations:^{
            cellLabel.placeXY = cellLabel.placeXY + 10;
        }];
    }
    else{
        canBornNewLabel = YES;
        [UIView animateWithDuration:animationDuration animations:^{
            cellLabel.placeXY = cellLabel.placeXY + 10;
        }];
        if (cellLabel.canBeMerged/*canBeMerged[cellLabel.placeXY / 10 - 1][cellLabel.placeXY % 10 - 1]*/) {
            [self cheackRightLabel:cellLabel];
        }
    }
    
    return NO;
}

- (void)updateSocre{
    [self.scoreLabel setText:[NSString stringWithFormat:@"%i",score]];
    if (score > bestScore) {
        bestScore = score;
        [self.bestLabel setText:[NSString stringWithFormat:@"%i",bestScore]];
    }
}

- (void)rectifyTheStateOfEffectSound{
    if (effectSoundEnable) {
        [self.effect setTitle:@"effect off" forState:UIControlStateNormal];
    }
    else{
        [self.effect setTitle:@"effect on" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - performSegue

- (void)gotoGuideViewController:(id)sender{
    [self performSegueWithIdentifier:@"Guide" sender:self];
}

- (void)gotoFeedbackViewController:(id)sender{
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc]init];
    if (!mailVC) {
        [self feedBackByLaunchURL];
    }
    else{
        mailVC.mailComposeDelegate = self;
        
        [mailVC setToRecipients:@[@"King91chang@163.com"]];
        [mailVC setSubject:@"Suggestions"];
        [self presentViewController:mailVC animated:YES completion:^{
            
        }];
    }
}

- (void)gotoLeaderBoardViewController:(id)sender{
    [self performSegueWithIdentifier:@"LeaderBoard" sender:self];
}

- (void)feedBackByLaunchURL{
    NSString *mailUrl = @"mailto:King91chang@163.com";
    [mailUrl stringByAppendingString:@"&subject=Suggestions"];
    NSString *emailEncodingString = [mailUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:emailEncodingString]];
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    /*
     MFMailComposeResultCancelled,
     MFMailComposeResultSaved,
     MFMailComposeResultSent,
     MFMailComposeResultFailed*/
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"MFMailComposeResultSaved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"MFMailComposeResultSent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"MFMailComposeResultFailed");
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)gotoAboutViewController:(id)sender{
    [self performSegueWithIdentifier:@"About" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}

@end
