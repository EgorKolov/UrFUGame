extends Character
class_name Player

onready var sword = get_node("Sword")
onready var sword_animation: AnimationPlayer = get_node("Sword/SwordAnimation")
onready var sword_hitbox: Area2D = get_node("Sword/SwordNode/Sprite/Hitbox")
	
func _process(_delta: float) -> void:
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	if mouse_direction.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif mouse_direction.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true

	if mouse_direction.x > 0:
		sword.scale.x = 1
	elif mouse_direction.x < 0:
		sword.scale.x = -1
#	if velocity.x > 0:
#		animated_sprite.flip_h = false
#		sword.scale.x = 1
#	if velocity.x < 0:
#		animated_sprite.flip_h = true
#		sword.scale.x = -1
	

func get_input() -> void:
	mov_direction = Vector2.ZERO
	if Input.is_action_pressed("ui_down"):
		mov_direction += Vector2.DOWN
	if Input.is_action_pressed("ui_left"):
		mov_direction += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		mov_direction += Vector2.RIGHT
	if Input.is_action_pressed("ui_up"):
		mov_direction += Vector2.UP
	
	if Input.is_action_just_pressed("ui_attack") and not sword_animation.is_playing():
		sword_animation.play("attack")
