class_name TileBorder
extends "res://minigames/chemconnect/minigameTile/MinigameTile.gd"


var dir: Vector2
var element: String


func _ready():
	pass


func init(x = 0, y = 0, pos = Vector2(0, 0), text = "", emit_dir = Vector2(0, 0)) -> void:
	.init(x, y, pos)
	element = text
	$TileLabel.set_text(element)
	dir = emit_dir

func emit(emit_dir = Vector2(0, 0)) -> Vector2:
	if(emit_dir != Vector2(0, 0)):
		return Vector2(0, 0)
	return coords + dir

func deactivate() -> void:
	pass

func end() -> void:
	pass
