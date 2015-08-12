require 'streamio-ffmpeg'
module VideoProc
  def self.video_info(file)
    movie = FFMPEG::Movie.new(file.path)
    movie_info = {}
    if movie.valid?
      movie_info = {
        duration: movie.duration, # 7.5 (duration of the movie in seconds)
        bitrate: movie.bitrate, # 481 (bitrate in kb/s)
        size: movie.size, # 455546 (filesize in bytes)

        video_stream: movie.video_stream, # "h264, yuv420p, 640x480 [PAR 1:1 DAR 4:3], 371 kb/s, 16.75 fps, 15 tbr, 600 tbn, 1200 tbc" (raw video stream info)
        video_codec: movie.video_codec, # "h264"
        colorspace: movie.colorspace, # "yuv420p"
        resolution: movie.resolution, # "640x480"
        width: movie.width, # 640 (width of the movie in pixels)
        height: movie.height, # 480 (height of the movie in pixels)
        frame_rate: movie.frame_rate, # 16.72 (frames per second)

        audio_stream: movie.audio_stream, # "aac, 44100 Hz, stereo, s16, 75 kb/s" (raw audio stream info)
        audio_codec: movie.audio_codec, # "aac"
        audio_sample_rate: movie.audio_sample_rate, # 44100
        audio_channels: movie.audio_channels, # 2
      }
    end
    movie_info
  end
end