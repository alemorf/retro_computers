#define MUSIC_NOTE_LENGTH 6
#define MUSIC_SPEED       5
#define MUSIC_PLUMK_SPEED 400

struct MusicChannel {
  uchar noteLength;  
  uchar loadDelay;
  uint  period;
};

extern struct MusicChannel musicChannels[3];

void musicStart();
void musicTick();
void musicOff();