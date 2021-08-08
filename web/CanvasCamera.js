export class CameraView {
    constructor() {
        this.canvas = document.getElementById("cameraCanvas");
        this.ctx = this.canvas.getContext("2d");
        this.ctx.fillStyle = "#000000";
        this.ctx.font = "35px Arial";
        const txtCam = "No Stream";
        this.ctx.fillText(txtCam, this.canvas.width/2 - this.ctx.measureText(txtCam).width/2, this.canvas.height/2);
    }
}