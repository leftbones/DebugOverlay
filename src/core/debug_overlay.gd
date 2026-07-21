extends CanvasLayer

@onready var widget_block_scene: PackedScene = preload("res://addons/debug_overlay/core/widget_block.tscn")
@onready var debug_label_scene: PackedScene = preload("res://addons/debug_overlay/widgets/debug_label.tscn")

var _blocks: Array[WidgetBlock] = []
var _widgets: Dictionary[String, DebugWidget] = {}

var _default_block: WidgetBlock
var _current_block_index: int = 0

# TODO:
# - Experiment with clearing and recreating all widgets each frame rather than just those in blocks other than the default
# - Add fun widgets that do more than just display text, like a graph of a value over time, or a bar for a value that has a known range
# - Add a toggle for the entire overlay to be visible, and for individual blocks too
# - Add a default config for how the overlay looks, and allow it to be overridden by a user-provided config (font, background color, etc.)


func _ready() -> void:
	# Set up the default WidgetBlock
	_default_block = widget_block_scene.instantiate()
	_default_block.setup()
	_blocks.append(_default_block)
	add_child(_default_block)


func _process(delta: float) -> void:
	# Clear all blocks and their contents, except the default block
	if _blocks.size() > 1:
		_blocks.pop_front()
		for block: WidgetBlock in _blocks:
			for widget_name: String in block.widgets.keys():
				_widgets.erase(widget_name)
			block.queue_free()
		_blocks.clear()

		_blocks.append(_default_block)
		_current_block_index = 0



## Mark the start of a new WidgetBlock, all widgets will be added to the new block until `end_block()` is called
func begin_block(position: Vector2 = Vector2.ZERO, type: WidgetBlock.BlockType = WidgetBlock.BlockType.VERTICAL) -> void:
	var new_block: WidgetBlock = widget_block_scene.instantiate()
	new_block.setup(type)
	add_child(new_block)
	new_block.position = position
	_blocks.append(new_block)
	_current_block_index = _blocks.size() - 1


## Mark the end of a WidgetBlock, all widgets will be added to the default block until `new_block()` is called
func end_block() -> void:
	_current_block_index = 0


## Add a text widget to the debug overlay, or update the value of an existing label. If a key and value are provided, the label will display "key: value". If only a key is provided, the label will display just the key.
## The 'value' parameter can be any type, it will be converted to a string for display.
func set_text(name: String, value: Variant = "") -> void:
	value = str(value)

	var block: WidgetBlock = _blocks[_current_block_index]

	var label: DebugLabel = block.widgets.get(name) as DebugLabel
	if label == null:
		label = debug_label_scene.instantiate()
		block.add_widget(name, label)
		_widgets[name] = label

	if value == "":
		label.text = name
	else:
		label.text = name + ": " + value


## Remove a widget from the default block, widgets in other blocks are reset each frame
func remove(name: String) -> void:
	var widget: DebugWidget = _widgets.get(name)
	if widget != null:
		widget.queue_free()
	else:
		printerr("[DebugOverlay] No widget called '%s' found!")
