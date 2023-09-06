#!/usr/bin/env bash

readonly DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# settings
readonly ICON="${DIR}/icons/spotify.png"
readonly PREV="${DIR}/icons/prev.svg"
readonly NEXT="${DIR}/icons/next.svg"
readonly PLAY="${DIR}/icons/play.svg"
readonly PAUSE="${DIR}/icons/pause.svg"
readonly ICON_OFFLINE="${DIR}/icons/spotify_offline.png"
readonly DISPALY_TITLE_MAX_LENGTH=20

encode () {
  echo $@ | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&#39;/g'
}

if pidof spotify &> /dev/null; then
    # Use the command-line Spotify controller to get song info over dbus
    eval $(${DIR}/sp.sh eval)

    # grab window id 
    WINDOW_ID=$(wmctrl -l | grep "${SPOTIFY_ARTIST} - ${SPOTIFY_TITLE}\|Spotify" | awk '{print $1}')

    # trim title of song 
    DISPLAY_TITLE=$SPOTIFY_TITLE  
    [ "${#DISPLAY_TITLE}" -gt "${DISPALY_TITLE_MAX_LENGTH}" ] && \
      DISPLAY_TITLE="${SPOTIFY_TITLE:0:DISPALY_TITLE_MAX_LENGTH} …"
        
    echo "<tool>Title      $(encode ${SPOTIFY_TITLE})"
    echo "Artist     $(encode ${SPOTIFY_ARTIST})"
    echo "Album   $(encode ${SPOTIFY_ALBUM})</tool>"

    echo "<img>${ICON}</img><click>bash -c '/usr/bin/flatpak run com.spotify.Client'</click>"
    echo "<img>${PREV}</img><click>bash -c '${DIR}/sp.sh prev'</click>"
    echo "<img>${PAUSE}</img><click>bash -c '${DIR}/sp.sh pause'</click>"
    echo "<img>${PLAY}</img><click>bash -c '${DIR}/sp.sh play'</click>"
    echo "<img>${NEXT}</img><click>bash -c '${DIR}/sp.sh next'</click>"
    
    echo "<txt>$(encode ${SPOTIFY_ARTIST}) - $(encode ${DISPLAY_TITLE})</txt>"
else 
  echo "<img>${ICON_OFFLINE}</img>"
  echo "<tool>Spotify is not running</tool>"
  echo "<click>bash -c '/usr/bin/flatpak run com.spotify.Client</click>"
fi
