#include "CinderIPodPlayer.h"

namespace cinder { namespace ipod {


Player::Player()
{
    m_pod = [[CinderIPodPlayerImpl alloc] init: this];
}

Player::~Player()
{
    [m_pod dealloc];
}
	
//void Player::play( TrackRef track )
//{
//	[m_pod->m_controller stop];
//	m_pod->m_controller.nowPlayingItem = track->getMediaItem();
//	[m_pod->m_controller play];
//}

void Player::play( PlaylistRef playlist, const int index )
{
    MPMediaItemCollection *collection = playlist->getMediaItemCollection();

    [m_pod->m_controller stop];
    [m_pod->m_controller setQueueWithItemCollection: collection];

    if(index > 0 && index < playlist->size())
        m_pod->m_controller.nowPlayingItem = [[collection items] objectAtIndex: index];

	[m_pod->m_controller play];
}

void Player::play( PlaylistRef playlist )
{
    play(playlist, 0);
}

void Player::play() 
{
	[m_pod->m_controller play];
}
void Player::pause() 
{
	[m_pod->m_controller pause];
}
void Player::stop()
{
    [m_pod->m_controller stop];
}


void Player::setPlayheadTime(double time)
{
    m_pod->m_controller.currentPlaybackTime = time;
}
double Player::getPlayheadTime()
{
    return m_pod->m_controller.currentPlaybackTime;
}


void Player::skipNext()
{
    [m_pod->m_controller skipToNextItem];
}

void Player::skipPrev()
{
    [m_pod->m_controller skipToPreviousItem];
}


void Player::setShuffleSongs()
{
    [m_pod->m_controller setShuffleMode: MPMusicShuffleModeSongs];
}
void Player::setShuffleAlbums()
{
    [m_pod->m_controller setShuffleMode: MPMusicShuffleModeAlbums];
}
void Player::setShuffleOff()
{
    [m_pod->m_controller setShuffleMode: MPMusicShuffleModeOff];
}

bool Player::hasPlayingTrack()
{
    return m_pod->m_controller.nowPlayingItem != Nil;
}

TrackRef Player::getPlayingTrack()
{
    return TrackRef(new Track(m_pod->m_controller.nowPlayingItem));
}

Player::State Player::getPlayState()
{
    return State(m_pod->m_controller.playbackState);
}


} } // namespace cinder::ipod
