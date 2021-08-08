export class Game {
    ctx = null;
    constructor() {
        this.canvas = document.getElementById("gameCanvas");
        const devicePixelRatio = window.devicePixelRatio || 1;
        this.canvas.width = this.canvas.clientWidth * devicePixelRatio;
        this.canvas.height = this.canvas.clientHeight * devicePixelRatio;
        this.cw = this.canvas.width;
        this.ch = this.canvas.height;

        this.ctx = this.canvas.getContext("2d");

        this.ctx.fillStyle = "#fff";
        this.ctx.font = "15px Arial";
        this.rectsize = this.cw / 10;

        // this.drawRect(this.cw/2-this.rectsize/2, this.ch/2-this.rectsize/2);
    }

    update(packet) {
        /*
        packets.forEach((packet) => {
            this.drawRect(packet[0]%canvas.width, this.canvas.height/2-this.rectsize/2);
        });
         */
        // console.log(packet);
        this.ctx.clearRect(0, 0, 100, 100);
        let x = packet['states'][1] / 2048;
        let y = packet['states'][2] / 2048;
        let v = packet['states'][3];
        this.drawRect(x, y, v);

        this.ctx.fillText(`x: ${x.toFixed(0)}`, 5, 15);
        this.ctx.fillText(`y: ${y.toFixed(0)}`, 5, 35);
        this.ctx.fillText(`v: ${v > 0}`, 5, 55);
    }

    drawRect(x, y, v){
        this.ctx.clearRect(0, 0, this.cw, this.ch);
        if (v) {
            this.ctx.fillRect(x, y,this.rectsize,this.rectsize)
        }
    }
}
