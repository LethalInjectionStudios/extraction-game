class_name IdleZombie
extends State

const WANDER_STATE: String = "wander zombie"
const FOLLOW_STATE: String = "follow zombie"

@export var detection_component: DetectionComponent

@onready var idle_timer: Timer = $IdleTimer

func _ready() -> void:
	if detection_component:
		detection_component.actor_entered.connect(_actor_entered_nearby)

func enter() -> void:
	print("Idle Start")
	set_wait_timer()


func exit() -> void:
	print("Idle Stop")
	idle_timer.stop()
	

func update(_delta: float) -> void:
	pass
	
	
func physics_update(_delta: float) -> void:
	pass
	

func _on_idle_timer_timeout() -> void:
	var rand: int = randi() % 2
	
	if rand:
		set_wait_timer()
	else:
		transitioned.emit(self, WANDER_STATE)


func set_wait_timer() -> void:
	idle_timer.wait_time = randf_range(1, 5)
	idle_timer.start()
	

func _actor_entered_nearby(_body: Node2D) -> void:
	transitioned.emit(self, FOLLOW_STATE)
