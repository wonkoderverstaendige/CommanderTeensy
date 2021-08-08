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
        this.rectsize = this.cw / 15;
    }

    update(packet) {
        this.ctx.clearRect(0, 0, this.cw, this.ch);
        let x = (packet['states'][1] / 2048);
        let y = (packet['states'][2] / 2048);
        let v = packet['states'][3];

        let cx = (x+1)/2*this.cw - this.rectsize/2;
        let cy = (y+1)/2*this.ch - this.rectsize/2;

        if (v>0) this.ctx.fillRect(cx, cy, this.rectsize, this.rectsize)

        this.ctx.fillText(`x: ${x.toFixed(2)}: ${cx.toFixed(0)}`, 5, this.cw-45);
        this.ctx.fillText(`y: ${y.toFixed(2)}: ${cy.toFixed(0)}`, 5, this.cw-25);
        this.ctx.fillText(`v: ${v > 0}`, 5, this.cw-5);
    }
}
