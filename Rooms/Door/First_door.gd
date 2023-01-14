extends StaticBody2D


onready var animation = get_node("AnimationPlayer")

func open() -> void:
	animation.play("open")
