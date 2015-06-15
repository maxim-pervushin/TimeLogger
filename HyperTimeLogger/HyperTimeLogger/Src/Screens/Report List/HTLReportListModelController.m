//
// Created by Maxim Pervushin on 29/05/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLReportListModelController.h"
#import "HTLReportDto.h"
#import "HTLContentManager.h"
#import "HTLReportExtendedDto.h"
#import "HTLDateSectionDto.h"


static NSString *const kDefaultDateFormat = @"yyyy-MM-dd HH:mm:ss ZZZ";

@interface HTLReportListModelController ()

@property(nonatomic, copy) HTLModelControllerContentChangedBlock contentChangedBlock;

@end

@implementation HTLReportListModelController
@dynamic reportSections;

#pragma mark - HTLReportListModelController

+ (instancetype)modelControllerWithContentChangedBlock:(HTLModelControllerContentChangedBlock)block {
    HTLReportListModelController *instance = [self new];
    if (block) {
        instance.contentChangedBlock = block;
    }
    return instance;
}

- (NSArray *)reportSections {
    return [[HTLContentManager defaultManager] reportSections];
}

- (NSArray *)reportsExtendedForDateSectionAtIndex:(NSInteger)index {
    HTLDateSectionDto *dateSection = [[HTLContentManager defaultManager] reportSections][(NSUInteger) index];
    return [[HTLContentManager defaultManager] reportsExtendedWithSection:dateSection];
}

- (void)subscribe {
    __weak __typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:kHTLStorageProviderChangedNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        if (weakSelf.contentChangedBlock) {
            weakSelf.contentChangedBlock();
        }
    }];
}

- (void)unsubscribe {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHTLStorageProviderChangedNotification object:nil];
};

#pragma mark - NSObject

- (instancetype)init {
    self = [super init];
    if (self) {
        [self subscribe];
    }
    return self;
}

- (void)dealloc {
    [self unsubscribe];
}

#pragma mark  - Test Data

- (NSString *)newIdentifier {
    return [NSUUID UUID].UUIDString;
}


- (NSDate *)dateFromString:(NSString *)string {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = kDefaultDateFormat;
    });
    return [dateFormatter dateFromString:string];
}

- (void)createWithActionTitle:(NSString *)title categoryIdentifier:(NSString *)categoryIdentifier dateString:(NSString *)dateString {
    HTLContentManager *manager = [HTLContentManager defaultManager];
    HTLActionDto *action = [HTLActionDto actionWithIdentifier:[self newIdentifier] title:title];
    HTLCategoryDto *category = [HTLCategoryDto categoryWithIdentifier:categoryIdentifier title:@"Ignored" color:[UIColor blackColor]];


    NSDate *startDate = manager.lastReportEndDate ? manager.lastReportEndDate : [self dateFromString:dateString];

    HTLReportExtendedDto *reportExtended = [HTLReportExtendedDto reportExtendedWithReport:nil action:action category:category];

    [manager storeReportExtended:reportExtended
    ];
}

- (void)createTestData {
    if ([HTLContentManager defaultManager].reportsExtended.count != 0) {
        return;
    }

//    // 2015-06-02
//
//    [self createWithActionTitle:@"Проснулся" categoryIdentifier:@"0" dateString:@"2015-06-02 08:00:00 GMT+3"];
//    [self createWithActionTitle:@"Умылся" categoryIdentifier:@"1" dateString:@"2015-06-02 08:10:10 GMT+3"];
//    [self createWithActionTitle:@"Приготовил завтрак" categoryIdentifier:@"1" dateString:@"2015-06-02 08:20:11 GMT+3"];
//    [self createWithActionTitle:@"Поел. Завтрак" categoryIdentifier:@"1" dateString:@"2015-06-02 08:40:15 GMT+3"];
//    [self createWithActionTitle:@"Собрался" categoryIdentifier:@"1" dateString:@"2015-06-02 08:55:55 GMT+3"];
//    [self createWithActionTitle:@"Пришел в офис" categoryIdentifier:@"2" dateString:@"2015-06-02 09:15:10 GMT+3"];
//    [self createWithActionTitle:@"Интернет" categoryIdentifier:@"6" dateString:@"2015-06-02 09:27:12 GMT+3"];
//    [self createWithActionTitle:@"Time Logger" categoryIdentifier:@"3" dateString:@"2015-06-02 11:21:15 GMT+3"];
//    [self createWithActionTitle:@"Поел. Обед" categoryIdentifier:@"1" dateString:@"2015-06-02 11:49:35 GMT+3"];
//    [self createWithActionTitle:@"Интернет" categoryIdentifier:@"6" dateString:@"2015-06-02 12:12:12 GMT+3"];
//    [self createWithActionTitle:@"Habbit" categoryIdentifier:@"3" dateString:@"2015-06-02 15:05:22 GMT+3"];
//    [self createWithActionTitle:@"Поел. Перекус" categoryIdentifier:@"1" dateString:@"2015-06-02 15:22:22 GMT+3"];
//    [self createWithActionTitle:@"Интернет" categoryIdentifier:@"6" dateString:@"2015-06-02 15:37:12 GMT+3"];
//    [self createWithActionTitle:@"Пришел Домой" categoryIdentifier:@"2" dateString:@"2015-06-02 17:31:22 GMT+3"];
//    [self createWithActionTitle:@"Приготовил еду" categoryIdentifier:@"1" dateString:@"2015-06-02 19:20:22 GMT+3"];
//    [self createWithActionTitle:@"Поел. Ужин" categoryIdentifier:@"1" dateString:@"2015-06-02 19:50:12 GMT+3"];
//    [self createWithActionTitle:@"Посмотрел кино" categoryIdentifier:@"5" dateString:@"2015-06-02 21:37:22 GMT+3"];
//    [self createWithActionTitle:@"Поел. Чай" categoryIdentifier:@"1" dateString:@"2015-06-02 22:01:12 GMT+3"];
//    [self createWithActionTitle:@"Интернет" categoryIdentifier:@"6" dateString:@"2015-06-02 23:02:22 GMT+3"];
//    [self createWithActionTitle:@"Читал статьи" categoryIdentifier:@"4" dateString:@"2015-06-02 23:42:22 GMT+3"];
//    [self createWithActionTitle:@"Почистил зубы" categoryIdentifier:@"1" dateString:@"2015-06-03 00:02:22 GMT+3"];
//    [self createWithActionTitle:@"Читал книгу" categoryIdentifier:@"4" dateString:@"2015-06-03 00:52:12 GMT+3"];
//
//    // 2015-06-03
//
//    [self createWithActionTitle:@"Проснулся" categoryIdentifier:@"0" dateString:@"2015-06-03 08:00:00 GMT+3"];
//    [self createWithActionTitle:@"Умылся" categoryIdentifier:@"1" dateString:@"2015-06-03 08:10:10 GMT+3"];
//    [self createWithActionTitle:@"Приготовил завтрак" categoryIdentifier:@"1" dateString:@"2015-06-03 08:20:11 GMT+3"];
//    [self createWithActionTitle:@"Поел. Завтрак" categoryIdentifier:@"1" dateString:@"2015-06-03 08:40:15 GMT+3"];
//    [self createWithActionTitle:@"Собрался" categoryIdentifier:@"1" dateString:@"2015-06-03 08:55:55 GMT+3"];
//    [self createWithActionTitle:@"Пришел в офис" categoryIdentifier:@"2" dateString:@"2015-06-03 09:15:10 GMT+3"];
//    [self createWithActionTitle:@"Интернет" categoryIdentifier:@"6" dateString:@"2015-06-03 09:27:12 GMT+3"];
//    [self createWithActionTitle:@"Time Logger" categoryIdentifier:@"3" dateString:@"2015-06-03 11:21:15 GMT+3"];
//    [self createWithActionTitle:@"Поел. Обед" categoryIdentifier:@"1" dateString:@"2015-06-03 11:49:35 GMT+3"];
//    [self createWithActionTitle:@"Интернет" categoryIdentifier:@"6" dateString:@"2015-06-03 12:12:12 GMT+3"];
//    [self createWithActionTitle:@"Habbit" categoryIdentifier:@"3" dateString:@"2015-06-03 15:05:22 GMT+3"];
//    [self createWithActionTitle:@"Поел. Перекус" categoryIdentifier:@"1" dateString:@"2015-06-03 15:22:22 GMT+3"];
//    [self createWithActionTitle:@"Интернет" categoryIdentifier:@"6" dateString:@"2015-06-03 15:37:12 GMT+3"];
//    [self createWithActionTitle:@"Портфолио" categoryIdentifier:@"4" dateString:@"2015-06-03 16:01:22 GMT+3"];
//    [self createWithActionTitle:@"Пришел Домой" categoryIdentifier:@"2" dateString:@"2015-06-03 16:31:22 GMT+3"];
//    [self createWithActionTitle:@"Собрался в тренажерку" categoryIdentifier:@"1" dateString:@"2015-06-03 16:55:21 GMT+3"];
//    [self createWithActionTitle:@"Пришел в тренажерку" categoryIdentifier:@"2" dateString:@"2015-06-03 17:12:42 GMT+3"];
//    [self createWithActionTitle:@"Тренировался" categoryIdentifier:@"4" dateString:@"2015-06-03 17:12:42 GMT+3"];
//    [self createWithActionTitle:@"Собрался" categoryIdentifier:@"1" dateString:@"2015-06-03 18:15:43 GMT+3"];
//    [self createWithActionTitle:@"Пришел Домой" categoryIdentifier:@"2" dateString:@"2015-06-03 18:40:22 GMT+3"];
//    [self createWithActionTitle:@"Приготовил еду" categoryIdentifier:@"1" dateString:@"2015-06-03 19:20:22 GMT+3"];
//    [self createWithActionTitle:@"Поел. Ужин" categoryIdentifier:@"1" dateString:@"2015-06-03 19:50:12 GMT+3"];
//    [self createWithActionTitle:@"Посмотрел кино" categoryIdentifier:@"5" dateString:@"2015-06-03 21:37:22 GMT+3"];
//    [self createWithActionTitle:@"Поел. Чай" categoryIdentifier:@"1" dateString:@"2015-06-03 22:01:12 GMT+3"];
//    [self createWithActionTitle:@"Интернет" categoryIdentifier:@"6" dateString:@"2015-06-03 23:02:22 GMT+3"];
//    [self createWithActionTitle:@"Читал статьи" categoryIdentifier:@"4" dateString:@"2015-06-03 23:42:22 GMT+3"];
//    [self createWithActionTitle:@"Почистил зубы" categoryIdentifier:@"1" dateString:@"2015-06-04 00:02:22 GMT+3"];
//    [self createWithActionTitle:@"Читал книгу" categoryIdentifier:@"4" dateString:@"2015-06-04 00:52:12 GMT+3"];
}

@end


