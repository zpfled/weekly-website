var videos = [
	"http://www.youtube.com/embed/2VV_KsIcf24?showinfo=0&iv_load_policy=3&controls=0&autoplay=1&rel=0",
	"http://www.youtube.com/embed/kreLEpOVLrI?showinfo=0&iv_load_policy=3&controls=0&autoplay=1&rel=0",
	"http://www.youtube.com/embed/DKkyrOvW8FA?showinfo=0&iv_load_policy=3&controls=0&autoplay=1&rel=0",
	"http://www.youtube.com/embed/NFrLjnUNRSQ?showinfo=0&iv_load_policy=3&controls=0&autoplay=1&rel=0",
	"http://www.youtube.com/embed/rGiVBTihCgk?showinfo=0&iv_load_policy=3&controls=0&autoplay=1&rel=0",
];

Element.prototype.remove = function() {
    this.parentElement.removeChild(this);
};
NodeList.prototype.remove = HTMLCollection.prototype.remove = function() {
    for(var i = 0, len = this.length; i < len; i++) {
        if(this[i] && this[i].parentElement) {
            this[i].parentElement.removeChild(this[i]);
        }
    }
};

function getVideo(index) {
	var videoChoice = videos[index];

	popup(videoChoice);
}

function popup(video) {
	if (document.getElementById("welcome")) {
		document.getElementById("welcome").remove();
		document.getElementById("viewer").innerHTML="<div class='popup'><iframe name='video-box' class='video' src='" + video + "'frameborder='0'></iframe></div>";
	} else {
	document.getElementById("viewer").innerHTML="<div class='popup'><iframe name='video-box' class='video' src='" + video + "'frameborder='0'></iframe></div>";
	}
}