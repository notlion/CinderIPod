#pragma once

#include "cinder/Cinder.h"
#include "cinder/Surface.h"
#include "cinder/cocoa/CinderCocoaTouch.h"
#include <vector>
#include <string>
#include <ostream>

#include <MediaPlayer/MediaPlayer.h>

using std::string;
using std::vector;

namespace cinder { namespace ipod {


class Track {
public:

    Track();
    Track(MPMediaItem *_media_item);
    ~Track();

    string getTitle();
    string getArtist();

    Surface getArtwork(const Vec2i &size);

    MPMediaItem* getMediaItem(){
        return media_item;
    };

protected:

    MPMediaItem *media_item;
};

typedef std::shared_ptr<Track> TrackRef;


class Playlist {
public:

    typedef vector<TrackRef>::iterator Iter;

    Playlist();
    Playlist(MPMediaItemCollection *collection);
    ~Playlist();

    void pushTrack(TrackRef track);
    void pushTrack(Track *track);

    string getAlbumTitle();
	string getArtistName();

    TrackRef operator[](const int index){ return tracks[index]; };
    Iter begin(){ return tracks.begin(); };
    Iter end(){ return tracks.end(); };
    size_t size(){ return tracks.size(); };

    MPMediaItemCollection* getMediaItemCollection();

    vector<TrackRef> tracks;
};
typedef std::shared_ptr<Playlist> PlaylistRef;


class Player {
public:

    Player();
    ~Player();

    void play(PlaylistRef playlist);
    void play(PlaylistRef playlist, const int index);

protected:

    MPMusicPlayerController *controller;

};


PlaylistRef         getAllTracks();
vector<PlaylistRef> getAlbums();
vector<PlaylistRef> getAlbumsWithArtist(const string &artist_name);
vector<PlaylistRef> getArtists();

}}
