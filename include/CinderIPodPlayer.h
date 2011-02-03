#pragma once

#include "CinderIPodPlayerImpl.h"
#include "CinderIPod.h"

namespace cinder { namespace ipod {

class Player {
public:

    enum State {
        StateStopped         = MPMusicPlaybackStateStopped,
        StatePlaying         = MPMusicPlaybackStatePlaying,
        StatePaused          = MPMusicPlaybackStatePaused,
        StateInterrupted     = MPMusicPlaybackStateInterrupted,
        StateSeekingForward  = MPMusicPlaybackStateSeekingForward,
        StateSeekingBackward = MPMusicPlaybackStateSeekingBackward
    };

    Player();
    ~Player();

    void play( PlaylistRef playlist );
    void play( PlaylistRef playlist, const int index );
    void stop();
    void skipNext();
    void skipPrev();

    void   setPlayheadTime(double time);
    double getPlayheadTime();

    void setShuffleSongs();
    void setShuffleAlbums();
    void setShuffleOff();

    TrackRef getPlayingTrack();
    State    getPlayState();

    template<typename T>
    CallbackId registerTrackChanged( T *obj, bool (T::*callback)(Player*) ){
        return pod->cb_track_change.registerCb(std::bind1st(std::mem_fun(callback), obj));
    }
    template<typename T>
    CallbackId registerStateChanged( T *obj, bool (T::*callback)(Player*) ){
        return pod->cb_state_change.registerCb(std::bind1st(std::mem_fun(callback), obj));
    }

protected:

    CinderIPodPlayerImpl *pod;

};

} } // namespace cinder::ipod
