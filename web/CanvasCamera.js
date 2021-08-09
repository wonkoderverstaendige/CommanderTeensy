export class CameraView {
    constructor(host_uri) {
        // this.canvas = document.getElementById("cameraCanvas");
        // this.ctx = this.canvas.getContext("2d");
        // this.ctx.fillStyle = "#000000";
        // this.ctx.font = "35px Arial";
        // const txtCam = "No Stream";
        // this.ctx.fillText(txtCam, this.canvas.width/2 - this.ctx.measureText(txtCam).width/2, this.canvas.height/2);
        this.videoUri = `${host_uri}/stream.mjpg`;
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