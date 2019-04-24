
//
//  LBStyle3VC.m
//  test
//
//  Created by dengweihao on 2017/12/26.
//  Copyright © 2017年 dengweihao. All rights reserved.
//

#import "LBStyle3VC.h"

@interface LBStyle3VC ()

@end

@implementation LBStyle3VC

- (void)viewDidLoad {
    self.lagerURLStrings = @[
                             //大图
                             @"http://p3.pstatp.com/large/w960/53220001268b1a373be9",
                             @"http://p3.pstatp.com/large/w960/4ecc000654544a1e96de",
                             @"http://p7.pstatp.com/large/w960/4ecc000654557eb903f0",
                             @"http://p2.pstatp.com/large/w960/4ecc000654567d246735",
                             @"http://p7.pstatp.com/large/w960/53210001381963c04923",
                             @"http://p3.pstatp.com/large/w960/532100012cafac577bf6",
                             @"http://p3.pstatp.com/large/w960/53240001202edd4de4ba",
                             @"http://p7.pstatp.com/large/w960/4ecc00064914d964561f",
                             @"http://p7.pstatp.com/large/w960/4ecb000657d013fef1b0",
                             @"http://p7.pstatp.com/large/w960/4ecb000657d18a0ba76e",
                             @"http://p7.pstatp.com/large/w960/53200002f39564a44388",
                             @"http://p7.pstatp.com/large/w960/4ecb000657d251ea4188",
                             @"http://p7.pstatp.com/large/w960/4ecb0005eb3ad2b76742",
                             @"http://p7.pstatp.com/large/w960/53210000cb4647a71763"
                             ];
    self.thumbnailURLStrings = self.lagerURLStrings;
    [super viewDidLoad];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LBCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.model = self.models[indexPath.row];
    __weak typeof(cell) wcell = cell;
    [cell setCallBack:^(LBModel *cellModel, int tag) {
        NSMutableArray *items = [[NSMutableArray alloc]init];
        for (int i = 0 ; i < cellModel.urls.count; i++) {
            LBURLModel *urlModel = cellModel.urls[i];
            UIImageView *imageView = wcell.imageViews[i];
            LBPhotoWebItem *item = [[LBPhotoWebItem alloc]initWithURLString:urlModel.largeURLString frame:imageView.frame];
            [items addObject:item];
        }
        
        [LBPhotoBrowserManager.defaultManager showImageWithWebItems:items selectedIndex:tag fromImageViewSuperView:wcell.contentView].lowGifMemory = YES;

        [[[LBPhotoBrowserManager.defaultManager addLongPressShowTitles:@[@"保存",@"识别二维码",@"取消"]] addTitleClickCallbackBlock:^(UIImage *image, NSIndexPath *indexPath, NSString *title, BOOL isGif, NSData *gifImageData) {
            LBPhotoBrowserLog(@"%@",title);
            if(![title isEqualToString:@"保存"]) return;
            if (!isGif) {
                [[LBAlbumManager shareManager] saveImage:image];
            }else {
                [[LBAlbumManager shareManager] saveGifImageWithData:gifImageData];
            }
        }]addPhotoBrowserWillDismissBlock:^{
            LBPhotoBrowserLog(@"即将销毁");
        }].needPreloading = YES;
        [[LBPhotoBrowserManager defaultManager] addPlaceholdImageCallBackBlock:^UIImage *(NSIndexPath *indexPath) {
            return [UIImage imageNamed:@"placehold.jpeg"];
        }];
        [LBPhotoBrowserManager defaultManager].pageStyle = LBPhotoBrowserViewPageStyleUIPageLabel;
    }];
    return cell;
}

@end
