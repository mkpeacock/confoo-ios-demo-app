//
//  MKPViewController.m
//  RunThrough1
//
//  Created by Michael Peacock on 26/02/2013.
//  Copyright (c) 2013 Michael ConFoo Demo. All rights reserved.
//

#import "MKPViewController.h"
#import "ASIFormDataRequest.h"
@interface MKPViewController ()

@end

@implementation MKPViewController
@synthesize deliveryAddress, message;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView: NO];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard
{
    [deliveryAddress resignFirstResponder];
    [message resignFirstResponder];
}

- (IBAction)clickAddFromLibrary
{
    NSLog(@"Clicked add from library");
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

- (IBAction)clickAddFromCamera
{
    NSLog(@"Clicked add from camera");
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        [self presentModalViewController:picker animated:YES];
        [picker release];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error" message:@"error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}
- (IBAction)clickTweet
{
    NSLog(@"Clicked tweet");
    TWTweetComposeViewController *tweet = [[TWTweetComposeViewController alloc] init];
    [tweet setInitialText:self.tweetMessage];
    [self presentViewController:tweet animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissModalViewControllerAnimated:YES];
    NSURL *url = [NSURL URLWithString:@"http://server/ios/endpoint.php"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    
    [request setPostValue:deliveryAddress.text forKey:@"delivery"];
    [request setPostValue:message.text forKey:@"message"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
    [request addData:imageData withFileName:@"image.jpg" andContentType:@"image/jpeg" forKey:@"photo"];
    [request startSynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSError *error;
    NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *name = [json objectForKey:@"to"];
    self.tweetMessage = [NSString stringWithFormat:@"I just sent a postcard to %@ using Confoo App", name];
    NSLog(self.tweetMessage);

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
