//
//  ViewController.m
//  Xcode Retina Icon Creator
//
//  Created by Johannes Dürr on 17.01.15.
//  Copyright (c) 2015 Johannes Dürr. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)imageWellAction:(id)sender {
    // something with the image happened. Lets see if we have one or not
    if (self.imageWell.image != nil) {

        [self saveImagesforImage:self.imageWell.image andFolderName:@"icons"];
    }else{

    }
}

- (void)saveImagesforImage:(NSImage*)img andFolderName:(NSString*)folderName{
    
    // received image?
    BOOL gotImage = FALSE;
    
    if (img != nil) {
        gotImage = TRUE;
    }
    
    // create the save panel
    NSSavePanel *panel = [NSSavePanel savePanel];
    
    // set a new file name
    [panel setNameFieldStringValue:folderName];
    
    // display the panel
    [panel beginSheetModalForWindow:[[self view]window] completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSFileManager* fm = [NSFileManager defaultManager];
            NSError* err = nil;
            NSURL *saveURL = [panel URL];
            if (folderName != nil && [folderName length]>0) {
                NSString *filePathComponent = [saveURL lastPathComponent];
                saveURL = [saveURL URLByDeletingLastPathComponent];
                saveURL = [saveURL URLByAppendingPathComponent:folderName];
                [fm createDirectoryAtURL:saveURL withIntermediateDirectories:YES attributes:nil error:&err];
                saveURL = [saveURL URLByAppendingPathComponent:filePathComponent];
                
                if (err) {
                    // Alarm user --> Folder cannot be created...
                    NSAlert* alert = [NSAlert alertWithError:err];
                    [alert runModal];
                }
            }
            err = nil;
            
            // now - lets create the images and save them
            
            NSData* imageData;
            NSMutableArray* dataArray = [[NSMutableArray alloc]init];
            NSMutableArray* fileNameArray = [[NSMutableArray alloc]init];
                
            // 512 @2x
            imageData = [self imageByScalingProportionallyToSize:1024 onImage:img];
            [dataArray addObject:imageData];
            [fileNameArray addObject:@"icon_512x512@2x.png"];
            
            // 512
            imageData = [self imageByScalingProportionallyToSize:512 onImage:img];
            [dataArray addObject:imageData];
            [fileNameArray addObject:@"icon_512x512.png"];
            
            // 256 @2x
            imageData = [self imageByScalingProportionallyToSize:512 onImage:img];
            [dataArray addObject:imageData];
            [fileNameArray addObject:@"icon_256x256@2x.png"];
            
            // 256 
            imageData = [self imageByScalingProportionallyToSize:256 onImage:img];
            [dataArray addObject:imageData];
            [fileNameArray addObject:@"icon_256x256.png"];
            
            // 128 @2x
            imageData = [self imageByScalingProportionallyToSize:256 onImage:img];
            [dataArray addObject:imageData];
            [fileNameArray addObject:@"icon_128x128@2x.png"];
            
            // 128
            imageData = [self imageByScalingProportionallyToSize:128 onImage:img];
            [dataArray addObject:imageData];
            [fileNameArray addObject:@"icon_128x128.png"];
            
            // 32 @2x
            imageData = [self imageByScalingProportionallyToSize:64 onImage:img];
            [dataArray addObject:imageData];
            [fileNameArray addObject:@"icon_32x32@2x.png"];
            
            // 32
            imageData = [self imageByScalingProportionallyToSize:32 onImage:img];
            [dataArray addObject:imageData];
            [fileNameArray addObject:@"icon_32x32.png"];
            
            // 16 @2x
            imageData = [self imageByScalingProportionallyToSize:32 onImage:img];
            [dataArray addObject:imageData];
            [fileNameArray addObject:@"icon_16x16@2x.png"];
            
            // 16
            imageData = [self imageByScalingProportionallyToSize:16 onImage:img];
            [dataArray addObject:imageData];
            [fileNameArray addObject:@"icon_16x16.png"];
                
            
            for (int i = 0; i<[dataArray count]; i++) {
                NSURL* tmpURL = [saveURL URLByDeletingLastPathComponent];
                tmpURL = [tmpURL URLByAppendingPathComponent:[fileNameArray objectAtIndex:i]];
                [[dataArray objectAtIndex:i]writeToURL:tmpURL atomically:YES];
            }
        }
    }];
}


- (NSData*)imageByScalingProportionallyToSize:(float)theWidth onImage:(NSImage*)sourceImage{
    
    NSImage* newImage = nil;
    NSSize targetSize = NSSizeFromCGSize(CGSizeMake(theWidth, theWidth));
    if ([sourceImage isValid])
    {
        NSSize imageSize = [sourceImage size];
        float width  = imageSize.width;
        float height = imageSize.height;
        float targetWidth  = targetSize.width;
        float targetHeight = targetSize.height;
        float scaleFactor  = 0.0;
        float scaledWidth  = targetWidth;
        float scaledHeight = targetHeight;
        NSPoint thumbnailPoint = NSZeroPoint;
        if ( NSEqualSizes( imageSize, targetSize ) == NO )
        {
            float widthFactor  = targetWidth / width;
            scaleFactor = widthFactor;
            
            // Take care of retina machines
            CGFloat f_scaleFactor = [[self.view window]backingScaleFactor];
            scaledWidth  = width  * scaleFactor / f_scaleFactor;
            scaledHeight = height * scaleFactor / f_scaleFactor;
        }
        newImage = [[NSImage alloc] initWithSize:CGSizeMake(scaledWidth, scaledHeight)];
        [newImage lockFocus];
        NSRect thumbnailRect;
        thumbnailRect.origin = thumbnailPoint;
        thumbnailRect.size.width = scaledWidth;
        thumbnailRect.size.height = scaledHeight;
        [sourceImage drawInRect: thumbnailRect
                       fromRect: NSZeroRect
                      operation: NSCompositeSourceOver
                       fraction: 1.0];
        [newImage unlockFocus];
    }
    [newImage lockFocus] ;
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0.0, 0.0, [newImage size].width, [newImage size].height)] ;
    [newImage unlockFocus] ;
    NSData *data = [bitmapRep representationUsingType: NSPNGFileType properties: nil];
    
    return data;
}

@end
