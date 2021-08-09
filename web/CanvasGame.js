
const wsUri = "ws://127.0.0.1:5678";
let output;
let websocket;


function init() {
    connectWebSocket();
}

function connectWebSocket() {
    websocket = new WebSocket(wsUri);

    websocket.onopen = function (evt) {
        onOpen(evt)
    };

    websocket.onmessage = function (evt) {
        onMessage(evt)
    };

    websocket.onerror = function (evt) {
        onError(evt)
    };

    websocket.onclose = function (evt) {
        onError(evt)
    };
}

function onOpen(evt) {
    connectionMessage("CONNECTED");
}

function onMessage(evt) {
    const obj = JSON.parse(evt.data);
    updateRect(obj.analog[7])
}

function onError(evt) {
    connectionMessage("ERROR: " + evt.data);
    connectWebSocket();
}

const gameCanvas = document.getElementById("gameCanvas");
const ctx = gameCanvas.getContext("2d");
ctx.fillStyle = "#ffffff";
ctx.font = "15px Arial";
let rectsize = gameCanvas.width / 10;
let yPos = gameCanvas.height/2 - rectsize/2;


function updateRect(xPos) {
    ctx.clearRect(0, 35, gameCanvas.width, gameCanvas.height)
    drawRect(xPos%gameCanvas.width, yPos);
    ctx.fillText("Position x: " + xPos%gameCanvas.width, 10, 50);
}

function connectionMessage(message) {
    ctx.clearRect(0, 0, gameCanvas.width, 35)
    ctx.fillText("Connection: " + message, 10, 25);
}

function drawRect(x, y){ctx.fillRect(x, y,rectsize,rectsize)}

window.addEventListener("load", init, false);

window.addEventListener('unload', function(evt) {
    websocket.close();
});
