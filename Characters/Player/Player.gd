extends Character
class_name Player

onready var sword = get_node("Sword")
	
func _process(_delta: float) -> void:
	if velocity.x > 0:
		animated_sprite.flip_h = false
		sword.scale.x = 1
	if velocity.x < 0:
		animated_sprite.flip_h = true
		sword.scale.x = -1
	

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
