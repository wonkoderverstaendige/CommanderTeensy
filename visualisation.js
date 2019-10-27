function documentReady(fn) {
    // see if DOM is already available
    if (document.readyState === "complete" || document.readyState === "interactive") {
        // call on next available tick
        setTimeout(fn, 100);
    } else {
        document.addEventListener("DOMContentLoaded", fn);
    }
}


// function empty_array(num_items) {
//     return [...Array(num_items)].map(x=>[])
// }

// function get_data(current_x, last_idx, msPerPixel=10) {
//     var new_idx = current_x % wv.length;
//     var ts = new Date().getTime();
//     var data = empty_array(16);

//     for (var i=0; i<new_idx-last_idx; i++) {
//         var t = ts - i*msPerPixel
//         var idx = last_idx + i;
//         if (idx > wv.length) {
//             idx = 0;
//         }

//         for (var ch=0; ch < data.length; ch++) {
//             data[ch].push([t, wv[idx]]);
//         }
//     }
//     return [idx, data];
// }

function add_label(grid, channel_name, color, box=null, button=null) {
    div = document.createElement("div");
    div.className = "label";
    div.id = channel_name;
    div.style = "background-color: " + color;
    var p = document.createElement("div")
    p.className = "channel_name"
    p.id = channel_name
    p.textContent = channel_name
    // tn = document.createTextNode(channel_name);

    if (box != null) {
        div.appendChild(box);
    }
    // div.appendChild(tn);
    div.appendChild(p);
    if (button != null) {
          div.appendChild(button);
    }
    grid.appendChild(div);
    return div;
}


documentReady(function() {
    ws = start_websocket(5678);
    graphs = new GraphCollection();

    graph_A = new Graph('canvas_A');
    graph_A.msPerPixel = 5;
    graph_B = new Graph('canvas_B');
    graph_B.msPerPixel = 5;

    var unit_fields = [];
    for (let i=0; i<8; i++) {
        lbl = document.createElement('div');
        lbl.className = 'unit_field';
        lbl.id = "analog_" + i.toString();
        unit_fields.push(lbl);
    }

    var indicators = [];
    for (i=0; i<24; i++) {
        ind = document.createElement('div');
        ind.className = "indicator";
        ind.id = "digital"+i.toString();
        indicators.push(ind);
    }

    var buttons = [];
    for (i=0; i<8; i++) {
        btn = document.createElement('button');
        var text = document.createTextNode('toggle');
        btn.appendChild(text)
        btn.className = "toggle_button";
        btn.id = "digital"+(16+i).toString();
        btn.onclick = btn_clicked;
        buttons.push(btn);
    }

    // analog graph
    var label_grid = document.querySelector('.label-grid#analog');
    var num_lines = 8;
    for (let i = 0; i < num_lines; i++) {
        const line = graph_A.add_line();
        line.scaleFactor = 1/2**16;
        line.offset = 0;
        add_label(label_grid, 'analog_input_'+i.toString(), line.color, button=unit_fields[i]);
    }

    //digital graph
    label_grid = document.querySelector('.label-grid#digital');
    num_lines = 24;
    for (let i = 0; i < num_lines; i++) {   
        const data_type = i < 16 ? "input" : "output";
        const line = graph_B.add_line();
        line.scaleFactor = 0.75/num_lines;
        line.offset = 1 - 1/num_lines*i - line.scaleFactor;
        line.draw_step = true;
        var btn = (i < 16) ? null : buttons[i-16];
        add_label(label_grid, "digital_" + data_type + "_" + i.toString(), line.color,  box=indicators[i], button=btn);
    }


    graphs.addGraph(graph_A);
    graphs.addGraph(graph_B);
    graphs.start();


    function btn_clicked(event) {
        console.log(event.target.id);
        if (ws) {
            ws.send(event.target.id);
        }
    }   

    ws.onmessage = function(event) {
        if (typeof event.data === 'string') {
            try {
                var packet = JSON.parse(event.data);
            } catch (e) {
                console.log(e);
                console.log(event.data);
                return;
            }
            graph_A.appendPacket(packet.us_start, packet.analog);
            var digital = packet.digitalOut.concat(packet.digitalIn)
            graph_B.appendPacket(packet.us_start, digital);

            // analog charts values
            for (let i=0; i<8; i++) {
                var lbl = document.querySelector('.unit_field#analog_' + i.toString());
                lbl.textContent = (packet.analog[i] / 2**16 * 3.3).toFixed(2) + ' V';

            }

            // digital charts indicators
            for (let i=0; i<24; i+=1) {
                if (i<16) {
                    if (packet.digitalIn[i]) {
                            indicators[15-i].style = 'background-color: #0F0';
                    } else {
                            indicators[15-i].style = 'background-color: #000';
                    }
                } else {
                    if (packet.digitalOut[i-16]) {
                            indicators[i].style = 'background-color: #F00';
                    } else {
                            indicators[i].style = 'background-color: #000';
                    }
                }
            }
        }
    }
});

function start_websocket(ws_port) {
    var ws = new ReconnectingWebSocket("ws://127.0.0.1:" + ws_port.toString());
    ws.reconnectInterval = 500;
    ws.maxReconnectInterval = 1000;
    ws.timeoutInterval = 400;
    return ws;
}
