//
//  CLTableView.h
//  Traveling
//
//  Created by 朱成龙 on 2018/10/22.
//  Copyright © 2018 ZHC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

-(instancetype)initWithDelegate:(id<UITableViewDelegate,UITableViewDataSource>)delegate
                       cellsName:(NSArray *)cells;

-(instancetype)initWithCellName:(NSString *)cell;

@property (nonatomic,strong) void (^didSelectBlock) (NSIndexPath * indexPath);
@property (nonatomic,strong) void (^cellSettingBlock) (UITableViewCell * tableViewCell);

@property (nonatomic,strong) NSMutableArray * dataArray;

-(void)setNoDataImage:(UIImage *)image
          noDataLabel:(NSString *)title;
@end
