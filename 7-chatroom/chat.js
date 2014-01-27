var request = require('request');
var url = require('url');
var express = require('express');
var app = express(),
	http = require('http'),
	server = http.createServer(app),
	io = require('socket.io').listen(server);
var events = require('events');
var EventEmitter = new events.EventEmitter();

var port = process.env.PORT || 8080;

io.set('log level', 1);

io.sockets.on('connection', function(client) {
	console.log("Client connected...");

	client.on('message', function(message) {
		io.sockets.emit('message', message);
		// client.broadcast.emit('message', message);
		console.log(message);
	});


});

app.use(express.static('./public'));
app.use(express.bodyParser());


app.get('/', function(req, res) {
	res.sendfile('./index.html');
	console.log('Requested home page');
});

app.post('/', function(req, res) {
	var message = req.body.chat_input;

	console.log('You typed: "' + message +'"');
	res.end(); //The message is created, but dies as soon as the response comes back.
});


server.listen(port);
console.log("Listening on port " + port + "...");