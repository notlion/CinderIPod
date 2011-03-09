#import "CinderIPodPlayerImpl.h"

#include "CinderIPodPlayer.h"

@implementation CinderIPodPlayerImpl

- (id)init:(cinder::ipod::Player*)player
{
    self = [super init];

    m_player = player;
    m_controller = [MPMusicPlayerController iPodMusicPlayer];

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver: self
           selector: @selector (onStateChanged:)
               name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
             object: m_controller];

    [nc addObserver: self
           selector: @selector (onTrackChanged:)
               name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
             object: m_controller];

    [m_controller beginGeneratingPlaybackNotifications];

    return self;
}
- (void)dealloc
{
    [super dealloc];
    [m_controller dealloc];
}

- (void)onStateChanged:(NSNotification *)notification
{
    m_cb_state_change.call(m_player);
}

- (void)onTrackChanged:(NSNotification *)notification
{
    m_cb_track_change.call(m_player);
}

@end
