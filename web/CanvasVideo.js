
const videoUri = "http://raspberrypi.local:8111/stream.mjpg";
const videoStream = document.getElementById("videoStream");
videoStream.src = videoUri;

/*
Causes a loop of errors if the cam is not ready, which leads to blocking of other scripts. Therefore commented.
 */
/*
videoStream.onerror = function(e) {
    videoStream.src = videoUri;
};
*/
function reloadVideo(){
    videoStream.src = videoUri;
}
const videoStreamButton = document.getElementById("videoStreamButton").onclick = reloadVideo;




