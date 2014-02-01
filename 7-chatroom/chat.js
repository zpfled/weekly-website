
require('newrelic');
var url = require('url');
var express = require('express');
var partials = require('express-partials');
var events = require('events');
var EventEmitter = new events.EventEmitter();
var port = process.env.PORT || 8080;

if (process.env.REDISTOGO_URL) {
	// TODO: redistogo connection
	var rtg   = require('url').parse(process.env.REDISTOGO_URL);
	var redis = require('redis');
	var redisClient = redis.createClient(rtg.port, rtg.hostname);
	
	redisClient.auth(rtg.auth.split(':')[1]);
} else {
	var redis = require('redis');
	var redisClient = redis.createClient();
}

var app = express(),
	http = require('http'),
	server = http.createServer(app),
	io = require('socket.io').listen(server);


// Middleware

app.use(express.static('./public'));
app.use(partials());
app.set('views', './views');
app.set('view options', { layout: true });
app.engine('ejs', require('ejs').renderFile);
app.use(express.bodyParser());
app.use(express.cookieParser());
app.use(express.session({secret: 'week7seven'}));

//Functions

function storeMessage(chatroom, timestamp, name, content) {
	var message = (timestamp + ": " + name + " says: " + content);

	redisClient.lpush(chatroom, message, function(err, response) {
		redisClient.ltrim(chatroom, 0, 9);
	});
}

// Server

io.set('log level', 0);

io.sockets.on('connection', function(client) {

	client.on('join', function(handle, chatroom) {
	

		redisClient.lrange(chatroom, 0, -1, function(err, messages) {
			messages = messages.reverse();

			messages.forEach(function(message) {
				client.emit('history', message);
			});
		});

	});

	// client.on('disconnect', function(client) {
	// 	// console.log('Disconnect from line 58...');
	// });

	client.on('history', function(message) {
		io.sockets.emit('history', message);
	});

	client.on('General', function(message) {
		io.sockets.emit('General', message);
		// console.log(message.timestamp + ': ' + message.name + ' says: ' + message.content);
		storeMessage('General', message.timestamp, message.name, message.content);
	});

	client.on('Whiskey', function(message) {
		io.sockets.emit('Whiskey', message);
		// console.log(message.timestamp + ': ' + message.name + ' says: ' + message.content);
		storeMessage('Whiskey', message.timestamp, message.name, message.content);
	});

	client.on('Music', function(message) {
		io.sockets.emit('Music', message);
		// console.log(message.timestamp + ': ' + message.name + ' says: ' + message.content);
		storeMessage('Music', message.timestamp, message.name, message.content);
	});

});



// Routes

app.get('/', function(req, res) {
	// I should sanitize this input.
	res.render('index.ejs', { handle: 'User', title: 'A Not-So-Bad Chatroom' });
	// console.log('Requested home page...');
});

app.post('/', function(req, res) {
	res.header("Content-Type", "application/json; charset=UTF-8");
	req.session.user = req.body.user;
	req.session.room = req.body.room;
	// console.log(req.session.user + ' has joined the chat...');

	res.redirect('/chat/' + req.session.room);
});

app.get('/chat/:room', function(req, res) {
	if (!req.session.user) {
		res.redirect('/');
	} else {
		req.params.room = req.session.room;
		res.render('chat.ejs', { handle: req.session.user, title: req.session.room });
	}
});


server.listen(port);
// console.log('This chatroom is live! And it\'s' );
// console.log("listening on port " + port + "...");


