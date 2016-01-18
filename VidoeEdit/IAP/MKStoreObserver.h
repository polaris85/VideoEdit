//
//  MKStoreObserver.m
//
//  Created by Mugunth Kumar on 17-Oct-09.
//  Copyright 2009 Mugunth Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#define kFilename		@"data.plist"
UIKIT_EXTERN NSString *const MKStoreObserverProductPurchasedNotification;
@interface MKStoreObserver : NSObject<SKPaymentTransactionObserver> {
	NSMutableArray *arrayRet;

	NSString *FlashLevel;
	NSString *TFLevel;
	NSString *SALevel;
	NSString *EMLevel;
    BOOL isRestoring;
	
}

@property (nonatomic, retain) NSMutableArray *arrayRet;
@property (nonatomic, retain) NSString *FlashLevel;
@property (nonatomic, retain) NSString *TFLevel;
@property (nonatomic, retain) NSString *SALevel;
@property (nonatomic, retain) NSString *EMLevel;

- (NSString *)dataFilePath;

	
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;
- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;
+ (id)sharedObject;


@end
