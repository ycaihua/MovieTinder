//
//  TTSwipeViewController.m
//  TravelTunes
//
//  Created by Matt Jarjoura on 5/18/15.
//  Copyright (c) 2015 Matt Jarjoura. All rights reserved.
//

#import "TTSwipeViewController.h"
#import "TTMovieListDataController.h"
#import "TTMovieCard.h"

@interface TTSwipeViewController () <TTMovieCardDelegate>

@end

@implementation TTSwipeViewController {
    @private
    NSInteger _remainingCards;
    NSInteger _totalCards;
    NSInteger _positionPointer;
    
    TTMovieCard *_card[3];
    
    UIButton *_yesButton;
    UIButton *_noButton;
}

- (instancetype)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self == nil)
        return nil;
    
    _dataController = [[TTMovieListDataController alloc] init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Should I Watch?";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupQuickButtons];
    [self setupConstraints];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listDataUpdated:) name:TTMovieListDataUpdated object:_dataController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardAnimationStarted:) name:TTMovieCardAnimationStarted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardAnimationEnded:) name:TTMovieCardAnimationFinished object:nil];
    
    [_dataController fetchTopListFromApple];
}

- (void)setupQuickButtons
{
    _yesButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_yesButton setTitle:@" Yes" forState:UIControlStateNormal];
    [_yesButton setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    [_yesButton addTarget:self action:@selector(yesButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    _yesButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    _noButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_noButton setTitle:@"  No" forState:UIControlStateNormal];
    [_noButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [_noButton addTarget:self action:@selector(noButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    _noButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:_yesButton];
    [self.view addSubview:_noButton];
}

- (void)setupConstraints
{
    UIView *view = self.view;
    NSDictionary *views = NSDictionaryOfVariableBindings(view, _yesButton, _noButton);
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_noButton]-44-|" options:0 metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-75-[_noButton]" options:0 metrics:nil views:views]];
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_yesButton]-44-|" options:0 metrics:nil views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_yesButton]-75-|" options:0 metrics:nil views:views]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark -

- (TTMovieCard *)topCard
{
    return _card[_positionPointer % 3];
}

- (void)listDataUpdated:(NSNotification *)notification
{
    NSArray *entries = _dataController.entries;
    _totalCards = [entries count];
    
    _card[0] = [[TTMovieCard alloc] initWithFrame:[self rectForCard]];
    _card[0].delegate = self;
    _card[0].position = TTMovieCardPosition1;
    _card[0].userInteractionEnabled = NO;
    
    _card[1] = [[TTMovieCard alloc] initWithFrame:[self rectForCard]];
    _card[1].delegate = self;
    _card[1].position = TTMovieCardPosition2;
    _card[1].userInteractionEnabled = NO;
    
    _card[2] = [[TTMovieCard alloc] initWithFrame:[self rectForCard]];
    _card[2].delegate = self;
    _card[2].position = TTMovieCardPosition3;
    _card[2].userInteractionEnabled = NO;
    
    [self.view insertSubview:_card[2] atIndex:0];
    [self.view insertSubview:_card[1] atIndex:1];
    [self.view insertSubview:_card[0] atIndex:2];

    _card[0].entry = entries[0];
    _card[1].entry = entries[1];
    _card[2].entry = entries[2];
    
    self.topCard.userInteractionEnabled = YES;
}

- (CGRect)rectForCard
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat topY = CGRectGetMidY(screen) - 32.f - 150.f;
    CGFloat leftX = CGRectGetMidX(screen) - 150.f;
    
    return CGRectMake(leftX, topY, 300.f, 300.f);
}

// to be called when we need to update the remaining cards
// in the stack
- (void)updateRemainingCardsFromCard:(TTMovieCard *)card
{
    _positionPointer++;
    if (_positionPointer < (_totalCards - 2)) {
        // haven't reached the end yet.
        NSArray *entries = _dataController.entries;
        
        [self.view sendSubviewToBack:card];
        [card prepareForReuse];
        card.entry = entries[_positionPointer + 2];
    }
    
    self.topCard.userInteractionEnabled = YES;
}

- (void)cardAnimationStarted:(NSNotification *)notification
{
    _yesButton.userInteractionEnabled = NO;
    _noButton.userInteractionEnabled = NO;
    self.topCard.userInteractionEnabled = NO;
}

- (void)cardAnimationEnded:(NSNotification *)notification
{
    _yesButton.userInteractionEnabled = YES;
    _noButton.userInteractionEnabled = YES;
}

#pragma mark - Events

- (void)yesButtonTapped:(id)sender
{
    if (_positionPointer < _totalCards) {
        [self.topCard moveCardToRight:TTMovieCardSpeedSlow];
    }
}

- (void)noButtonTapped:(id)sender
{
    if (_positionPointer < _totalCards) {
        [self.topCard moveCardToLeft:TTMovieCardSpeedSlow];
    }
}

- (void)userDraggedCardRight:(TTMovieCard *)card
{
    [self updateRemainingCardsFromCard:card];
}

- (void)userDraggedCardLeft:(TTMovieCard *)card
{
    [self updateRemainingCardsFromCard:card];
}

@end
