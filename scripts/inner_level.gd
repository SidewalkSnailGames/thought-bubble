extends Node2D

signal has_chosen
static var choice

func start_timer():
	$Timer.start()


func stop_timer():
	$Timer.stop()
	

func _on_bubble_good_has_chosen():
	choice = "Good"
	has_chosen.emit()


func _on_bubble_bad_has_chosen():
	choice = "Bad"
	has_chosen.emit()
