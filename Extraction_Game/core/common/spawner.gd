class_name Spawner
extends Marker2D

signal enemy_created(enemy: Zombie)

@export var enemy: PackedScene
@export var spawn_timer: Timer
@export var spawn_rate: float = 30

func _ready() -> void:
	_validate()
	spawn_timer.start(spawn_rate)
	

func on_timer_timeout() -> void:
	pass
	#var new_enemy = enemy.instantiate()
	#enemy_created.emit(new_enemy)
	
	
	
func _validate() -> void:	
	if !enemy:
		push_error("Missing Enemy Type on: ", self)
		
	if spawn_timer:
		spawn_timer.connect("timeout", on_timer_timeout)
	else:
		push_error("Missing Timer Type on: ", self)
		
	if spawn_rate == 30:
		push_warning("Timer set to defauly 30s. Was this intended?")
