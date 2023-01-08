extends Node2D
class_name Sword

onready var sword_animation: AnimationPlayer = get_node("SwordAnimation")
onready var sword_hitbox: Area2D = get_node("SwordNode/Sprite/Hitbox")
onready var sword: Node2D = get_node("SwordNode")

func _process(_delta: float) -> void:
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	sword_hitbox.knockback_direction = mouse_direction
	
	
		
func _ready():
	pass 

