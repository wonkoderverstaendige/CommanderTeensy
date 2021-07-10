function documentReady(fn) {
    // see if DOM is already available
    if (document.readyState === "complete" || document.readyState === "interactive") {
        // call on next available tick
        setTimeout(fn, 100);
    } else {
        document.addEventListener("DOMContentLoaded", fn);
    }
}

function add_label(grid, channel_name, color, box=null, button=null) {
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

documentReady(function() {
    const ws = start_websocket(5678);
    const graphs = new GraphCollection();

    let graph_analog = new Graph('canvas_analog');
    graph_analog.msPerPixel = 5;

    let graph_states = new Graph('canvas_states');
    graph_states.msPerPixel = 5;

    let graph_digital = new Graph('canvas_digital');
    graph_digital.msPerPixel = 5;

    let unit_fields_analog = [];
    const unit_names_analog = ['V', 'V', 'V', 'V', 'V', 'V', 'V', 'V'];
    for (let i=0; i<8; i++) {
        const lbl = document.createElement('div');
        lbl.className = 'unit_field analog';
        lbl.id = `analog_${i}`;
        unit_fields_analog.push(lbl);
    }

    let unit_fields_states = [];
    const unit_names_states = ['cm', 'cm/s', 'cm/s²', 'Δlux', '°C', 'mA', 'Hz', 'kW'];
    for (let i=0; i<8; i++) {
        const lbl = document.createElement('div');
        lbl.className = 'unit_field states';
        lbl.id = `states_${i}`;
        unit_fields_states.push(lbl);
    }

    let indicators = [];
    for (let i=0; i<24; i++) {
        const ind = document.createElement('div');
        ind.className = "indicator";
        ind.id = `digital_${i}`;
        indicators.push(ind);
    }

    let buttons = [];
    for (let i=0; i<8; i++) {
        const btn = document.createElement('button');
        const text = document.createTextNode('toggle');
        btn.appendChild(text)
        btn.className = "toggle_button";
        btn.id = `digital_${16+i}`;
        btn.onclick = btn_clicked;
        buttons.push(btn);
    }

    // analog graph
    let label_grid = document.querySelector('#analog_grid');
    let num_lines = 8;
    for (let i = 0; i < num_lines; i++) {
        const line = graph_analog.add_line();
        line.scaleFactor = 1/2**16;
        line.offset = 0;
        line.color = 'hsl(' + (180/num_lines*i).toString() + ', 80%, 60%)';
        add_label(label_grid, `analog_input_${i}`, line.color, unit_fields_analog[i]);
    }

    // states graph
    label_grid = document.querySelector('#states_grid');
    num_lines = 8;
    const scale_factors = [1/2**16.5, 1/2**10, 1/2**12, 1/2**12,
                        1/25, 1/2**22, 1/2**22, 1/2**22];
    for (let i = 0; i < num_lines; i++) {
        const line = graph_states.add_line();
        line.scaleFactor = scale_factors[i]/4;  // should be 32 for full range, just for ease of visualisation
        line.offset = 1 - 1/num_lines*i - line.scaleFactor; //0.5;
        line.color = 'hsl(' + (180/num_lines*i+180).toString() + ', 40%, 50%)';
        add_label(label_grid, `states_input_${i}`, line.color, unit_fields_states[i]);
    }

    //digital graph
    label_grid = document.querySelector('#digital_grid');
    num_lines = 24;
    for (let i = 0; i < num_lines; i++) {   
        const data_type = i < 16 ? "input" : "output";
        const line = graph_digital.add_line();
        line.scaleFactor = 0.75/num_lines;
        line.offset = 1 - 1/num_lines*i - line.scaleFactor;
        line.draw_step = true;
        if (i<16) {
            line.color = 'hsl(' + (90/num_lines*i).toString() + ', 80%, 60%)';
        } else {
            line.color = 'hsl(' + (120/num_lines*i+120).toString() + ', 80%, 60%)';
        }
        const btn = (i < 16) ? null : buttons[i-16];
        add_label(label_grid, `digital_${data_type}_${i}`, line.color,  indicators[i], btn);
    }


    graphs.addGraph(graph_analog);
    graphs.addGraph(graph_states);
    graphs.addGraph(graph_digital);
    graphs.start();


    function btn_clicked(event) {
        console.log(event.target.id);
        if (ws) {
            ws.send(event.target.id);
        }
    }   

    ws.onmessage = function(event) {
        if (typeof event.data !== 'string') return;

        let packet;
        try {
            packet = JSON.parse(event.data);
        } catch (e) {
            console.error(e);
            console.log(event.data);
            return;
        }
        graph_analog.appendPacket(packet.us_start, packet.analog);
        graph_states.appendPacket(packet.us_start, packet.states);
        graph_digital.appendPacket(packet.us_start, packet.digitalIn.concat(packet.digitalOut));

        let lbl;
        // analog charts values
        for (let i=0; i<8; i++) {
            lbl = document.querySelector(`.unit_field#analog_${i}`);
            lbl.textContent = (packet.analog[i] / 2**16 * 3.3).toFixed(2) + ' ' + unit_names_analog[i];
        }

        // state charts values
        for (let i=0; i<8; i++) {
            lbl = document.querySelector(`.unit_field#states_${i}`);
            lbl.textContent = (packet.states[i] >= 0 ? '0' : '') + (packet.states[i] / 100).toFixed(2) + ' ' + unit_names_states[i];
        }

        // digital charts indicators
        for (let i=0; i<24; i+=1) {
            let bg_color;
            if (i<16) {
                bg_color = packet.digitalIn[i] ? '#0F0' : '#000';
            } else {
                bg_color = packet.digitalOut[i-16] ? '#F00' : '#000';
            }
            indicators[i].style.backgroundColor = bg_color;
        }
    }
});

function start_websocket(ws_port) {
    const url = window.location.hostname;
    const ws = new ReconnectingWebSocket(`ws://${url}:${ws_port.toString()}`);
    ws.reconnectInterval = 500;
    ws.maxReconnectInterval = 1000;
    ws.timeoutInterval = 400;
    return ws;
}
