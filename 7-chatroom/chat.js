var url = require('url');
var express = require('express');
var events = require('events');
var EventEmitter = new events.EventEmitter();
var port = process.env.PORT || 8080;
var app = express(),
	http = require('http'),
	server = http.createServer(app),
	io = require('socket.io').listen(server);
app.use(express.static('./public'));
app.set('views', './views');
app.engine('html', require('ejs').renderFile);
app.use(express.bodyParser());

// Server

io.set('log level', 1);

io.sockets.on('connection', function(client) {
	console.log("Client connected...");

	client.on('message', function(message) {
		io.sockets.emit('message', message);
		console.log(message.username + ' says: ' + message.content);
	});


});


// Routes

app.get('/', function(req, res) {
	// This is the gateway. User enters her username into a form, submits post request to '/' with username variable.
	// I should sanitize this input.
	res.render('index.html');
	console.log('Requested home page');
});

app.post('/', function(req, res) {
	// This post request simply carries the username to the '/chat' page, where username variable is inserted into every message.
	res.redirect('chat.html', { user: user });
	res.end();
});

app.get('/chat', function(req, res) {
	// This is where the chats actually happen.
	res.render('chat.html', { user: user });
});


server.listen(port);
console.log('This chatroom is live! And it\'s' );
console.log("listening on port " + port + "...");