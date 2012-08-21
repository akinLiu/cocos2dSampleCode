//
//  Store.h
//  Mole It
//
//  Created by Todd Perkins on 4/21/11.
//  Copyright 2011 Wedgekase Games, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "cocos2d.h"

@interface Store : NSObject <SKProductsRequestDelegate,SKPaymentTransactionObserver,SKRequestDelegate,UIAlertViewDelegate> {
    NSString *currentPurchase;
    UIAlertView *alert;
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;
-(void)recordTransaction: (SKPaymentTransaction *)transaction;
-(void)provideContent: (NSString *)contentID;
-(void)makePurchase;
- (void) requestProductData;
- (void)hideAlert;
- (void)showAlert;

@end
