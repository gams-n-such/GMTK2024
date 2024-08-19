class_name CityHUD
extends Control

var _player_city : PlayerCity = null
var player : PlayerCity:
	get:
		return _player_city
	set(new_player):
		_player_city = new_player
		%ExperienceBar.attribute = _player_city.get_experience()
		%LevelLabel.attribute = _player_city.get_level()
