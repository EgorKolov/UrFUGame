class_name TileRedirect
extends "res://minigames/chemconnect/minigameTile/MinigameTile.gd"


var animator: AnimationPlayer
var dir: Vector2
var in_sprites: Array
var in_x: Array = [0, 0]
var in_y: Array = [0, 0]
var anim_state: int
var act: bool = true
var anim_playing: bool = false


func _ready():
	animator = $OverlayAnimator
	in_sprites = [get_node("In_1_0"), get_node("In_-1_0"), get_node("In_0_-1"), get_node("In_0_1")]
	animator.play("turn_%s_%s" % [anim_state - 1, anim_state])
	animate()

func init(x = 0, y = 0, pos = Vector2(0, 0), start_dir = Vector2(1, 0)) -> void:
	.init(x, y, pos)
	dir = start_dir
	if(start_dir.x > 0):
		anim_state = 1
	elif(start_dir.x < 0):
		anim_state = 3
	elif(start_dir.y < 0):
		anim_state = 0
	else:
		anim_state = 2

func emit(emit_dir = Vector2(0, 0)) -> Vector2:
	if(emit_dir.x == 1):
		in_x[0] = 1
	elif(emit_dir.x == -1):
		in_x[1] = 1
	elif(emit_dir.y == 1):
		in_y[0] = 1
	elif(emit_dir.y == -1):
		in_y[1] = 1
	animate()
	if(!anim_playing and (in_x.has(1) or in_y.has(1))):
		return coords + dir
	return Vector2(0, 0)


func animate():
	if(!.try_animate()):
		return
	
	yield(animator, "animation_finished")
	
	for t in [0, 1]:
		in_sprites[t].visible = bool(in_x[t])
		in_sprites[t + 2].visible = bool(in_y[t])
	
	if(in_x.has(1) or in_y.has(1)):
		animator.play("activate")
	else:
		animator.play("deactivate")


func _on_TextureButton_pressed():
	if(act):
		$LineOutput.visible = false
		#animator.play("turn_%s_%s" % [anim_state, anim_state + 1])
		animator.queue("turn_%s_%s" % [anim_state, anim_state + 1])
		anim_playing = true
		
		if(anim_state == 3):
			anim_state = 0
		else:
			anim_state += 1
	
		if(anim_state == 0):
			dir = Vector2(0, -1)
		elif(anim_state == 1):
			dir = Vector2(1, 0)
		elif(anim_state == 2):
			dir = Vector2(0, 1)
		else:
			dir = Vector2(-1, 0)
		animate()

func deactivate() -> void:
	for t in [0, 1]:
		in_x[t] = 0
		in_y[t] = 0
	animate()

func end() -> void:
	act = false
	$Background.frame = 1


func _on_OverlayAnimator_animation_finished(anim_name):
	if(anim_name.find("turn") != -1):
		anim_playing = false

func _on_OverlayAnimator_animation_started(anim_name):
	if(anim_name.find("turn") != -1):
		anim_playing = true
