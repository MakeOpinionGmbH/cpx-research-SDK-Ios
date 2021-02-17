    //
    //  ViewController.m
    //  TestProject
    //
    //  Created by Daniel Fredrich on 16.02.21.
    //

#import "ViewController.h"
@import CPXResearch;

@interface ViewController () <CPXResearchDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CPXResearch.shared.delegate = self;
    [CPXResearch.shared setSurveyWithVisible:YES];
}

- (void)onSurveysDidClose {
    NSLog(@"Did close survey list.");
}

- (void)onSurveysDidOpen {
    NSLog(@"Did open survey list.");
}

- (void)onSurveysUpdatedWithNew:(NSArray<SurveyItem *> * _Nonnull)new_
                        updated:(NSArray<SurveyItem *> * _Nonnull)updated
                        removed:(NSArray<SurveyItem *> * _Nonnull)removed {
    NSLog(@"New surveys received.");
}

- (void)onTransactionsUpdatedWithUnpaidTransactions:(NSArray<TransactionModel *> * _Nonnull)unpaidTransactions {
    NSLog(@"New unpaid transactions received.");
}

@end
