extends Node2D

var last_msg = "ann-1"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_next_msg(paths[last_msg][0])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		show_next_msg(paths[last_msg][0])
	elif Input.is_action_just_pressed("ui_right"):
		show_next_msg(paths[last_msg][1])


# paths - good, bad
var paths = {
	"ann-1": ["james-1"], # Hey James! What are you up to? 😊
	"james-1": ["ann-2", "ann-3"], # Hey Ann! I’m getting ready to….. want to join me?
	"ann-2": ["james-2"], # Ooooh I love retro games, can we play Chrono Trigger? :D
	"ann-3": ["james-3"], # Oh, okay a movie is alright…
	#"james-2": ["ann-4", "ann-5"], # Yeah of course we can play some games! That’s actually one of my…..What time do you want to come over?
	#"james-3": ["ann-6", "ann-7"], # We don’t have to watch a movie, maybe we can….instead 😊
	#"ann-4": ["james-4"], # Mine too, the ost is Incredible! How about I head over around 5:30pm?
	#"ann-5": ["james-5"], # Alright…I guess we can play something else. How is 5:30pm
}

func show_next_msg(msg_id):
	get_node(msg_id).set_deferred("visible", true)
	last_msg = msg_id
	print(paths[msg_id])
	
	if (paths[msg_id].size() == 1):
		show_next_msg(paths[msg_id][0])
		last_msg = paths[msg_id][0]
