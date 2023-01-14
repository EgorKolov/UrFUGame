extends Control

func _pause():
	var new_pause_condition = not get_tree().paused
	get_tree().paused = new_pause_condition
	visible = new_pause_condition

func _input(event):
	if event.is_action_pressed("pause"):
		_pause()


func _on_ResumeButton_pressed():
	_pause()

func _on_MenuButton_pressed():
	get_tree().change_scene("res://Menu.tscn")
	_pause()

func _on_ExitButton_pressed():
	get_tree().quit()
