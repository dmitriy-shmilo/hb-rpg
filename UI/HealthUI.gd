class_name HealthUI
extends Control

var hearts: int = 4 setget set_hearts
var max_hearts: int = 4 setget set_max_hearts

onready var _heart_ui_full: TextureRect = $HeartUIFull
onready var _heart_ui_empty: TextureRect = $HeartUIEmpty

func set_hearts(value: int):
	hearts = int(clamp(value, 0, max_hearts))
	if _heart_ui_full != null:
		_heart_ui_full.rect_size.x = hearts * 15
	
func set_max_hearts(value: int):
	max_hearts = int(max(1, value))
	if _heart_ui_empty != null:
		_heart_ui_empty.rect_size.x = max_hearts * 15
	
func _ready():
	self.max_hearts = PlayerStats.maxHealth
	self.hearts = PlayerStats.health
	var _err = PlayerStats.connect("health_changed", self, "set_hearts")
	_err = PlayerStats.connect("max_health_changed", self, "set_max_hearts")
	
	
