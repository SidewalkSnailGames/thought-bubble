extends Node2D

const END = "end"

# paths - good, bad
var paths = {
	"ann-1": ["james-1"], # Hey James! What are you up to? 😊
	"james-1": ["ann-2", "ann-3"], # Hey Ann! I’m getting ready to….. want to join me?
	"ann-2": ["james-2"], # Ooooh I love retro games, can we play Chrono Trigger? :D
	"ann-3": ["james-3"], # Oh, okay a movie is alright…
	"james-2": ["ann-4", "ann-5"], # Yeah of course we can play some games! That’s actually one of my…..What time do you want to come over?
	"james-3": ["ann-6", "ann-7"], # We don’t have to watch a movie, maybe we can….instead 😊
	"ann-4": ["james-4"], # Mine too, the ost is Incredible! How about I head over around 5:30pm?
	"ann-5": ["james-5"], # Alright…I guess we can play something else. How is 5:30pm
	"ann-6": ["james-6"], # Yes! Let’s make some pasta! Want me to pick up some bread to make garlic bread?
	"ann-7": ["james-5"], # I guess a TV show could work…?
	"james-4": ["ann-8", "ann-9"], # 5:30 Works for me 😊 would you want to..... as well?
	"james-5": ["ann-10", "ann-11"], # 5:30 works, don’t worry I have plenty of..... we’ll be okay!
	"james-6": ["ann-12"], # Garlic bread sounds good right now. Want to come over at 5:30pm?
	"james-7": ["ann-13", "ann-14"], # Okay, want to watch.....?
	"ann-8": [END], # I would love that, see you at 5:30pm 😊
	"ann-9": [END], # I don't know about the cuddling... but we can still hang out!
	"ann-10": [END], # That sounds good to me! See you at 5:30pm!
	"ann-11": [END], # I don't really want to read comic books, it's okay we can just hang out another day
	"ann-12": [END], # Okay! I'll pick some up on my way over, 5:30pm works for me
	"ann-13": [END], # Snails are my favorite! Especially Sidewalk Snails 😉
	"ann-14": [END], # I hate slugs, we can just hang out another time. snails are way better
}

var msg_choices = {
	"james-1": ["play games", "go to the movies"],
	"james-2": ["favorite games", "least favorite games"],
	"james-3": ["make some food", "watch a TV show"],
	"james-4": ["eat some snacks", "cuddle"],
	"james-5": ["retro games", "comic books"],
	"james-7": ["snail documentary", "slug documentary"],
}
