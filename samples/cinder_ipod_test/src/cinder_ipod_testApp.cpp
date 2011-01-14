#include "cinder/app/AppCocoaTouch.h"
#include "cinder/gl/Texture.h"
#include "cinder/Text.h"

#include "CinderIPod.h"

using namespace ci;
using namespace ci::app;
using namespace std;


class cinder_ipod_testApp : public AppCocoaTouch {
  public:
	virtual void setup();
	virtual void update();
	virtual void draw();

    ipod::Player player;

	vector<gl::Texture> tex;
};


void cinder_ipod_testApp::setup()
{
    vector<ipod::PlaylistRef> albums = ipod::getAlbums();

	int i = 0;
    for(vector<ipod::PlaylistRef>::iterator it = albums.begin(); it != albums.end() && i++ < 100; ++it){
        ipod::PlaylistRef &album = *it;

        console() << album->getAlbumTitle() << endl;

        Surface8u art = (*album)[0]->getArtwork(Vec2i(128, 128));
        if(art)
            tex.push_back(gl::Texture(art));
    }

    string first_artist = albums[0]->getArtistName();
    console() << endl << "Albums by " << first_artist << ":" << endl;
    vector<ipod::PlaylistRef> artist_albums = ipod::getAlbumsWithArtist(first_artist);
    for(vector<ipod::PlaylistRef>::iterator it = artist_albums.begin(); it != artist_albums.end(); ++it){
        console() << (*it)->getAlbumTitle() << endl;
    }

    player.play(albums[0], 1);
}

void cinder_ipod_testApp::update()
{
}

void cinder_ipod_testApp::draw()
{
    gl::clear(Color(0,0,0));
    gl::setMatricesWindow(getWindowSize(), true);
    float x = 0, y = 0;
    for(vector<gl::Texture>::iterator it = tex.begin(); it != tex.end(); ++it){
    	glPushMatrix();
        glTranslatef(x, y, 0);
        gl::draw(*it);
        glPopMatrix();
        x += it->getWidth();
        if(x > getWindowWidth()){
            x = 0;
            y += it->getHeight();
        }
        if(y > getWindowHeight())
            break;
    }
}


CINDER_APP_COCOA_TOUCH( cinder_ipod_testApp, RendererGl )
