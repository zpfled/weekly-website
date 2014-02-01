function insertMessage(message) {
	var newMessage = document.createElement('li');
	newMessage.innerHTML = message;

	var messages = document.getElementsByName('chat')[0];
	return messages.insertBefore(newMessage, messages.firstChild);
}

function sendMessage(sender, chatroom, timestamp, name, content) {
	var message = {};
	message.timestamp = timestamp;
	message.name = name;
	message.content = content;
	sender.emit(chatroom, message);
}