extends Node


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass

func game_over(win : bool) -> void:
	$SceneRoot.process_mode = Node.PROCESS_MODE_DISABLED
	$BGM.stop()
	if win:
		$WinFanfare.play()
	else:
		$LoseFanfare.play()
	
	pass
