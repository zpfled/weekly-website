var insertMessage = function(message) {
	var newMessage = document.createElement('li');
	newMessage.innerHTML = message;

	var messages = document.getElementsByTagName('ul')[0];
			return messages.insertBefore(newMessage, messages.firstChild);
};


function sendMessage(sender, message) {
	sender.emit('message', message);
}