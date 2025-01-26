extends Node2D

const CHAT_VERT_SPACING = 58
const END = "end"

@export var script_name: String = "level_1_scripts.gd"
var first_msg = "ann-1"
var last_msg = first_msg
var scripts_node: Node2D
var paths
var msg_choices

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set up scripts node
	scripts_node = preload("res://scenes/scripts.tscn").instantiate()
	add_child(scripts_node)
	scripts_node.set_script(load("res://scripts/" + script_name))
	
	# set up path
	paths = scripts_node.paths
	msg_choices = scripts_node.msg_choices
	
	# disable all children at first
	for child in get_children():
		if child.name == "Scripts": continue
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
	# if no end choice/end, then prevent from pressing left/right
	if get_next_msg_id(last_msg) == END: return
	
	var new_msg
	var choice
	if Input.is_action_just_pressed("ui_left"): # good choice
		new_msg = paths[last_msg][0]
		choice = 0
		await fill_in_msg(last_msg, choice)
		_set_next_msg_pos(get_node(last_msg), get_node(new_msg))
		show_msg(new_msg)
		await _wait()
	elif Input.is_action_just_pressed("ui_right"): # bad choice
		new_msg = paths[last_msg][1]
		choice = 1
		await fill_in_msg(last_msg, choice)
		_set_next_msg_pos(get_node(last_msg), get_node(new_msg))
		show_msg(new_msg)
		await _wait()
	

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
		await _wait()
		

func can_show_next_msg(msg_id):
	return paths[msg_id].size() == 1 and not paths[msg_id][0] == END


func get_next_msg_id(msg_id):
	return paths[msg_id][0]
	

func _set_next_msg_pos(prev_msg, next_msg):
	var new_position = Vector2()
	new_position.x = next_msg.position.x
	new_position.y = prev_msg.position.y + prev_msg.size.y + CHAT_VERT_SPACING
	next_msg.set_deferred("position", new_position)
	

func _wait(seconds: float = 0.01):
	await get_tree().create_timer(seconds).timeout
