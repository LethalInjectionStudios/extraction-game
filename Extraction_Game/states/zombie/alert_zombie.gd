class_name AlertZombie
extends State

const FOLLOW_STATE: String = "follow zombie"
const WANDER_STATE: String = "wander zombie"

@export var parent: Zombie
@export var detection_component: DetectionComponent

var target_position: Vector2

func _ready() -> void:
	_validate()

func enter() -> void:
	pass

	
func exit() -> void:
	pass

	
func update(_delta: float) -> void:
	if target_position.distance_to(parent.global_position) <= 5:
		transitioned.emit(self, WANDER_STATE)

	
func physics_update(_delta: float) -> void:
	if parent and target_position:
		parent.velocity = (target_position - parent.global_position).normalized() * parent._move_speed
	
		
func _actor_entered_nearby(body: Node2D) -> void:
	if body._faction != parent._faction:
		transitioned.emit(self, FOLLOW_STATE)
	
	
func _validate() -> void:
	if !parent:
		push_error("Missing Parent on: ", self)
		
	if detection_component:
		detection_component.actor_entered.connect(_actor_entered_nearby)
	else:
		push_error("Missing Detection Component on: ", self)

