extends Navigation2D

const start_rooms: Array = [preload("res://Art/Rooms/NewRoom.tscn")]
const fight_rooms: Array = [preload("res://Art/Rooms/FightRoom2.tscn"),
preload("res://Art/Rooms/FightRoom.tscn")]

const tile_size = 8
const floor_tile_index = 14
const right_wall_tile_index = 12
const left_wall_tile_index = 0
export(int) var num_levels = 4


onready var player: KinematicBody2D = get_parent().get_node("Player")


func _ready() -> void:
	_create_rooms()


func _create_rooms() -> void:
	var previous_room: Node2D

	for i in num_levels:
		var room: Node2D

		if i == 0:
			room = start_rooms[randi() % start_rooms.size()].instance()
			player.position = room.get_node("PlayerSpawnPosition").position
		else:
			room = fight_rooms[randi() % fight_rooms.size()].instance()

			var previous_room_tilemap: TileMap = previous_room.get_node("TileMap")
			var previous_room_door = previous_room.get_node("Doors/FirstDoor")
			var exit_tile_pos: Vector2 = previous_room_tilemap.world_to_map(previous_room_door.position) + Vector2.UP
			var corridor_height: int = randi () % 5 + 10
			for y in corridor_height + 2:
				previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(-4, -y + 4), left_wall_tile_index)
				for j in range(-3, 3):
					previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(j, -y + 4), floor_tile_index)
				previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(3, -y + 4), right_wall_tile_index)

			var room_tilemap = room.get_node("TileMap3")
			#room.position = previous_room_door.global_position + Vector2.UP * room_tilemap.get_used_rect().size.y * tile_size + Vector2.UP * (1 + corridor_height) * tile_size + Vector2.LEFT  * room_tilemap.world_to_map(room.get_node("Entrance/Position2D").position).x * tile_size
			previous_room_door.global_position += Vector2.LEFT * 2 + Vector2.DOWN * 2
			room.position = previous_room.position + previous_room_door.position + Vector2.UP * (room.get_node("Entrance/Position2D").position.y + (corridor_height - 1) * tile_size) + Vector2.LEFT * room.get_node("Entrance/Position2D").position.x
		var camera_limit = room.get_node("CameraLimit")
		
		
		
		add_child(room)
		previous_room = room
		
		
		
		
