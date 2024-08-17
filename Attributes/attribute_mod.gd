class_name AttributeMod extends Node

@export var info : AttributeModInfo

var type : AttributeModInfo.ModType:
	get:
		return info.mod_type

var value : float:
	get:
		return info.mod_value
