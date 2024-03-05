class_name Idle
extends State

const WANDER_STATE: String = "wander"
const ENGAGED_STATE: String = "engaged"

@export var parent: Character
@export var detection_component: DetectionComponent
@export var idle_timer: Timer

func _ready() -> void:
	if detection_component:
		detection_component.actor_entered.connect(_actor_entered_nearby)

func enter() -> void:
	set_wait_timer()


func exit() -> void:
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
	

func _actor_entered_nearby(body: Node2D) -> void:
	if body is Character and parent != self:
		if body._faction != parent._faction:
			transitioned.emit(self, ENGAGED_STATE)
