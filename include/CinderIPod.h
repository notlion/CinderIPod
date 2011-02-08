#pragma once

#include "cinder/Cinder.h"
#include "cinder/Surface.h"
#include "cinder/cocoa/CinderCocoaTouch.h"

#include <MediaPlayer/MediaPlayer.h>

#include <vector>
#include <string>
#include <ostream>

using std::string;
using std::vector;

namespace cinder { namespace ipod {

class Track {
public:

    Track();
    Track(MPMediaItem *media_item);
    ~Track();

    string   getTitle();
    string   getAlbumTitle();
    string   getArtist();

    uint64_t getAlbumId();
    uint64_t getArtistId();

    int      getPlayCount();
    double   getLength();

    Surface getArtwork(const Vec2i &size);

    MPMediaItem* getMediaItem(){
        return m_media_item;
    };

protected:

    MPMediaItem *m_media_item;

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
    void popLastTrack(){ m_tracks.pop_back(); };

    string getAlbumTitle();
    string getArtistName();

    TrackRef operator[](const int index){ return m_tracks[index]; };
    TrackRef firstTrack(){ return m_tracks.front(); };
    TrackRef lastTrack(){ return m_tracks.back(); };
    Iter   begin(){ return m_tracks.begin(); };
    Iter   end(){ return m_tracks.end(); };
    size_t size(){ return m_tracks.size(); };

    MPMediaItemCollection* getMediaItemCollection();

    vector<TrackRef> m_tracks;

};

typedef std::shared_ptr<Playlist> PlaylistRef;


PlaylistRef         getAllTracks();
PlaylistRef         getAlbum(uint64_t album_id);
vector<PlaylistRef> getAlbums();
vector<PlaylistRef> getAlbumsWithArtist(const string &artist_name);
vector<PlaylistRef> getArtists();

} } // namespace cinder::ipod
