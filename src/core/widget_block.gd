class_name WidgetBlock
extends Control

enum BlockType { VERTICAL, HORIZONTAL }

var container: Container
var widgets: Dictionary[String, DebugWidget] = {}


# Create the container that holds the widgets
func setup(type: BlockType = BlockType.VERTICAL) -> void:
	match type:
		BlockType.VERTICAL:
			container = VBoxContainer.new()
		BlockType.HORIZONTAL:
			container = HBoxContainer.new()

	container.add_theme_constant_override("separation", 0)
	add_child(container)


# Add a widget to the block
func add_widget(name: String, widget: DebugWidget) -> void:
	container.add_child(widget)
	widgets[name] = widget
