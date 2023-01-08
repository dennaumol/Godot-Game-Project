extends Control

onready var _health_bar_over = get_node("HealthBarOver")
onready var _update_tween = get_node("UpdateTween")
onready var _health_bar_under = get_node("HealthBarUnder")
var hp_percent = 0


func update_health(hp, max_hp):
	hp_percent = hp / max_hp * 100
	_health_bar_over.value = hp_percent
	_update_tween.interpolate_property(_health_bar_under, "value", _health_bar_over.value, hp_percent, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.4)
	_update_tween.start()
	

