class_name WanderZombie
extends State

const IDLE_STATE: String = "idle zombie"
const FOLLOW_STATE: String = "follow zombie"

@export var parent: Zombie
@export var detection_component: DetectionComponent

var _move_direction: Vector2

@onready var wander_timer: Timer = $WanderTimer

func _ready() -> void:
	if detection_component:
		detection_component.actor_entered.connect(_actor_entered_nearby)
		

func enter() -> void:
	print("Wander Start")
	randomize_wander()


func exit() -> void:
	print("Wander End")
	wander_timer.stop()
	parent.velocity = Vector2.ZERO
	

func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	if parent:
		parent.velocity = _move_direction * parent._move_speed


func randomize_wander() -> void:
	_move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_timer.wait_time = randf_range(1, 3)
	
	
func _on_wander_timer_timeout() -> void:
	var rand: int = randi() % 2
	
	if rand:
		randomize_wander()
	else:
		transitioned.emit(self, IDLE_STATE)
		

func _actor_entered_nearby(_body: Node2D) -> void:
	transitioned.emit(self, FOLLOW_STATE)
