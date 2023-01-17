extends Navigation2D

export(int) var num_levels = 4
onready var player: KinematicBody2D = get_parent().get_node("Player")
class_name Rooms

class Dungeon:
	var start_rooms: Array
	var fight_rooms: Array
	var end_rooms: Array
	var door: String
	var wall_indexes: Walls
	var tile_size: int
	func _init(_start_rooms, _fight_rooms, _end_rooms, _door, _wall_indexes, _tile_size):
		start_rooms = _start_rooms
		fight_rooms = _fight_rooms
		end_rooms = _end_rooms
		door = _door
		wall_indexes = _wall_indexes
		tile_size = _tile_size


class Walls:
	var floor_tile_index: int
	var right_wall_tile_index: int
	var left_wall_tile_index: int
	func _init(_floor_tile_index, _right_wall_tile_index, _left_wall_tile_index):
		floor_tile_index = _floor_tile_index
		right_wall_tile_index = _right_wall_tile_index
		left_wall_tile_index = _left_wall_tile_index

		
var dungeons = [
	Dungeon.new([preload("res://Rooms/Dungeon/NewRoom.tscn")],
				[preload("res://Rooms/Dungeon/FightRoom2.tscn"), preload("res://Rooms/Dungeon/FightRoom.tscn")],
				[preload("res://Rooms/Dungeon/EndRoom.tscn")],
				"Doors/FirstDoor",
				Walls.new(14, 12, 0),
				8),
	Dungeon.new([preload("res://Rooms/FirstFloor/StartRoom2.tscn")],
				[preload("res://Rooms/FirstFloor/Dungeon2_FightRoom2.tscn"),
				preload("res://Rooms/FirstFloor/Dungeon2_FightRoom1.tscn")],
				[preload("res://Rooms/FirstFloor/Dungeon2_EndRoom.tscn")],
				"Doors/SecondDoor",
				Walls.new(1, 0, 0),
				16)
	]
var count_minigames = 1

func _ready() -> void:
	var dungeon_number = SavedData.get_next_level(len(dungeons) + count_minigames * 2)
	if dungeon_number % 2 == 1:
		_create_minigame()
	else:
		dungeon_number /= 2
		var dungeon = dungeons[dungeon_number]
		_create_rooms(dungeon_number, dungeon)

func _create_minigame():
	var minigame = get_parent().get_node("Chemconnect")
	var camera: Camera2D = player.get_node("Camera")
	var health_bar = get_parent().get_node("HealthBar")
	var vision = get_parent().get_node("CanvasModulate")
	camera.zoom = Vector2(4, 4)
	player.position = minigame.get_node("PlayerSpawnPosition").position
	minigame.init(10, 10)
	player.hide()
	health_bar.hide()
	vision.hide()
	
	
func _create_rooms(dungeon_number, dungeon) -> void:
	var previous_room: Node2D
	for i in num_levels:
		var room: Node2D
		if i == 0:
			room = dungeon.start_rooms[randi() % dungeon.start_rooms.size()].instance()
			player.position = room.get_node("PlayerSpawnPosition").position
		else:
			if i == num_levels - 1:
				room = dungeon.end_rooms[randi() % dungeon.end_rooms.size()].instance()
			else:
				room = dungeon.fight_rooms[randi() % dungeon.fight_rooms.size()].instance()
			var previous_room_tilemap: TileMap = previous_room.get_node("TileMap")
			var previous_room_door = previous_room.get_node(dungeon.door)
			var exit_tile_pos: Vector2 = previous_room_tilemap.world_to_map(previous_room_door.position) + Vector2.UP
			var corridor_height: int = randi () % 5 + 10
			_create_corridor(dungeon_number, corridor_height, exit_tile_pos, previous_room_tilemap, dungeon.wall_indexes)
			previous_room_door.global_position += Vector2.LEFT * 2 + Vector2.DOWN * 2
			room.position = previous_room.position + previous_room_door.position + Vector2.UP * (room.get_node("Entrance/Position2D").position.y + (corridor_height - 1) * dungeon.tile_size) + Vector2.LEFT * room.get_node("Entrance/Position2D").position.x

		add_child(room)
		previous_room = room
		
		
func _create_corridor(dungeon_number, corridor_height, exit_tile_pos, previous_room_tilemap, walls):
	if dungeon_number == 0:
		for y in corridor_height + 2:
			previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(-4, -y + 4), walls.left_wall_tile_index)
			for j in range(-3, 3):
				previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(j, -y + 4), walls.floor_tile_index)
			previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(3, -y + 4), walls.right_wall_tile_index)
	if dungeon_number == 1:
		for y in corridor_height / 2 - 1:
			previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(-2, -y), walls.left_wall_tile_index)
			for j in range(-1, 2):
				previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(j, -y), walls.floor_tile_index)
			previous_room_tilemap.set_cellv(exit_tile_pos + Vector2(2, -y), walls.right_wall_tile_index)


