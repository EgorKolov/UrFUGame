extends Node2D
class_name Sword

onready var sword_animation: AnimationPlayer = get_node("SwordAnimation")
onready var sword: Node2D = get_node("SwordNode")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_attack") and not sword_animation.is_playing():
		sword_animation.play("attack")
	
		
func _ready():
	pass 
