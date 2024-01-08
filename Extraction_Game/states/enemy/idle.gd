class_name Idle
extends State

@export var detection_component: DetectionComponent

var wander_state: String = "wander"
var engaged_state: String = "engaged"

@onready var idle_timer: Timer = $IdleTimer

func _ready():
	if detection_component:
		detection_component.actor_entered.connect(_actor_entered_nearby)

func enter():
	set_wait_timer()


func exit():
	idle_timer.stop()
	

func update(delta: float):
	pass
	
	
func physics_update(delta: float):
	pass
	

func _on_idle_timer_timeout():
	var rand = randi() % 2
	
	if rand:
		set_wait_timer()
	else:
		transitioned.emit(self, wander_state)


func set_wait_timer():
	idle_timer.wait_time = randf_range(1, 5)
	idle_timer.start()
	

func _actor_entered_nearby(body):
	transitioned.emit(self, engaged_state)
