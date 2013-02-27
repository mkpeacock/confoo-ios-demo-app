//
//  MKPViewController.h
//  RunThrough1
//
//  Created by Michael Peacock on 26/02/2013.
//  Copyright (c) 2013 Michael ConFoo Demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>

@interface MKPViewController : UIViewController
@property (nonatomic, retain) IBOutlet UITextView *deliveryAddress;
@property (nonatomic, retain) IBOutlet UITextView *message;
@property (nonatomic, retain) NSString *tweetMessage;
-(IBAction)clickAddFromCamera;
-(IBAction)clickAddFromLibrary;
-(IBAction)clickTweet;
@end

