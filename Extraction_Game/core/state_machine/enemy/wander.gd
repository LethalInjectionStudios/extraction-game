class_name Wander
extends State

signal alerted(position: Vector2)

const IDLE_STATE: String = "idle"
const ENGAGED_STATE: String = "engaged"
const ALERT_STATE: String = "string"

@export var parent: Character
@export var detection_component: DetectionComponent

var move_direction: Vector2

@export var wander_timer: Timer

func _ready() -> void:
	_validate()
	if detection_component:
		detection_component.actor_entered.connect(_actor_entered_nearby)
	wander_timer.autostart = true
		

func enter() -> void:
	randomize_wander()


func exit() -> void:
	wander_timer.stop()
	parent.velocity = Vector2.ZERO
	

func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	if parent:
		parent.velocity = move_direction * parent._move_speed


func randomize_wander() -> void:
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	#wander_timer.wait_time = randf_range(1, 3)
	wander_timer.start(randf_range(1, 3))
	
	
func _on_wander_timer_timeout() -> void:
	var rand: int = randi() % 2
	if rand:
		randomize_wander()
	else:
		transitioned.emit(self, IDLE_STATE)
		

func _actor_entered_nearby(body: Node2D) -> void:
	if body is Character and parent != self:
		if body._faction != parent._faction:
			transitioned.emit(self, ENGAGED_STATE)


func _on_actor_alerted(position: Vector2) -> void:
	alerted.emit(position)
	transitioned.emit(self, ALERT_STATE)
			
			
func _validate() -> void:
	if parent:
		parent.alerted.connect(_on_actor_alerted)
	else:
		push_error("Missing Parent on: ", self)
