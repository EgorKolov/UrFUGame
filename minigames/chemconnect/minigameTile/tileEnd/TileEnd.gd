class_name TileEnd
extends "res://minigames/chemconnect/minigameTile/MinigameTile.gd"


var in_sprites: Array
var inX: Array = [0, 0]
var inY: Array = [0, 0]
var active: bool = false
var input_elements: Array = []


func _ready():
	in_sprites = [get_node("In_1_0"), get_node("In_-1_0"), get_node("In_0_-1"), get_node("In_0_1")]
	animate()

func init(x = 0, y = 0, pos = Vector2(0, 0)) -> void:
	.init(x, y, pos)


func emit(emit_dir = Vector2(0, 0)) -> Vector2:
	if(emit_dir.x == 1):
		inX[0] = 1
	elif(emit_dir.x == -1):
		inX[1] = 1
	elif(emit_dir.y == 1):
		inY[0] = 1
	elif(emit_dir.y == -1):
		inY[1] = 1
	if(inX.has(1) or inY.has(1)):
		active = true
		animate()
		return Vector2(-1, -1)
	animate()
	return Vector2(0, 0)


func animate():
	if(!.try_animate()):
		return
	
	if(!do_animate):
		return
	for t in [0, 1]:
		in_sprites[t].visible = bool(inX[t])
		in_sprites[t + 2].visible = bool(inY[t])
	
	if(active):
		$Gem.frame = 1
	else:
		$Gem.frame = 0

func deactivate() -> void:
	active = false
	input_elements = []
	for t in [0, 1]:
		inX[t] = 0
		inY[t] = 0
	animate()

func add_input(element: String = "C") -> void:
	input_elements.append(element)
	input_elements.sort()

func end() -> void:
	$Background.frame = 1
