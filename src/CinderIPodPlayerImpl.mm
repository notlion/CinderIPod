#import "CinderIPodPlayerImpl.h"

#include "CinderIPodPlayer.h"

@implementation CinderIPodPlayerImpl

- (id)init:(cinder::ipod::Player*)_player
{
    self = [super init];

    player = _player;
    controller = [MPMusicPlayerController iPodMusicPlayer];

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver: self
           selector: @selector (onStateChanged:)
               name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
             object: controller];

    [nc addObserver: self
           selector: @selector (onTrackChanged:)
               name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
             object: controller];

    [controller beginGeneratingPlaybackNotifications];

    return self;
}
- (void)dealloc
{
    [super dealloc];
    [controller dealloc];
}

- (void)onStateChanged:(NSNotification *)notification
{
    cb_state_change.call(player);
}

- (void)onTrackChanged:(NSNotification *)notification
{
    cb_track_change.call(player);
}

@end
