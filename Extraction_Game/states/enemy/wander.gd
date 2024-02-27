class_name Wander
extends State

const IDLE_STATE: String = "idle"
const ENGAGED_STATE: String = "engaged"

@export var parent: Character
@export var detection_component: DetectionComponent

var move_direction: Vector2

@export var wander_timer: Timer

func _ready() -> void:
	if detection_component:
		detection_component.actor_entered.connect(_actor_entered_nearby)
	wander_timer.autostart = true
		

func enter() -> void:
	randomize_wander()
	wander_timer.start()


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
	wander_timer.wait_time = randf_range(1, 3)
	wander_timer.start()
	
	
func _on_wander_timer_timeout() -> void:
	var rand: int = randi() % 2
	
	print(rand)
	if rand:
		randomize_wander()
	else:
		transitioned.emit(self, IDLE_STATE)
		

func _actor_entered_nearby(_body: Node2D) -> void:
	transitioned.emit(self, ENGAGED_STATE)
