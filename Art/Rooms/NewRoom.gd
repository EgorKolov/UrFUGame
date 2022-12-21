extends Node2D

const enemy_scenes: Dictionary = {
	"enemy" : preload("res://Characters/Enemies/Enemy.tscn")
}


var num_enemies: int
onready var tilemap: TileMap = get_node("Navigation2D/TileMap3")
onready var enemy_positions = get_node("EnemyPositions")
onready var player_detector = get_node("PlayerDetector")
onready var doors = get_node("Doors")
onready var entrance = get_node("Entrance")


func _ready() -> void:
	num_enemies = enemy_positions.get_child_count()


func on_enemy_killed() -> void:
	num_enemies -= 1
	if num_enemies == 0:
		_open_doors()
	

func _open_doors() -> void:
	for door in doors.get_children():
		door.open()
	
		
		
func _close_entrance() -> void:
	for entry_position in entrance.get_children():
		tilemap.set_cellv(tilemap.world_to_map(entry_position.position), 0)
	
func _spawn_enemies() -> void:
	for enemy_position in enemy_positions.get_children():
		var enemy = enemy_scenes.enemy.instance()
		var __ = enemy.connect("tree_exited", self, "_on_enemy_killed")
		enemy.global_position = enemy_position.position
		call_deferred("add_child", enemy)
		
		

func _on_PlayerDetector_body_entered(body: KinematicBody2D) -> void:
	player_detector.queue_free()
	if num_enemies > 0:
		_close_entrance()
		_spawn_enemies()
		_open_doors()
	else:
		_open_doors()
		
