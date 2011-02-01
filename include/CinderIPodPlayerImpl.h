#pragma once

#include "cinder/Function.h"
#include "CinderIPod.h"

#import <MediaPlayer/MediaPlayer.h>

namespace cinder { namespace ipod {
    class Player;
} }

@interface CinderIPodPlayerImpl : NSObject {
@public
    MPMusicPlayerController *controller;
    MPMediaItem             *playing_item;

    cinder::ipod::Player    *player;

    cinder::CallbackMgr<bool(cinder::ipod::Player*)> cb_state_change;
    cinder::CallbackMgr<bool(cinder::ipod::Player*)> cb_track_change;
}

-(id)init:(cinder::ipod::Player*)_player;
-(void)onStateChanged:(NSNotification *)notification;
-(void)onTrackChanged:(NSNotification *)notification;

@end
