export class CameraView {
    constructor(host_uri, port=8111) {
        this.videoUri = `http://${host_uri}:${port}/stream.mjpg`;
        this.view = document.getElementById('videoStream');
        this.view.src = this.videoUri;

        this.view.onerror = function(e) {
            console.error(e);
            this.view.src = '';
        };

        const reload_button = document.getElementById("videoStreamButton");
        reload_button.onclick = this.reload
    }

    reload = function() {
        this.view.src = this.videoUri;
    }
}