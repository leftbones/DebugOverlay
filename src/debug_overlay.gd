extends CanvasLayer

@onready var debug_label: PackedScene = preload("res://addons/debug_overlay/debug_label.tscn")
@onready var widget_block: VBoxContainer = %WidgetBlock

var _widgets: Dictionary[String, DebugWidget] = {}

# TODO:
# - Make a WidgetBlock class that can be anchored/positioned anywhere and can order widgets using a VBoxContainer or HBoxContainer (maybe a GridContainer too)
# - Experiment with clearing an entire block when a widget is modified, added, or removed, rather than doing it every frame
# - Add fun widgets that do more than just display text, like a graph of a value over time, or a bar for a value that has a known range
# - Add a toggle for the entire overlay to be visible, and for individual blocks too
# - Add a default config for how the overlay looks, and allow it to be overridden by a user-provided config (font, background color, etc.)


## Add a text widget to the debug overlay, or update the value of an existing label. If a key and value are provided, the label will display "key: value". If only a key is provided, the label will display just the key.
## The 'value' parameter can be any type, it will be converted to a string for display.
func set_text(key: String, value: Variant = "") -> void:
	value = str(value)

	var label: DebugLabel = _widgets.get(key) as DebugLabel
	if label == null:
		label = debug_label.instantiate()
		widget_block.add_child(label)
		_widgets[key] = label

	if value == "":
		label.text = key
	else:
		label.text = key + ": " + value
