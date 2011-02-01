#include "CinderIPod.h"

namespace cinder { namespace ipod {


// TRACK

Track::Track()
{
}
Track::Track(MPMediaItem *_media_item)
{
    media_item = [_media_item retain];
}
Track::~Track()
{
}

string Track::getTitle()
{
    return string([[media_item valueForProperty: MPMediaItemPropertyTitle] UTF8String]);
}
string Track::getAlbumTitle()
{
    return string([[media_item valueForProperty: MPMediaItemPropertyAlbumTitle] UTF8String]);
}
string Track::getArtist()
{
    return string([[media_item valueForProperty: MPMediaItemPropertyArtist] UTF8String]);
}

int Track::getPlayCount()
{
    return [[media_item valueForProperty: MPMediaItemPropertyPlayCount] intValue];
}

double Track::getLength()
{
    return [[media_item valueForProperty: MPMediaItemPropertyPlaybackDuration] doubleValue];
}

Surface Track::getArtwork(const Vec2i &size)
{
    MPMediaItemArtwork *artwork = [media_item valueForProperty: MPMediaItemPropertyArtwork];
    UIImage *artwork_img = [artwork imageWithSize: CGSizeMake(size.x, size.y)];

    if(artwork_img)
        return cocoa::convertUiImage(artwork_img, true);
    else
        return Surface();
}



// PLAYLIST

Playlist::Playlist()
{
}
Playlist::Playlist(MPMediaItemCollection *_media_collection)
{
    NSArray *items = [_media_collection items];
    for(MPMediaItem *item in items){
        pushTrack(new Track(item));
    }
}
Playlist::~Playlist()
{
}

void Playlist::pushTrack(TrackRef track)
{
    tracks.push_back(track);
}
void Playlist::pushTrack(Track *track)
{
    tracks.push_back(TrackRef(track));
}

string Playlist::getAlbumTitle()
{
    MPMediaItem *item = [getMediaItemCollection() representativeItem];
    return string([[item valueForProperty: MPMediaItemPropertyAlbumTitle] UTF8String]);
}

string Playlist::getArtistName()
{
    MPMediaItem *item = [getMediaItemCollection() representativeItem];
    return string([[item valueForProperty: MPMediaItemPropertyArtist] UTF8String]);
}

MPMediaItemCollection* Playlist::getMediaItemCollection()
{
    NSMutableArray *items = [NSMutableArray array];
    for(Iter it = tracks.begin(); it != tracks.end(); ++it){
        [items addObject: (*it)->getMediaItem()];
    }
    return [MPMediaItemCollection collectionWithItems:items];
}



// IPOD

PlaylistRef getAllTracks()
{
    MPMediaQuery *query = [MPMediaQuery songsQuery];

    PlaylistRef tracks = PlaylistRef(new Playlist());

    NSArray *items = [query items];
    for(MPMediaItem *item in items){
        tracks->pushTrack(new Track(item));
    }

    return tracks;
}

PlaylistRef getAlbum(const string &album_title)
{
    MPMediaQuery *query = [[MPMediaQuery init] alloc];
    [query addFilterPredicate: [MPMediaPropertyPredicate
           predicateWithValue: [NSString stringWithUTF8String: album_title.c_str()]
                  forProperty: MPMediaItemPropertyAlbumTitle
    ]];

    PlaylistRef tracks = PlaylistRef(new Playlist());

    NSArray *items = [query items];
    for(MPMediaItem *item in items){
        tracks->pushTrack(new Track(item));
    }

    return tracks;
}

vector<PlaylistRef> getAlbums()
{
    MPMediaQuery *query = [MPMediaQuery albumsQuery];

    vector<PlaylistRef> albums;

    NSArray *query_groups = [query collections];
    for(MPMediaItemCollection *group in query_groups){
        PlaylistRef album = PlaylistRef(new Playlist(group));
        albums.push_back(album);
    }

    return albums;
}

vector<PlaylistRef> getAlbumsWithArtist(const string &artist_name)
{
    MPMediaQuery *query = [[MPMediaQuery alloc] init];
    [query addFilterPredicate: [MPMediaPropertyPredicate
           predicateWithValue: [NSString stringWithUTF8String: artist_name.c_str()]
                  forProperty: MPMediaItemPropertyArtist
    ]];
    [query setGroupingType: MPMediaGroupingAlbum];

    vector<PlaylistRef> albums;

    NSArray *query_groups = [query collections];
    for(MPMediaItemCollection *group in query_groups){
        PlaylistRef album = PlaylistRef(new Playlist(group));
        albums.push_back(album);
    }

    return albums;
}

vector<PlaylistRef> getArtists()
{
    MPMediaQuery *query = [MPMediaQuery artistsQuery];

    vector<PlaylistRef> artists;

    NSArray *query_groups = [query collections];
    for(MPMediaItemCollection *group in query_groups){
        PlaylistRef artist = PlaylistRef(new Playlist(group));
        artists.push_back(artist);
    }

    return artists;
}

} } // namespace cinder::ipod
