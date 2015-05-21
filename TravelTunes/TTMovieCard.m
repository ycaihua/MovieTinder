//
//  TTMovieCard.m
//  TravelTunes
//
//  Created by Matt Jarjoura on 5/18/15.
//  Copyright (c) 2015 Matt Jarjoura. All rights reserved.
//

#import "TTMovieCard.h"
#import "TTEntry.h"
#import "TTImageView.h"
#import <tgmath.h>

const CGFloat kDistanceToTrigger = 60.f;
const CGFloat kDistanceOffScreen = 640.f;

NSString * const TTMovieCardAnimationStarted = @"TTMovieCardAnimationStarted";
NSString * const TTMovieCardAnimationFinished = @"TTMovieCardAnimationFinished";

@implementation TTMovieCard {
    @private
    TTImageView *_posterImage;
    UILabel *_titleLabel;
    UILabel *_summaryLabel;
    
    CGPoint _originalCenter;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;
    
    self.layer.borderWidth = 0.5f;
    self.layer.cornerRadius = 2.f;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(1.f, 1.f);
    self.layer.shadowOpacity = 0.2f;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
    
    _originalCenter = self.center;
    
    /* movie poster */
    _posterImage = [[TTImageView alloc] initWithFrame:CGRectZero];
    _posterImage.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_posterImage];
    
    /* movie title */
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(128.f, 8.f, 163.f, 170.f)];
    _titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _titleLabel.numberOfLines = 4;
    [self addSubview:_titleLabel];
    
    // Would prefer to use TextKit here to get spacing and support more dynamic layout
    
    /* description */
    _summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.f, 186.f, 284.f, 100.f)];
    _summaryLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    _summaryLabel.numberOfLines = 6;  // <-- should be calculated based on user's preferred font
    _summaryLabel.textColor = [UIColor grayColor];
    [self addSubview:_summaryLabel];
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDragging:)];
    
    [self setupConstraints];
    [self addGestureRecognizer:_panGestureRecognizer];
    
    self.backgroundColor = [UIColor whiteColor];
    
    return self;
}

- (void)setupConstraints
{
    UIView *view = self;
    NSDictionary *views = NSDictionaryOfVariableBindings(view, _posterImage);
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_posterImage(170)]" options:0 metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_posterImage(113)]" options:0 metrics:nil views:views]];
}

- (void)panGestureDragging:(UIPanGestureRecognizer *)recoginizer
{
    CGPoint point = [recoginizer translationInView:self];
    
    switch (recoginizer.state) {
        case UIGestureRecognizerStateChanged:
            [self transformWithPoint:point];
            break;
        case UIGestureRecognizerStateEnded:
            [self validateSwipeDistanceFromCenter:point];
            break;
        default:
            /* unhandled state */
            break;
    }
}

- (void)transformWithPoint:(CGPoint)delta
{
    CGFloat deltaX = delta.x;
    CGFloat deltaY = delta.y;
    
    self.center = CGPointMake(_originalCenter.x + deltaX, _originalCenter.y + deltaY);
    
    // would love to add resistence here
    CGFloat drag = MIN(deltaX / 360, M_PI / 3.f);
    CGFloat rotation = ((M_PI / 8) * drag);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformMakeRotation(rotation);
    self.transform = transform;
}

// As the user starts the move the swipe off-screen, it should trigger an event
- (void)validateSwipeDistanceFromCenter:(CGPoint)delta
{
    CGFloat deltaX = delta.x;
    
    if (deltaX > kDistanceToTrigger) {
        // user moves enough to the right, should trigger yes
        [self moveCardToRight:TTMovieCardSpeedFast];
    } else if (deltaX < -(kDistanceToTrigger)) {
        // user moves enough to the left, should trigger no
        [self moveCardToLeft:TTMovieCardSpeedFast];
    } else {
        // restore all translation back to center
        [self resetCardToIdentity];
    }
}

- (void)prepareForReuse
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.center = _originalCenter;
    self.transform = CGAffineTransformIdentity;
    [CATransaction commit];
    
    _posterImage.image = nil;
}

- (void)moveCardToRight:(TTMovieCardSpeed)speed
{
    CGFloat duration = (speed == TTMovieCardSpeedFast) ? 0.6f : 1.f;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TTMovieCardAnimationStarted object:self];
    [UIView animateWithDuration:duration delay:0.f usingSpringWithDamping:1.f initialSpringVelocity:1.f options:0 animations:^{
        self.transform = CGAffineTransformMakeRotation(M_PI / 3.f);
        self.center = CGPointMake(kDistanceOffScreen, _originalCenter.y);
    } completion:^(BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:TTMovieCardAnimationFinished object:self];

            if (_delegate && [_delegate respondsToSelector:@selector(userDraggedCardRight:)]) {
                [_delegate userDraggedCardRight:self];
            }
        });
    }];
}

- (void)moveCardToLeft:(TTMovieCardSpeed)speed
{
    CGFloat duration = (speed == TTMovieCardSpeedFast) ? 0.6f : 1.f;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TTMovieCardAnimationStarted object:self];
    [UIView animateWithDuration:duration delay:0.f usingSpringWithDamping:1.f initialSpringVelocity:1.f options:0 animations:^{
        self.transform = CGAffineTransformMakeRotation(-(M_PI / 3.f));
        self.center = CGPointMake(-(kDistanceOffScreen), _originalCenter.y);
    } completion:^(BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:TTMovieCardAnimationFinished object:self];

            if (_delegate && [_delegate respondsToSelector:@selector(userDraggedCardLeft:)]) {
                [_delegate userDraggedCardLeft:self];
            }
        });
    }];
}

- (void)resetCardToIdentity
{
    [UIView animateWithDuration:0.3f delay:0.f usingSpringWithDamping:1.f initialSpringVelocity:1.f options:0 animations:^{
        self.center = _originalCenter;
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark -

- (void)setEntry:(TTEntry *)entry
{
    if (_entry != entry) {
        _entry = entry;
        
        [_posterImage downloadImageURL:_entry.thumbnail];
        
        // reset this to manual frame and then size to fit
        _titleLabel.text = _entry.label;
        _titleLabel.frame = CGRectMake(128.f, 8.f, 163.f, 170.f);
        [_titleLabel sizeToFit];
        
        _summaryLabel.text = _entry.summary;
        _summaryLabel.frame = CGRectMake(8.f, 186.f, 284.f, 100.f);
        [_summaryLabel sizeToFit];
    }
}

@end
