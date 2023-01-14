class_name MinigameChemconnect
extends Control

signal minigame_end

var tile_grid: Array = []
var emitter_tiles: Array = []
var redirect_tile_coords: Array = []
var end_tile: TileEnd

var tile_size: int = 100

var valid_element_set: Array = []
var end: bool = false
var grid_locked: bool = false
var active: bool = false

func _ready():
	pass

func _process(_delta):
	if(!active):
		return
	
	if(end):
		if(!grid_locked):
			for t in tile_grid:
				for i in t:
					i.end()
			emit_signal("minigame_end")
			grid_locked = true
			yield(get_tree().create_timer(1.0), "timeout")
			get_tree().change_scene("res://UrfuGame.tscn")
		pass
	
	for t in tile_grid:
		for i in t:
			i.deactivate()
	
	for t in emitter_tiles:
		var xy = t.emit(Vector2(0, 0))
		var xy_old = xy
		var dir = t.dir
		var redirects_used = make_bool_array(redirect_tile_coords.size())
		var tile = tile_grid[xy.y][xy.x]
		while(true):
			if(redirect_tile_coords.has(xy)):
				if(redirects_used[redirect_tile_coords.find(xy)] == true):
					break
				redirects_used[redirect_tile_coords.find(xy)] = true
			
			xy = tile_grid[xy.y][xy.x].emit(dir)
			
			if(xy == Vector2(0, 0)):
				break
			if(xy == Vector2(-1, -1)):
				tile.add_input(t.element)
				break
			dir = xy - xy_old
			xy_old = xy
			tile = tile_grid[xy.y][xy.x]
	
	if(end_tile.input_elements == valid_element_set):
		end = true


func init(width: int = 6, height: int = 6, chem: String = "H2O"):
	if(width < 5):
		width = 5
	if(height < 5):
		height = 5
	
	valid_element_set = get_emitters(chem)
	valid_element_set.sort()
	
	var random = RandomNumberGenerator.new()
	random.randomize()
	var scene_tile_border = load("res://minigames/chemconnect/minigameTile/tileBorder/TileBorder.tscn")
	var scene_tile_standard = load("res://minigames/chemconnect/minigameTile/tileStandard/TileStandard.tscn")
	var scene_tile_redirect = load("res://minigames/chemconnect/minigameTile/tileRedirect/TileRedirect.tscn")
	var scene_tile_end = load("res://minigames/chemconnect/minigameTile/tileEnd/TileEnd.tscn")
	
	rect_size = Vector2(width * tile_size, height * tile_size)
	
	var emitters = get_emitters(chem)
	
	var index_w = width - 1
	var index_h = height - 2
	var end_index = random.randi_range(0, (index_w - 1) * index_h - 1)
	var planned_emitter_tiles = []
	var planned_redirect_tiles = []
	
	build_board(random, index_w, index_h, end_index, emitters, planned_emitter_tiles, planned_redirect_tiles)
	
	var border_count = 0
	var index = 0
	var emitter_count = 0
	
	for y in range(height):
		var tile_row = []
		for x in range(width):
			if(x == 0 or y == 0 or x == index_w or y == index_h + 1):
				tile_row.append(scene_tile_border.instance())
				if(emitter_count < planned_emitter_tiles.size() and planned_emitter_tiles[emitter_count] == border_count):
					tile_row[x].init(x, y, calc_pos(x, y), emitters[emitter_count], pick_emit(x, y, index_w))
					emitter_tiles.append(tile_row[x])
					emitter_count += 1
				else:
					tile_row[x].init(x, y, calc_pos(x, y))
				border_count += 1
			elif(planned_redirect_tiles.has(index)):
				tile_row.append(scene_tile_redirect.instance())
				tile_row[x].init(x, y, calc_pos(x, y), make_random_dir(random))
				redirect_tile_coords.append(tile_row[x].coords)
				index += 1
			elif(end_index == index):
				tile_row.append(scene_tile_end.instance())
				tile_row[x].init(x, y, calc_pos(x, y))
				end_tile = tile_row[x]
				index += 1
			else:
				tile_row.append(scene_tile_standard.instance())
				tile_row[x].init(x, y, calc_pos(x, y))
				index += 1
			add_child(tile_row[x])
		tile_grid.append(tile_row)
	
	_process(0)
	while(end):
		end = false
		for t in redirect_tile_coords:
			tile_grid[t.y][t.x].queue_free()
			tile_grid[t.y][t.x] = scene_tile_redirect.instance()
			tile_grid[t.y][t.x].init(t.x, t.y, t, make_random_dir(random))
		_process(0)
	
	for t in tile_grid:
		for i in t:
			i.do_animate = true
	active = true


func get_emitters(chem: String) -> Array:
	if(chem == "H2O"):
		return ["H", "H", "O"]
	if(chem == "O2"):
		return ["O", "O"]
	return ["C"]

func calc_pos(x: int, y: int) -> Vector2:
	return rect_position + Vector2(x * tile_size, y * tile_size)

func pick_emit(x: int, y: int, index_w: int) -> Vector2:
	if(x == 0):
		return Vector2(1, 0)
	if(x == index_w):
		return Vector2(-1, 0)
	if(y == 0):
		return Vector2(0, 1)
	return Vector2(0, -1)

func build_board(random: RandomNumberGenerator, index_w: int, index_h: int, end_index: int, emitters: Array, planned_emitter_tiles: Array, planned_redirect_tiles: Array):
	var emitter_count = 0
	var proper_emitter_found = false
	var invalid_emitter_tiles = [index_w, index_h * 2 + index_w + 1]
	
	planned_emitter_tiles.clear()
	planned_redirect_tiles.clear()
	
	while(emitter_count < emitters.size()):
		var index = random.randi_range(1, index_w * 2 + index_h * 2)
		
		if(!proper_emitter_found):
			var coords = index_to_coords_border(index, index_w, index_h)
			var end_coords = index_to_coords_inside(end_index, index_w)
			if(coords.x != end_coords.x and coords.y != end_coords.y):
				proper_emitter_found = true
		
		if(!invalid_emitter_tiles.has(index) and !planned_emitter_tiles.has(index) and proper_emitter_found):
			planned_emitter_tiles.append(index)
			emitter_count += 1
	
	for t in emitter_count:
		var xy = index_to_coords_border(planned_emitter_tiles[t], index_w, index_h)
		var index: int
		
		if(xy.x == 0 or xy.x == index_w):
			index = random.randi_range(1, index_w - 1)
		else:
			index = random.randi_range(1, index_h)
		
		if(xy.x == 0):
			xy.x += index
		elif(xy.x == index_w):
			xy.x -= index
		elif(xy.y == 0):
			xy.y += index
		else:
			xy.y -= index
		
		var redirect_index = coords_to_index(xy, index_w)
		
		if(end_index != redirect_index):
			if(planned_redirect_tiles.has(redirect_index)):
				continue
			planned_redirect_tiles.append(redirect_index)
		else:
			t -= 1
			continue
		
		var last_redirect = index_to_coords_inside(planned_redirect_tiles[planned_redirect_tiles.size() - 1], index_w)
		xy = index_to_coords_inside(end_index, index_w)
		
		if(last_redirect.x == xy.x or last_redirect.y == xy.y):
			continue
			
		while(true):
			if(index_w > index_h):
				index = random.randi_range(1, index_w - 1)
			else:
				index = random.randi_range(1, index_h - 1)
			
			if(index == xy.x):
				xy.x = last_redirect.x
				break
			elif(index == xy.y):
				xy.y = last_redirect.y
				break
		
		planned_redirect_tiles.append(coords_to_index(xy, index_w))
	
	planned_emitter_tiles.sort()
	planned_redirect_tiles.sort()

func index_to_coords_border(index: int, index_w: int, index_h: int) -> Vector2:
	if(index <= index_w):
		return Vector2(index, 0)
	if(index > index_w + index_h * 2):
		return Vector2(index - (index_w + index_h * 2 + 1), index_h + 1)
	if(index_w % 2 == 0):
		if(index % 2 == 0):
# warning-ignore:integer_division
			return Vector2(index_w, (index - index_w) / 2)
# warning-ignore:integer_division
		return Vector2(0, (index - index_w) / 2 + 1)
	else:
		if(index % 2 == 0):
# warning-ignore:integer_division
			return Vector2(0, (index - index_w) / 2 + 1)
# warning-ignore:integer_division
		return Vector2(index_w, (index - index_w) / 2)

func index_to_coords_inside(index: int, index_w: int) -> Vector2:
	index_w -= 1
# warning-ignore:integer_division
	return Vector2(index % index_w + 1, index / index_w + 1)

func coords_to_index(xy: Vector2, index_w: int) -> int:
	index_w -= 1
	return int(xy.x - 1 + (xy.y - 1) * index_w)

func make_random_dir(random: RandomNumberGenerator) -> Vector2:
	var x = random.randi_range(-1, 1)
	if(x != 0):
		return Vector2(x, 0)
	var arr = [-1, 1]
	return Vector2(0, arr[random.randi_range(0, 1)])

func make_bool_array(length: int) -> Array:
	var arr = []
	for t in length:
		arr.append(false)
	return arr
