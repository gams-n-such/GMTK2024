extends Control

@onready var gameplay_scene : PackedScene = load("res://Arenas/default_game_arena.tscn")
@onready var tutorial_scene : PackedScene = load("res://MainMenu/how_to_play.tscn")
@onready var options_scene : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass # Replace with function body.


func _on_start_pressed():
	get_tree().change_scene_to_packed(gameplay_scene)


func _on_test_pressed() -> void:
	get_tree().change_scene_to_file("res://Arenas/Test/test_arena.tscn")


func _on_how_to_play_pressed():
	get_tree().change_scene_to_packed(tutorial_scene)


func _on_options_pressed():
	add_child(options_scene.instantiate())


func _on_quit_pressed():
	get_tree().quit()
