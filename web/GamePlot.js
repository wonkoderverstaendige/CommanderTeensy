export class GamePlot {
    ctx = null;
    constructor() {
        this.gameCanvas = document.getElementById("gameCanvas");
        this.ctx = this.gameCanvas.getContext("2d");
        this.ctx.fillStyle = "#ffffff";
        this.ctx.font = "15px Arial";
        this.rectsize = this.gameCanvas.width / 10;
        this.drawRect(this.gameCanvas.width/2-this.rectsize/2, this.gameCanvas.height/2-this.rectsize/2);
    }

    update(packets) {
        /*
        packets.forEach((packet) => {
            this.drawRect(packet[0]%gameCanvas.width, this.gameCanvas.height/2-this.rectsize/2);
        });
         */
        this.ctx.fillText(packets, 10, 50);
        this.update();
    }

    drawRect(x, y){
        //this.ctx.clearRect(0, 35, gameCanvas.width, gameCanvas.height)
        this.ctx.fillRect(x, y,this.rectsize,this.rectsize)
    }

}
