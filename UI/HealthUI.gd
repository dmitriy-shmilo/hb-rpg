extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var heartUIFull = $HeartUIFull
onready var heartUIEmpty = $HeartUIEmpty

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heartUIFull != null:
		heartUIFull.rect_size.x = hearts * 15
	
func set_max_hearts(value):
	max_hearts = max(1, value)
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = max_hearts * 15
	
func _ready():
	self.max_hearts = PlayerStats.maxHealth
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
	
	