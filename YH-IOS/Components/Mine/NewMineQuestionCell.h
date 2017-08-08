//
//  NewMineQuestionCell.h
//  YH-IOS
//
//  Created by 薛宇晶 on 2017/7/30.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "HWCollectionViewCell.h"
#import "JJPhotoManeger.h"
#import "HWImagePickerSheet.h"
#import "PhotoNavigationController.h"
#import "PhotoManagerConfig.h"
#import "PhotoRevealCell.h"
#import "UIImage+StackBlur.h"
#import "zoomPopup.h"
#import "UIImage+StackBlur.h"
#import "User.h"
#import "SCLAlertView.h"
#import "Version.h"
#import "APIHelper.h"


@protocol HWPublishBaseViewDelegate <NSObject>

@optional

@end

@interface NewMineQuestionCell : UITableViewCell<UITextViewDelegate,JJPhotoDelegate,HWImagePickerSheetDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIButton *saveBtn;
    NSInteger  clickImageNumber;
    User *user;
    NSString *questionProblemText;
    NSString *pushImageName;
    UILabel *headerLaber;
}
@property (nonatomic, strong) Version *version;

@property (nonatomic, strong) HWImagePickerSheet *imgPickerActionSheet;

@property (nonatomic, assign) id<HWPublishBaseViewDelegate> delegate;

@property (nonatomic, strong) UICollectionView *pickerCollectionView;

@property (nonatomic, assign) CGFloat collectionFrameY;

//选择的图片数据
@property(nonatomic,strong) NSMutableArray *arrSelected;

//方形压缩图image 数组
@property(nonatomic,strong) NSMutableArray * imageArray;

//大图image 数组
@property(nonatomic,strong) NSMutableArray * bigImageArray;

//大图image 二进制
@property(nonatomic,strong) NSMutableArray * bigImgDataArray;

//图片选择器
@property(nonatomic,strong) UIViewController *showActionSheetViewController;

//collectionView所在view
@property(nonatomic,strong) UIView *showInView;

//图片总数量限制
@property(nonatomic,assign) NSInteger maxCount;

//初始化collectionView
- (void)initPickerView;
//修改collectionView的位置
- (void)updatePickerViewFrameY:(CGFloat)Y;
//获得collectionView 的 Frame
- (CGRect)getPickerViewFrame;

//获取选中的所有图片信息
- (NSArray*)getSmallImageArray;
- (NSArray*)getBigImageArray;
- (NSArray*)getALAssetArray;

- (void)pickerViewFrameChanged;



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andType:(NSString*)type;


@end
