extends Node


func _ready() -> void:
	%HUD.player = %PlayerCity
	%PlayerCity.destroyed.connect(_on_player_city_destroyed)

func _on_player_city_destroyed() -> void:
	game_over(false)

func game_over(win : bool) -> void:
	$SceneRoot.process_mode = Node.PROCESS_MODE_DISABLED
	$BGM.stop()
	if win:
		$WinFanfare.play()
	else:
		$LoseFanfare.play()
	
	pass
