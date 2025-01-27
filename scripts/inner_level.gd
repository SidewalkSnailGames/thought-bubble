extends Node2D

signal has_chosen
static var choice


func start_timer():
	$"CanvasLayer/Displays Timer".visible = true
	$Timer.start()
	$"CanvasLayer/Displays Timer".started = true


func stop_timer():
	$"CanvasLayer/Displays Timer".visible = false
	$Timer.stop()
	

func _on_bubble_good_has_chosen():
	choice = "Good"
	has_chosen.emit()


func _on_bubble_bad_has_chosen():
	choice = "Bad"
	has_chosen.emit()
