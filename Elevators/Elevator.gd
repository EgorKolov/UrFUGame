extends Area2D

onready var colision_shape = get_node("CollisionShape2D")


func _on_Elevator_body_entered(body: KinematicBody2D) -> void:
	colision_shape.set_deferred("disabled", true)
	SceneTransistior.start_transition_to("res://UrfuGame.tscn")
	
