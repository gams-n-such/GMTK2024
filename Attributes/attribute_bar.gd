class_name AttributeBar
extends ProgressBar


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
	set_min(attribute.min_value)
	set_max(attribute.max_value)
	set_value(attribute.value)
