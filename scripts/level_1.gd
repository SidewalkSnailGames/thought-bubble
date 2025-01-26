extends Node2D

const CHAT_VERT_SPACING = 58

var first_msg = "ann-1"
var last_msg = first_msg


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# disable all children at first
	for child in get_children():
		child.set_enabled(false)
		
	show_msg(first_msg)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	'''
	For the reason for await, see fill_in_msg.
	...continued from the explanation, after the fill_in_msg function returns,
	this is when the chat bubble has now been updated UI-wise, and we can now
	use James' previously updated chat bubble size to determine where on the
	y-axis we should put Ann's response next.
	'''
	var new_msg
	var choice
	if Input.is_action_just_pressed("ui_left"): # good choice
		new_msg = paths[last_msg][0]
		choice = 0
		await fill_in_msg(last_msg, choice)
		_set_next_msg_pos(get_node(last_msg), get_node(new_msg))
		show_msg(new_msg)
		await get_tree().create_timer(0.01).timeout
	elif Input.is_action_just_pressed("ui_right"): # bad choice
		new_msg = paths[last_msg][1]
		choice = 1
		await fill_in_msg(last_msg, choice)
		_set_next_msg_pos(get_node(last_msg), get_node(new_msg))
		show_msg(new_msg)
		await get_tree().create_timer(0.01).timeout
	

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
	"ann-8": ["end"], # I would love that, see you at 5:30pm 😊
	"ann-9": ["end"], # I don't know about the cuddling... but we can still hang out!
	"ann-10": ["end"], # That sounds good to me! See you at 5:30pm!
	"ann-11": ["end"], # I don't really want to read comic books, it's okay we can just hang out another day
	"ann-12": ["end"], # Okay! I'll pick some up on my way over, 5:30pm works for me
	"ann-13": ["end"], # Snails are my favorite! Especially Sidewalk Snails 😉
	"ann-14": ["end"], # I hate slugs, we can just hang out another time. snails are way better
}

var msg_choices = {
	"james-1": ["play games", "go to the movies"],
	"james-2": ["favorite games", "least favorite games"],
	"james-3": ["make some food", "watch a TV show"],
	"james-4": ["eat some snacks", "cuddle"],
	"james-5": ["retro games", "comic books"],
	"james-7": ["snail documentary", "slug documentary"]
}

func fill_in_msg(msg_id, choice):
	'''
	For the reason for await, see messageplatform.set_collision_shape_dirty_flag()
	... continued from the explanation, here is where we fill in James' choice.
	After that, we set the collision shape dirty flag to 1.
	'''
	var msg = get_node(msg_id)
	var label = get_node(msg_id).get_node("MarginContainer/Label")
	var og_text = label.text
	var s = og_text.split("<...>")
	label.text = s[0] + " " + msg_choices[msg_id][choice] + s[1]
	await msg.set_collision_shape_dirty_flag()
	

func show_msg(msg_id):
	var msg = get_node(msg_id)
	msg.set_enabled(true)
	last_msg = msg_id
	
	# lol I'm abusing this method call. Good to have here anyway - Alex
	# helps to wait for it to update the previous message's position
	# before showing the next one
	await msg.set_collision_shape_dirty_flag()
	
	if (can_show_next_msg(msg_id)):
		var next_msg = get_next_msg_id(msg_id)
		_set_next_msg_pos(get_node(last_msg), get_node(next_msg))
		show_msg(next_msg)
		await get_tree().create_timer(0.01).timeout
		

func can_show_next_msg(msg_id):
	return paths[msg_id].size() == 1
	

func get_next_msg_id(msg_id):
	return paths[msg_id][0]
	

func _set_next_msg_pos(prev_msg, next_msg):
	var new_position = Vector2()
	new_position.x = next_msg.position.x
	new_position.y = prev_msg.position.y + prev_msg.size.y + CHAT_VERT_SPACING
	next_msg.set_deferred("position", new_position)
