//
//  StoreManager.h
//  MKSync
//
//  Created by Mugunth Kumar on 17-Oct-09.
//  Copyright 2009 MK Inc. All rights reserved.
//  mugunthkumar.com

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "MKStoreObserver.h"

@protocol MKStoreKitDelegate <NSObject>
@optional
- (void)productPurchased:(NSString *)productId;
@end

@interface MKStoreManager : NSObject<SKProductsRequestDelegate> {

	NSMutableArray *purchasableObjects;
	MKStoreObserver *storeObserver;	
	
}

@property (nonatomic, retain) NSMutableArray *purchasableObjects;
@property (nonatomic, retain) MKStoreObserver *storeObserver;

- (void) requestProductData;

- (BOOL) canCurrentDeviceUseFeature: (NSString*) featureID;
- (void) buyMag:(NSString*) featureId;// expose product buying functions, do not expose

// do not call this directly. This is like a private method
- (void) buyFeature:(NSString*) featureId;

- (void) failedTransaction: (SKPaymentTransaction *)transaction;
-(void) provideContent: (NSString*) productIdentifier shouldSerialize: (BOOL) serialize;

+ (MKStoreManager*)sharedManager;

+ (BOOL) magPurchased;
+ (BOOL) FlashPurchased;
+ (BOOL) TFPurchased;
+ (BOOL) SAPurchased;
+ (BOOL) EMPurchased;

//DELEGATES
+(id)delegate;	
+(void)setDelegate:(id)newDelegate;
- (void) buyMag:(NSString *)productid;

@end
