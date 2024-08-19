extends Control

@export var gameplay_scene : PackedScene
@export var tutorial_scene : PackedScene
@export var options_scene : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass # Replace with function body.


func _on_start_pressed():
	get_tree().change_scene_to_packed(gameplay_scene)


func _on_how_to_play_pressed():
	add_child(tutorial_scene.instantiate())


func _on_options_pressed():
	add_child(options_scene.instantiate())


func _on_quit_pressed():
	get_tree().quit()
