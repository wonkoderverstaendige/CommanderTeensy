import {WebglPlot, ColorRGBA, WebglLine} from "https://cdn.skypack.dev/webgl-plot";

export class CanvasPlot {
    constructor(canvas, numX, numLines, plot_id, colors, scaleFactors=null) {
        this.canvas = canvas;
        this.numX = numX;
        this.numLines = numLines;
        this.scaleFactors = scaleFactors !== null ? scaleFactors : new Array(numLines).fill(1.0);
        this.colors = colors;

        this.plot = new WebglPlot(this.canvas);
        this.plot.removeAllLines();
        this.lines = [];

        for (let i = 0; i < this.numLines; i++) {
            const line = new WebglLine(this.colors[i], this.numX);
            line.lineSpaceX(-1, 2 / this.numX); // fill x with numX -1...1 array
            line.offsetY = 2*(this.numLines-i-1)/(this.numLines)-1;
            line.scaleY = this.scaleFactors[i]; //1/320000
            this.plot.addLine(line);
            this.lines.push(line);
        }

        // // fill with zeros at start
        // let data = new Array(numX).fill(0);
        // this.lines.forEach((line) => {
        //     line.shiftAdd(data);
        // });
        this.plot.gScaleX = 1;
    }
}