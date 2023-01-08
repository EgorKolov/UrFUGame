extends Node


var hp: int = 5
var weapons: Array = []
var equipped_weapon_index = 0
var level_number = -1

func get_next_level(count_levels) -> int:
	if count_levels - 1 == level_number:
		level_number = 0
	else:
		level_number += 1
	return level_number
