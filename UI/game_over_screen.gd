extends Control

var win : bool = false

func _ready() -> void:
	if win:
		%GameOverText.text = "You Win!"
		$WinFanfare.play()
	else:
		%GameOverText.text = "You Lose..."
		$LoseFanfare.play()
	pass                           



func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")
