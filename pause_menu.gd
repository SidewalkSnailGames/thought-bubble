extends Control

func resume():
	set_visible(false)
	get_tree().paused = false	
	$AnimationPlayer.play_backwards("blur")

func pause():
	set_visible(true)
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func testEsc():
	if Input.is_action_just_pressed("escape") and get_tree().paused == false:
		print("PAUSED")
		pause()
	elif Input.is_action_just_pressed("escape") and get_tree().paused == true:
		print("UNPAUSED")
		resume()
		
func _on_resume_pressed() -> void:
	resume()

func _on_options_pressed() -> void:
	print("OPTIONS MENU!")

func _on_quit_pressed() -> void:
<<<<<<< Updated upstream
	get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")
=======
	get_tree().quit()
	print("MAIN MENU!")
>>>>>>> Stashed changes

func _process(delta):
	testEsc()
