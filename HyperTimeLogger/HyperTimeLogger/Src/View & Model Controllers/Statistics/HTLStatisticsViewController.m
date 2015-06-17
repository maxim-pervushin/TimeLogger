//
// Created by Maxim Pervushin on 08/06/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

#import "HTLStatisticsViewController.h"
#import "XYPieChart.h"
#import "HTLCategoryDto.h"
#import "HTLContentManager.h"
#import "HTLReportExtendedDto.h"
#import "HTLReportDto.h"

@interface HTLStatisticsViewController () <XYPieChartDataSource, XYPieChartDelegate>

@property(nonatomic, weak) IBOutlet XYPieChart *pieChart;

@property(nonatomic, strong) HTLStatisticsModelController *modelController;

@end

@implementation HTLStatisticsViewController

- (NSString *)descriptionForTimeInterval:(NSTimeInterval)timeInterval {
    NSInteger ti = (NSInteger) timeInterval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long) hours, (long) minutes, (long) seconds];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.modelController = [HTLStatisticsModelController new];
    self.modelController.fromDate = [NSDate date];
    self.modelController.toDate = [NSDate date];

    self.pieChart.dataSource = self;
    self.pieChart.delegate = self;
    self.pieChart.userInteractionEnabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.pieChart.pieCenter = CGPointMake(self.pieChart.bounds.size.width / 2, self.pieChart.bounds.size.height / 2);
    [self.pieChart reloadData];
}

#pragma mark  - XYPieChartDataSource

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart {
    return self.modelController.categories.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    HTLCategoryDto *category = self.modelController.categories[index];
    return (CGFloat) [self.modelController totalTimeForCategory:category];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index {
    HTLCategoryDto *category = self.modelController.categories[index];
    return category.color;
}

- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index {
    HTLCategoryDto *category = self.modelController.categories[index];
    NSLog(@"%@: %@", category.title, [self descriptionForTimeInterval:[self.modelController totalTimeForCategory:category]]);
    return [self descriptionForTimeInterval:[self.modelController totalTimeForCategory:category]];
}

@end

@implementation HTLStatisticsModelController
@dynamic categories;

- (NSArray *)categories{
    return [[HTLContentManager defaultManager] categoriesFromDate:self.fromDate toDate:self.toDate];
}

- (NSTimeInterval)totalTimeForCategory:(HTLCategoryDto *)category {
    NSArray *reportsExtended = [[HTLContentManager defaultManager] reportsExtendedWithCategory:category fromDate:self.fromDate toDate:self.toDate];
    NSTimeInterval totalTime = 0;
    for (HTLReportExtendedDto *reportExtended in reportsExtended) {
        totalTime += [reportExtended.report.endDate timeIntervalSinceDate:reportExtended.report.startDate];
    }

    return totalTime;
}

@end
