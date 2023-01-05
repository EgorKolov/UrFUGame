extends CanvasLayer

const min_health: int = 0
var max_hp: int = 5
onready var player = get_parent().get_node("Player")
onready var health_bar = get_node("HealthBar")
onready var health_bar_tween = get_node("HealthBar/Tween")


func _ready() -> void:
	max_hp = player.max_hp
	_update_health_bar(100)


func _update_health_bar(new_value: int) -> void:
	var __ = health_bar_tween.interpolate_property(health_bar, "value", health_bar.value,
	new_value, 0.2, Tween.TRANS_QUINT, Tween.EASE_OUT)
	__ = health_bar_tween.start()


func _on_Player_hp_changed(new_hp: int) -> void:
	var new_health = int((100 - min_health) * float(new_hp) / max_hp) + min_health
	_update_health_bar(new_health)
