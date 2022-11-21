#metadata functions
song_author = ref('')
def apply_song(m) =
song_author := m["artist"]
end

song_title = ref('')
def apply_song2(m) =
song_title := m["title"]
end

def get_track_name_text()
"$(artist) - $(title)" % [ 
("artist", !song_author),    
("title", !song_title)
]
end 

#audio source
audio = playlist(reload_mode="watch", "/home/YOUR_NICKNAME/radio/music")
audio = mksafe(audio)

#video source
background = single("/home/YOUR_NICKNAME/radio/background.gif")

#calling metadata
audio.on_track(apply_song) 
audio.on_track(apply_song2) 

#drawtext
background = video.add_text(color=0xFFFFFF, font="/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", speed=0, x=50, y=50, size=26,
get_track_name_text,
background)

#mixing sources
radio = mux_video(video=background, audio)

#rtmp+codec
url = "rtmp://localhost/live"
enc = %ffmpeg(format="flv",
%video(codec="libx264", width=1280, height=720, pixel_format="yuv420p",
b="1500k", maxrate="1500k", minrate="1500k", bufsize="3000k", profile="Main", preset="veryfast", framerate=30, g=60),
%audio(codec="aac", samplerate=44100, b="128k"))

#output
output.url(fallible=true, url=url, enc, radio)
