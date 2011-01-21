#pragma once

#include "CinderIPodPlayerImpl.h"
#include "CinderIPod.h"

namespace cinder { namespace ipod {

class Player {
public:

    enum State {
        STOPPED          = MPMusicPlaybackStateStopped,
        PLAYING          = MPMusicPlaybackStatePlaying,
        PAUSED           = MPMusicPlaybackStatePaused,
        INTERRUPTED      = MPMusicPlaybackStateInterrupted,
        SEEKING_FORWARD  = MPMusicPlaybackStateSeekingForward,
        SEEKING_BACKWARD = MPMusicPlaybackStateSeekingBackward
    };

    Player();
    ~Player();

    void play( PlaylistRef playlist );
    void play( PlaylistRef playlist, const int index );
    void skipNext();
    void skipPrev();

    void setShuffleSongs();
    void setShuffleAlbums();
    void setShuffleOff();

    TrackRef getPlayingTrack();
    double   getPlaybackTime();
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
