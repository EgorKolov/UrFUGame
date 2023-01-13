class_name MinigameTile
extends Control


var coords: Vector2
var	do_animate: bool = false


func _ready():
	pass

func init(x: int, y: int, pos: Vector2):
	coords = Vector2(x, y)
	rect_position = pos

func emit(_emit_dir = Vector2(0, 0)):
	pass

func try_animate() -> bool:
	if(!do_animate):
		return false
	return true

func deactivate() -> void:
	pass

func end() -> void:
	pass
