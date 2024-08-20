class_name AttributeLabel
extends Label

func _ready() -> void:
	pass

var _attribute : Attribute = null
var attribute : Attribute:
	get:
		return _attribute
	set(new_attribute):
		_disconnect_signals()
		_attribute = new_attribute
		_connect_signals()
		update_value()

var _attribute_name : String = "Attr"
@export var attribute_name : String:
	get:
		return _attribute_name
	set(new_name):
		_attribute_name = new_name
		if show_attribute_name:
			update_value()

var _show_attribute_name : bool = true
@export var show_attribute_name : bool:
	get:
		return _show_attribute_name
	set(new_enabled):
		if new_enabled != _show_attribute_name:
			_show_attribute_name = new_enabled
			update_value()

var _show_max_value : bool = false
@export var show_max_value : bool:
	get:
		return _show_max_value
	set(new_enabled):
		if new_enabled != _show_max_value:
			_show_max_value = new_enabled
			update_value()

func _disconnect_signals() -> void:
	if attribute:
		attribute.value_changed.disconnect(_on_value_changed)

func _connect_signals() -> void:
	if attribute:
		attribute.value_changed.connect(_on_value_changed)

func _on_value_changed(attribute : Attribute, new_value : float) -> void:
	update_value()

func update_value() -> void:
	if not attribute:
		return
	var format_string = ""
	if show_attribute_name:
		format_string = "{attribute}: "
	format_string += "{value}"
	if show_max_value:
		format_string += "/{max_value}"
	text = format_string.format({"attribute": attribute_name, "value": attribute.value, "max_value": attribute.max_value})
