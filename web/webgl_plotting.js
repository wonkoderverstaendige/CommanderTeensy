// noinspection DuplicatedCode

import {WebglPlot, ColorRGBA, WebglLine} from "https://cdn.skypack.dev/webgl-plot";

const canvas = document.getElementById('canvas_analog');

let numLines = 8;
let numX = 5000;
let wglp;
let wgLines = [];
let wgLineColors = [];

let scale = 1;
let offset = 0;
let pinchZoom = false;
let drag = false;
let zoom = false;
let dragInitialX = 0;
let dragOffsetOld = 0;
let initialX = 0;

let ws;
let message_queue = [];

let indicators = [];
let buttons = [];
let unit_names_analog;
let unit_names_states;

createUI();
init();

// Resize Handling, to prevent recalculation spam during event
let resizeId;
window.addEventListener("resize", () => {
    window.clearTimeout(resizeId);
    resizeId = window.setTimeout(doneResizing, 500);
});

function processMessages() {
    let packets = message_queue;
    message_queue = [];
    wgLines.forEach((line, idx) => {
        const data = [];
        packets.forEach((p) => {
           data.push(p['analog'][idx]);
        });
        line.shiftAdd(data);
    });
}

// Animation/update ticks, maybe lower to 30 fps?
function newFrame() {
    updateTextDisplay();
    processMessages();
    wglp.update();
    requestAnimationFrame(newFrame);
}

requestAnimationFrame(newFrame);

function add_label(grid, channel_name, color, box = null, button = null) {
    const div = document.createElement("div");
    div.className = "label";
    div.id = channel_name;
    div.style.backgroundColor = color;
    const p = document.createElement("div");
    p.className = "channel_name";
    p.id = channel_name;
    p.textContent = channel_name;

    if (box != null) {
        div.appendChild(box);
    }
    div.appendChild(p);
    if (button != null) {
        div.appendChild(button);
    }
    grid.appendChild(div);
    return div;
}

function createUI() {
    let unit_fields_analog = [];
    unit_names_analog = ['V', 'V', 'V', 'V', 'V', 'V', 'V', 'V'];
    for (let i = 0; i < 8; i++) {
        const lbl = document.createElement('div');
        lbl.className = 'unit_field analog';
        lbl.id = `analog_${i}`;
        unit_fields_analog.push(lbl);
    }

    let unit_fields_states = [];
    unit_names_states = ['cm', 'cm/s', 'cm/s²', 'Δlux', '°C', 'mA', 'Hz', 'kW'];
    for (let i = 0; i < 8; i++) {
        const lbl = document.createElement('div');
        lbl.className = 'unit_field states';
        lbl.id = `states_${i}`;
        unit_fields_states.push(lbl);
    }

    for (let i = 0; i < 24; i++) {
        const ind = document.createElement('div');
        ind.className = "indicator";
        ind.id = `digital_${i}`;
        indicators.push(ind);
    }

    for (let i = 0; i < 8; i++) {
        const btn = document.createElement('button');
        const text = document.createTextNode('toggle');
        btn.appendChild(text)
        btn.className = "toggle_button";
        btn.id = `digital_${16 + i}`;
        btn.onclick = btn_clicked;
        buttons.push(btn);
    }

    // analog graph
    let label_grid = document.querySelector('#grid_analog');
    let num_lines = 8;
    for (let i = 0; i < num_lines; i++) {
        // const line = graph_analog.add_line();
        // line.scaleFactor = 1/2**16;
        // line.offset = 0;
        // line.color = 'hsl(' + (180/num_lines*i).toString() + ', 80%, 60%)';
        let color = 'hsl(' + (180 / num_lines * i).toString() + ', 80%, 60%)';
        add_label(label_grid, `analog_input_${i}`, color, unit_fields_analog[i]);
        wgLineColors.push([(1/num_lines*i), 0.8, 0.6]);
    }

    // states graph
    label_grid = document.querySelector('#grid_states');
    num_lines = 8;
    const scale_factors = [1 / 2 ** 16.5, 1 / 2 ** 10, 1 / 2 ** 12, 1 / 2 ** 12,
        1 / 25, 1 / 2 ** 22, 1 / 2 ** 22, 1 / 2 ** 22];
    for (let i = 0; i < num_lines; i++) {
        // const line = graph_states.add_line();
        // line.scaleFactor = scale_factors[i]/4;  // should be 32 for full range, just for ease of visualisation
        // line.offset = 1 - 1/num_lines*i - line.scaleFactor; //0.5;
        // line.color = 'hsl(' + (180/num_lines*i+180).toString() + ', 40%, 50%)';
        let color = 'hsl(' + (180 / num_lines * i + 180).toString() + ', 40%, 50%)';
        add_label(label_grid, `states_input_${i}`, color, unit_fields_states[i]);
    }

    //digital graph
    label_grid = document.querySelector('#grid_digital');
    num_lines = 24;
    for (let i = 0; i < num_lines; i++) {
        const data_type = i < 16 ? "input" : "output";
        // const line = graph_digital.add_line();
        // line.scaleFactor = 0.75/num_lines;
        // line.offset = 1 - 1/num_lines*i - line.scaleFactor;
        // line.draw_step = true;
        let color;
        if (i < 16) {
            color = 'hsl(' + (90 / num_lines * i).toString() + ', 80%, 60%)';
        } else {
            color = 'hsl(' + (120 / num_lines * i + 120).toString() + ', 80%, 60%)';
        }
        const btn = (i < 16) ? null : buttons[i - 16];
        add_label(label_grid, `digital_${data_type}_${i}`, color, indicators[i], btn);
    }

}

function getColor(rgb) {
    let sep = rgb.indexOf(",") > -1 ? "," : " ";
    rgb = rgb.substr(4).split(")")[0].split(sep);
    let r = parseInt(rgb[0]),
        g = parseInt(rgb[1]),
        b = parseInt(rgb[2]);
    return [r/255, g/255, b/255];
}

function init() {
    ws = start_websocket(5678);

    const devicePixelRatio = window.devicePixelRatio || 1;
    canvas.width = canvas.clientWidth * devicePixelRatio;
    canvas.height = canvas.clientHeight * devicePixelRatio;

    wglp = new WebglPlot(canvas);
    wglp.removeAllLines();

    for (let i = 0; i < numLines; i++) {
        // const color = new ColorRGBA(1, 1, 1/i, 1);
        const lbl = document.getElementById('analog_input_'+i);
        const rgb = getColor(lbl.style.backgroundColor);
        const color = new ColorRGBA(rgb[0], rgb[1], rgb[2], 1);

        const line = new WebglLine(color, numX);
        line.lineSpaceX(-1, 2 / numX); // fill x with numX -1...1 array
        line.offsetY = 2*(numLines-i-1)/(numLines)-1;
        line.scaleY = 1/320000;
        wglp.addLine(line);
        wgLines.push(line);
    }

    // let data = new Array(numX).fill(0);
    // wgLines.forEach((line) => {
    //     line.shiftAdd(data);
    // });

    wglp.gScaleX = 1;

    // start accepting messages
    ws.onmessage = ws_message_receive;
}

function doneResizing() {
    //wglp.viewport(0, 0, canv.width, canv.height);
}


function start_websocket(ws_port) {
    const url = window.location.hostname;
    const ws = new ReconnectingWebSocket(`ws://${url}:${ws_port.toString()}`);
    ws.reconnectInterval = 500;
    ws.maxReconnectInterval = 1000;
    ws.timeoutInterval = 400;
    return ws;
}

function ws_message_receive(event) {
    if (typeof event.data !== 'string') return;

    let packet;
    try {
        packet = JSON.parse(event.data);
    } catch (e) {
        console.error(e);
        console.log(event.data);
        return;
    }
    // graph_analog.appendPacket(packet.us_start, packet.analog);
    // graph_states.appendPacket(packet.us_start, packet.states);
    // graph_digital.appendPacket(packet.us_start, packet.digitalIn.concat(packet.digitalOut));

    message_queue.push(packet);
}


function updateTextDisplay() {
    const packet = message_queue[message_queue.length - 1];
    if (!packet) return;
    let lbl;
    // analog charts values
    for (let i = 0; i < 8; i++) {
        lbl = document.querySelector(`.unit_field#analog_${i}`);
        lbl.textContent = (packet['analog'][i] / 2 ** 16 * 3.3).toFixed(2) + ' ' + unit_names_analog[i];
    }

    // state charts values
    for (let i = 0; i < 8; i++) {
        lbl = document.querySelector(`.unit_field#states_${i}`);
        lbl.textContent = (packet['states'][i] >= 0 ? '0' : '') + (packet['states'][i] / 100).toFixed(2) + ' ' + unit_names_states[i];
    }

    // digital charts indicators
    for (let i = 0; i < 24; i += 1) {
        let bg_color;
        if (i < 16) {
            bg_color = packet['digitalIn'][i] ? '#0F0' : '#000';
        } else {
            bg_color = packet['digitalOut'][i - 16] ? '#F00' : '#000';
        }
        indicators[i].style.backgroundColor = bg_color;
    }
}

function btn_clicked(event) {
    console.log(event.target.id);
    if (ws) {
        ws.send(event.target.id);
    }
}