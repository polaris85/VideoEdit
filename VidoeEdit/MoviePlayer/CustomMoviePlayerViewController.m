//
//  CustomMoviePlayerViewController.m
//
//  Copyright iOSDeveloperTips.com All rights reserved.
//

#import "CustomMoviePlayerViewController.h"

#pragma mark -
#pragma mark Compiler Directives & Static Variables

@implementation CustomMoviePlayerViewController

/*---------------------------------------------------------------------------
* 
*--------------------------------------------------------------------------*/
- (id)initWithPath:(NSString *)moviePath
{
	// Initialize and create movie URL
  if (self = [super init])
  {
      NSURL    *fileURL    =   [NSURL fileURLWithPath:moviePath];
      
	  movieURL = fileURL;
      [movieURL retain];
  }
	return self;
}

/*---------------------------------------------------------------------------
* For 3.2 and 4.x devices
* For 3.1.x devices see moviePreloadDidFinish:
*--------------------------------------------------------------------------*/
- (void) moviePlayerLoadStateChanged:(NSNotification*)notification 
{
	// Unless state is unknown, start playback
    
  if ([mp loadState] != MPMovieLoadStateUnknown)
  {
  	// Remove observer
      
    [[NSNotificationCenter 	defaultCenter] 
    												removeObserver:self
                         		name:MPMoviePlayerLoadStateDidChangeNotification 
                         		object:nil];

      
        CGRect screensize = [[UIScreen mainScreen]bounds];
      [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeRight];
      [[mp view] setFrame:CGRectMake(0, 0, screensize.size.height, screensize.size.width)];

	  [[self view] addSubview:[mp view]];

		// Play the movie
		[mp play];
	}
}

/*---------------------------------------------------------------------------
* For 3.1.x devices
* For 3.2 and 4.x see moviePlayerLoadStateChanged: 
*--------------------------------------------------------------------------*/
- (void) moviePreloadDidFinish:(NSNotification*)notification 
{
	// Remove observer
	[[NSNotificationCenter 	defaultCenter] 
													removeObserver:self
                        	name:MPMoviePlayerContentPreloadDidFinishNotification
                        	object:nil];

	// Play the movie
 	[mp play];
}

/*---------------------------------------------------------------------------
* 
*--------------------------------------------------------------------------*/
- (void) moviePlayBackDidFinish:(NSNotification*)notification 
{    
  [[UIApplication sharedApplication] setStatusBarHidden:NO];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	
	   

//	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

	

 	// Remove observer
  [[NSNotificationCenter 	defaultCenter] 
  												removeObserver:self
  		                   	name:MPMoviePlayerPlaybackDidFinishNotification 
      		               	object:nil];

  [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationIsPortrait(YES)];
  [self dismissModalViewControllerAnimated:NO];
    
    
  [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortrait];
 }

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation{
    
    return YES;
}
- (void) didRotate
{
    CGRect screensize = [[UIScreen mainScreen]bounds];
    
    
    
    if(screensize.size.height==480)
    {
        [[self view] setBounds:CGRectMake(0, 0, 320, 480)];
		//[[self view] setCenter:CGPointMake(160, 240)];
		[[self view] setTransform:CGAffineTransformMakeRotation((-M_PI) / 2)];
        
    }
    else
    {
        [[self view] setBounds:CGRectMake(0, 0, 320, 568)];
        //[[self view] setCenter:CGPointMake(160, 284)];
        [[self view] setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
        
    }

}
/*---------------------------------------------------------------------------
*
*--------------------------------------------------------------------------*/
- (void) readyPlayer
{

	
	NSLog(@"xxxxccc=%@",movieURL);
//   
//   movieURL=[NSURL URLWithString:@"http://players.edgesuite.net/videos/big_buck_bunny/bbb_448x252.mp4"];
 	mp =  [[MPMoviePlayerController alloc] initWithContentURL:movieURL];

  if ([mp respondsToSelector:@selector(loadState)]) 
  {
  	// Set movie player layout
  	[mp setControlStyle:MPMovieControlStyleFullscreen];
    [mp setFullscreen:YES];

		// May help to reduce latency
		[mp prepareToPlay];

		// Register that the load state changed (movie is ready)
		[[NSNotificationCenter defaultCenter] addObserver:self 
                       selector:@selector(moviePlayerLoadStateChanged:) 
                       name:MPMoviePlayerLoadStateDidChangeNotification 
                       object:nil];
	}  
  else
  {
    // Register to receive a notification when the movie is in memory and ready to play.
    [[NSNotificationCenter defaultCenter] addObserver:self 
                         selector:@selector(moviePreloadDidFinish:) 
                         name:MPMoviePlayerContentPreloadDidFinishNotification 
                         object:nil];
  }

  // Register to receive a notification when the movie has finished playing. 
  [[NSNotificationCenter defaultCenter] addObserver:self 
                        selector:@selector(moviePlayBackDidFinish:) 
                        name:MPMoviePlayerPlaybackDidFinishNotification 
                        object:nil];
}

/*---------------------------------------------------------------------------
* 
*--------------------------------------------------------------------------*/
- (void) loadView
{
  [self setView:[[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease]];
	[[self view] setBackgroundColor:[UIColor blackColor]];
}

/*---------------------------------------------------------------------------
*  
*--------------------------------------------------------------------------*/
- (void)dealloc 
{
//	[mp release];
  [movieURL release];
	[super dealloc];
}

@end
