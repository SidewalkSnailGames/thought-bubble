extends Node2D

const CHAT_VERT_SPACING = 58
const END = "end"
const TYPING_LENGTH = 2
const CHAT_EXCLUDE = ["Scripts", "Level 1-1", "Level 1-2", "Level 1-3", "Gate_1", "Wall_1", "Gate_2", "Wall_2", "Gate_3", "Wall_3"]

@onready var phone_screen_shape: CollisionShape2D = $"../PhoneScreen/CollisionShape2D"
@onready var gate = $Gate
@onready var level_1_1 = $"Level 1-1"
@onready var level_1_2 = $"Level 1-2"
@onready var level_1_3 = $"Level 1-3"

@export var script_name: String = "level_1_scripts.gd"
var first_msg = "ann-1"
var last_msg = first_msg
var scripts_node: Node2D
var paths
var msg_choices
var new_scroll_position_y
var offset = 0
var new_position = Vector2()
var typing_bubble = preload("res://scenes/typingbubble.tscn")
var entered = false
var cleared = false

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
		if child.name in CHAT_EXCLUDE: continue
		child.set_enabled(false)
		
	await _wait()
		
	show_msg(first_msg)
	
	new_scroll_position_y = position.y
	
	level_1_1.has_chosen.connect(has_chosen_1)
	level_1_2.has_chosen.connect(has_chosen_2)
	#for child in level_1_2.get_node("Boundaries").get_children():
		#if 
		#child.set_deferred("disabled")
	level_1_3.has_chosen.connect(has_chosen_3)


func has_chosen_1():
	cleared = true
	level_1_1.stop_timer()
	
	var new_msg
	var choice = level_1_1.choice
	if choice == "Good":
		new_msg = paths[last_msg][0]
		choice = 0
		await fill_in_msg(last_msg, choice)
		_set_next_msg_pos(get_node(last_msg), get_node(new_msg))
		await _wait(2)
		await show_msg(new_msg)
	elif choice == "Bad":
		new_msg = paths[last_msg][1]
		choice = 1
		await fill_in_msg(last_msg, choice)
		_set_next_msg_pos(get_node(last_msg), get_node(new_msg))
		await _wait(2)
		await show_msg(new_msg)


func has_chosen_2():
	cleared = true
	level_1_2.stop_timer()
	
	var new_msg
	var choice = level_1_2.choice
	if choice == "Good":
		new_msg = paths[last_msg][0]
		choice = 0
		await fill_in_msg(last_msg, choice)
		_set_next_msg_pos(get_node(last_msg), get_node(new_msg))
		await _wait(2)
		await show_msg(new_msg)
	elif choice == "Bad":
		new_msg = paths[last_msg][1]
		choice = 1
		await fill_in_msg(last_msg, choice)
		_set_next_msg_pos(get_node(last_msg), get_node(new_msg))
		await _wait(2)
		await show_msg(new_msg)


func has_chosen_3():
	cleared = true
	level_1_3.stop_timer()
	
	var new_msg
	var choice = level_1_3.choice
	if choice == "Good":
		new_msg = paths[last_msg][0]
		choice = 0
		await fill_in_msg(last_msg, choice)
		_set_next_msg_pos(get_node(last_msg), get_node(new_msg))
		await _wait(2)
		await show_msg(new_msg)
	elif choice == "Bad":
		new_msg = paths[last_msg][1]
		choice = 1
		await fill_in_msg(last_msg, choice)
		_set_next_msg_pos(get_node(last_msg), get_node(new_msg))
		await _wait(2)
		await show_msg(new_msg)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	'''
	For the reason for await, see fill_in_msg.
	...continued from the explanation, after the fill_in_msg function returns,
	this is when the chat bubble has now been updated UI-wise, and we can now
	use James' previously updated chat bubble size to determine where on the
	y-axis we should put Ann's response next.
	'''
	if not _check_floats_equal(new_scroll_position_y, position.y):
		position.y = lerpf(position.y, new_scroll_position_y, 0.1)
	else:
		position.y = new_scroll_position_y
		
	# if no end choice/end, then prevent from pressing left/right
	if get_next_msg_id(last_msg) == END: return	
	

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
	_move_dmhub_up()
	
	if (can_show_next_msg(msg_id)):
		var next_msg = get_next_msg_id(msg_id)
		_set_next_msg_pos(get_node(last_msg), get_node(next_msg))
		await _wait(2)
		if next_msg in ["james-2", "james-3"]:
			$Gate_2/CollisionShape2D.set_deferred("disabled", false)
		elif next_msg in ["james-4", "james-5", "james-6", "james-7"]:
			$Gate_3/CollisionShape2D.set_deferred("disabled", false)

		show_msg(next_msg)
		await _wait()
		_move_dmhub_up()
		

func can_show_next_msg(msg_id):
	return paths[msg_id].size() == 1 and not paths[msg_id][0] == END


func get_next_msg_id(msg_id):
	return paths[msg_id][0]
	

func _set_next_msg_pos(prev_msg, next_msg):
	new_position = Vector2()
	new_position.x = next_msg.position.x
	new_position.y = prev_msg.position.y + prev_msg.size.y + CHAT_VERT_SPACING
	next_msg.set_deferred("position", new_position)
	

func _wait(seconds: float = 0.01):
	await get_tree().create_timer(seconds).timeout
	

func _get_last_shown_msg():
	var last_shown_msg = get_children()[0]
	
	for child in get_children():
		if child.name in CHAT_EXCLUDE: continue
		if child.visible: last_shown_msg = child
	
	return last_shown_msg
	

func _get_dm_dimension():
	var last_shown_msg = _get_last_shown_msg()
	return (last_shown_msg.position.y + last_shown_msg.size.y) * scale.y - offset
	

func _check_floats_equal(a, b):
	#print("a: %s, b: %s" % [a, b])
	const e = 1
	return (a - e) < b and b < (a + e)


func _move_dmhub_up():
	var dm_dimension = _get_dm_dimension()
	if dm_dimension + CHAT_VERT_SPACING <= phone_screen_shape.shape.size.y: return
	
	# if overflowing, move the whole level up
	var last_shown_msg = _get_last_shown_msg()
	new_scroll_position_y = position.y - (dm_dimension - phone_screen_shape.shape.size.y) - CHAT_VERT_SPACING
	offset += (dm_dimension - phone_screen_shape.shape.size.y) + CHAT_VERT_SPACING


func _on_gate_1_body_entered(body):
	if body.name == "Player" and not entered:
		level_1_1.start_timer()
		entered = not entered
		cleared = false
	elif body.name == "Player" and cleared:
		level_1_1.visible = false
		$Gate_1/CollisionShape2D.set_deferred("disabled", true)
		$Wall_1/CollisionShape2D.set_deferred("disabled", false)
		level_1_1.queue_free()
		cleared = false
		entered = false
		

func _on_gate_2_body_entered(body):
	if body.name == "Player" and not entered:
		level_1_2.start_timer()
		entered = not entered
		cleared = false
	elif body.name == "Player" and cleared:
		level_1_2.visible = false
		$Gate_2/CollisionShape2D.set_deferred("disabled", true)
		$Wall_2/CollisionShape2D.set_deferred("disabled", false)
		level_1_2.queue_free()
		cleared = false
		entered = false


func _on_gate_3_body_entered(body):
	if body.name == "Player" and not entered:
		#level_1_3.start_timer()
		entered = not entered
		cleared = false
	elif body.name == "Player" and cleared:
		level_1_3.visible = false
		$Gate_3/CollisionShape2D.set_deferred("disabled", true)
		$Wall_3/CollisionShape2D.set_deferred("disabled", false)
		level_1_3.queue_free()
