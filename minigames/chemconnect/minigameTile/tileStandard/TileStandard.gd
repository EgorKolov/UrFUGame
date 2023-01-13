class_name TileStandard
extends "res://minigames/chemconnect/minigameTile/MinigameTile.gd"


var sprite: AnimatedSprite
var ver: int = 0
var hor: int = 0

func _ready():
	sprite = $Overlay

func init(x = 0, y = 0, pos = Vector2(0, 0)) -> void:
	.init(x, y, pos)


func emit(dir = Vector2(0, 0)) -> Vector2:
	if(dir.x != 0):
		hor = 1
	elif(dir.y != 0):
		ver = 1
	else:
		return dir
	if(do_animate):
		animate()
	return coords + dir

func animate() -> void:
	if(!.try_animate()):
		return
	
	sprite.frame = ver + hor * 2

func deactivate() -> void:
	ver = 0
	hor = 0
	if(do_animate):
		animate()

func end() -> void:
	$Background.frame = 1
