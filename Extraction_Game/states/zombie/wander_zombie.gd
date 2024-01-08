class_name WanderZombie
extends State

@export var parent: Zombie
@export var detection_component: DetectionComponent

var move_direction: Vector2
var idle_state: String = "idle zombie"
var follow_state: String = "follow zombie"

@onready var wander_timer: Timer = $WanderTimer

func _ready():
	if detection_component:
		detection_component.actor_entered.connect(_actor_entered_nearby)
		

func enter():
	randomize_wander()


func exit():
	wander_timer.stop()
	parent.velocity = Vector2.ZERO
	

func update(delta: float):
	pass


func physics_update(delta: float):
	if parent:
		parent.velocity = move_direction * parent.move_speed


func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_timer.wait_time = randf_range(1, 3)
	#wander_timer.start()
	
	
func _on_wander_timer_timeout():
	var rand = randi() % 2
	
	if rand:
		randomize_wander()
	else:
		transitioned.emit(self, idle_state)
		

func _actor_entered_nearby(body):
	transitioned.emit(self, follow_state)
