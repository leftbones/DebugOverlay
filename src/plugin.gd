@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_autoload_singleton("DebugOverlay", "res://addons/debug_overlay/debug_overlay.tscn")


func _exit_tree() -> void:
	remove_autoload_singleton("DebugOverlay")
