//
//  CLTableView.m
//  Traveling
//
//  Created by 朱成龙 on 2018/10/22.
//  Copyright © 2018 ZHC. All rights reserved.
//

#import "CLTableView.h"
#import <Masonry/Masonry.h>
#import "CLCategory.h"
#import "objc/runtime.h"

@implementation CLTableView
{
    NSString * _cell;
    BOOL _isExist;
    
    UIImageView * _noDataImage;
    UILabel * _noDataLabel;
    UIView * _noDataView;
}
-(instancetype)initWithDelegate:(id<UITableViewDelegate,UITableViewDataSource>)delegate
                       cellsName:(NSArray *)cells
{
    self = [super init];
    if (self) {
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        self.estimatedRowHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.delegate = delegate;
        self.dataSource = delegate;
        self.backgroundColor = [UIColor whiteColor];
        for (NSString * cellname in cells) {
            [self registerClass:NSClassFromString(cellname) forCellReuseIdentifier:cellname];
        }
        self.tableFooterView = [UIView new];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _noDataView = [[UIView alloc]init];
        [self addSubview:_noDataView];
        [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        _noDataView.backgroundColor = [UIColor whiteColor];
        
        _noDataImage = [[UIImageView alloc]init];
        [_noDataView addSubview:_noDataImage];
        [_noDataImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self);
        }];
        
        _noDataLabel = [[UILabel alloc]init];
        [_noDataView addSubview:_noDataLabel];
        [_noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self->_noDataImage);
            make.bottom.equalTo(self->_noDataImage);
        }];
        _noDataLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        _noDataLabel.textColor = [UIColor hex:0x666666];
    }
    return self;
}
-(void)setNoDataImage:(UIImage *)image
          noDataLabel:(NSString *)title{
    _noDataImage.image = image;
    _noDataLabel.text = title;
}


-(instancetype)initWithCellName:(NSString *)cell{
    self = [super init];
    if (self) {
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        _cell = cell;
        self.estimatedRowHeight = 44;
        self.estimatedSectionFooterHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
        [self registerClass:NSClassFromString(cell) forCellReuseIdentifier:cell];
        self.tableFooterView = [UIView new];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        u_int count;
        objc_property_t *properties  =class_copyPropertyList(NSClassFromString(_cell), &count);
        for (int i = 0; i<count; i++)
        {
            const char* propertyName =property_getName(properties[i]);
            if ([[NSString stringWithUTF8String: propertyName] isEqualToString:@"model"]) {
                _isExist = true;
            }
        }
        free(properties);
        
        _noDataView = [[UIView alloc]init];
        [self addSubview:_noDataView];
        [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        _noDataView.backgroundColor = [UIColor whiteColor];
        
        _noDataImage = [[UIImageView alloc]init];
        [_noDataView addSubview:_noDataImage];
        [_noDataImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self);
        }];
        
        _noDataLabel = [[UILabel alloc]init];
        [_noDataView addSubview:_noDataLabel];
        [_noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self->_noDataImage);
            make.bottom.equalTo(self->_noDataImage).mas_offset(-30);
        }];
        _noDataLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        _noDataLabel.textColor = [UIColor hex:666666];
    }
    return self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:_cell];
    if (_isExist) {
        [cell setValue:_dataArray[indexPath.row] forKey:@"model"];
    }
    if (_cellSettingBlock) {
        _cellSettingBlock(cell);
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_didSelectBlock) {
        _didSelectBlock(indexPath);
    }
}
-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    if (_dataArray.count == 0) {
        _noDataView.hidden = false;
    }else{
        _noDataView.hidden = true;
    }
    [self reloadData];
}

@end
