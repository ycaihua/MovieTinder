//
//  TTSwipeViewController.h
//  TravelTunes
//
//  Created by Matt Jarjoura on 5/18/15.
//  Copyright (c) 2015 Matt Jarjoura. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTMovieListDataController;

@interface TTSwipeViewController : UIViewController

@property (nonatomic, readonly) TTMovieListDataController *dataController;

@end
