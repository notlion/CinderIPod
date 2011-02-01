#include "CinderIPodPlayer.h"

namespace cinder { namespace ipod {


Player::Player()
{
    pod = [[CinderIPodPlayerImpl alloc] init: this];
}

Player::~Player()
{
    [pod dealloc];
}


void Player::play( PlaylistRef playlist, const int index )
{
    MPMediaItemCollection *collection = playlist->getMediaItemCollection();

    [pod->controller stop];
    [pod->controller setQueueWithItemCollection: collection];

    if(index > 0 && index < playlist->size())
        pod->controller.nowPlayingItem = [[collection items] objectAtIndex: index];

    [pod->controller play];
}

void Player::play( PlaylistRef playlist )
{
    play(playlist, 0);
}

void Player::stop()
{
    [pod->controller stop];
}


void Player::setPlayheadTime(double time)
{
    pod->controller.currentPlaybackTime = time;
}
double Player::getPlayheadTime()
{
    return pod->controller.currentPlaybackTime;
}


void Player::skipNext()
{
    [pod->controller skipToNextItem];
}

void Player::skipPrev()
{
    [pod->controller skipToPreviousItem];
}


void Player::setShuffleSongs()
{
    [pod->controller setShuffleMode: MPMusicShuffleModeSongs];
}
void Player::setShuffleAlbums()
{
    [pod->controller setShuffleMode: MPMusicShuffleModeAlbums];
}
void Player::setShuffleOff()
{
    [pod->controller setShuffleMode: MPMusicShuffleModeOff];
}


TrackRef Player::getPlayingTrack()
{
    return TrackRef(new Track(pod->controller.nowPlayingItem));
}

Player::State Player::getPlayState()
{
    return State(pod->controller.playbackState);
}


} } // namespace cinder::ipod
