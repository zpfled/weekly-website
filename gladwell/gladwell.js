var gladwells = [
	"Practice isn't the thing you do once you're good. It's the thing you do that makes you good.",
	"The key to good decision making is not knowledge. It is understanding. We are swimming in the former. We are desperately lacking in the latter.",
	"We have, as human beings, a storytelling problem. We're a bit too quick to come up with explanations for things we don't really have an explanation for.",
	"Who we are cannot be separated from where we're from.",
	"Those three things - autonomy, complexity, and a connection between effort and reward - are, most people will agree, the three qualities that work has to have if it is to be satisfying.",
	"The tipping point is that magic moment when an idea, trend, or social behavior crosses a threshold, tips, and spreads like wildfire.",
	"Good writing does not succeed or fail on the strength of its ability to persuade. It succeeds or fails on the strength of its ability to engage you, to make you think, to give you a glimpse into someone else's head.",
	"It would be interesting to find out what goes on in that moment when someone looks at you and draws all sorts of conclusions.",
	"Insight is not a lightbulb that goes off inside our heads. It is a flickering candle that can easily be snuffed out.",
	"Truly successful decision-making relies on a balance between deliberate and instinctive thinking.",
	"Once a musician has enough ability to get into a top music school, the thing that distinguishes one performer from another is how hard he or she works. That's it. And what's more, the people at the very top don't work just harder or even much harder than everyone else. They work much, much harder.",
	"In fact, researchers have settled on what they believe is the magic number for true expertise: ten thousand hours.",
	"It's not how much money we make that ultimately makes us happy between nine and five. It's whether or not our work fulfills us. Being a teacher is meaningful.",
	"In the act of tearing something apart, you lose its meaning.",
	"Emotion is contagious.",
	"Hard work is a prison sentence only if it does not have meaning.",
	"I want to convince you that these kinds of personal explanations of success don't work. People don't rise from nothing....It is only by asking where they are from that we can unravel the logic behind who succeeds and who doesn't.",
	"Our world requires that decisions be sourced and footnoted, and if we say how we feel, we must also be prepared to elaborate on why we feel that way...We need to respect the fact that it is possible to know without knowing why we know and accept that - sometimes - we're better off that way.",
	"Achievement is talent plus preparation.",
	"We overlook just how large a role we all play--and by 'we' I mean society--in determining who makes it and who doesn't.",
	"To be someone's best friend requires a minimum investment of time. More than that, though, it takes emotional energy. Caring about someone deeply is exhausting.",
	"To build a better world we need to replace the patchwork of lucky breaks and arbitrary advantages today that determine success--the fortunate birth dates and the happy accidents of history--with a society that provides opportunities for all.",
	"We need to look at the subtle, the hidden, and the unspoken.",
	"My earliest memories of my father are of seeing him work at his desk and realizing that he was happy. I did not know it then, but that was one of the most precious gifts a father can give his child.",
	"There can be as much value in the blink of an eye as in months of rational analysis.",
	"[Research] suggests that what we think of as free will is largely an illusion: much of the time, we are simply operating on automatic pilot, and the way we think and act – and how well we think and act on the spur of the moment – are a lot more susceptible to outside influences than we realize.",
	"The entire principle of a blind taste test was ridiculous. They shouldn't have cared so much that they were losing blind taste tests with old Coke, and we shouldn't at all be surprised that Pepsi's dominance in blind taste tests never translated to much in the real world. Why not? Because in the real world, no one ever drinks Coca-Cola blind.",
	"You should really check out www.cladwell.com. Yes, I said 'Cladwell', not 'Gladwell'."

];


function talkToGladwell(form) {
	var userName = form.inputBox.value;
	randomGladwellQuote(userName);
}

function randomGladwellQuote(name) {
	document.getElementById("quote").innerHTML="Hi, " + name + "." + "<br>" +
	gladwells[Math.floor(Math.random() * gladwells.length)];
}

function searchKeyPress(e) {
    // look for window.event in case event isn't passed in
    if (typeof e == 'undefined' && window.event) { e = window.event; }
    if (e.keyCode == 13)
    {
        document.getElementById('btn').click();
    }
}

