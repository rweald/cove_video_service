#About
This is a simple service that will send video files to the end user. In
place to provide an authentication solution for video files that can not
be served from public. 

#Usage
The videos will be sent from the /videos directory that was not included
in the repository because of its size. 
Also the player is expecting webm formatting at the moment but that can
be changed later. 

    mkdir videos
    cp <some_path_to_video_files> videos/


#REST API
The service will be accessible via a simple rest api.
To request a video simple make a HTTP 'GET' request to:

    "/video?name=<the name of the video you want>"
