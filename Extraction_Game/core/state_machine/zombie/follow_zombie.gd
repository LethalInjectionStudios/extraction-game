class_name FollowZombie
extends State

signal alerted(position: Vector2)

#const WANDER_STATE: String = "wander zombie"
#const FOLLOW_STATE: String = "follow zombie"
const ALERT_STATE: String = "alert zombie"
const ATTACK_STATE: String = "attack zombie"

@export var parent: Zombie
@export var detection_component : DetectionComponent
@export var fight_component : DetectionComponent

var nearby_actors: Dictionary = {}
var target: Character

func _ready() -> void:
	_connect_signals()


func enter() -> void:
	_find_closest_target()
	

func exit() -> void:
	parent.velocity = Vector2.ZERO
	target = null
	
	
func update(_delta: float) -> void:
	if !target:
		_find_closest_target()


func physics_update(_delta: float) -> void:
	if parent and target:
		parent.velocity = (target.position - parent.position).normalized() * parent._move_speed
	
	
func _find_closest_target() -> void:
	var _distance: float = 100000000000
	for key: String in nearby_actors:
		var actor: Character = nearby_actors[key]
		if actor.position.distance_to(parent.position):
			target = actor
			_distance = target.position.distance_to(parent.position)
			
	#if nearby_actors.size() == 0:
		#transitioned.emit(self, WANDER_STATE)


func _add_nearby_actor(body: Node2D) -> void:
	if body._faction != parent._faction:
		nearby_actors[body.name.to_lower()] = body
	
	
func _remove_nearby_actor(body: Node2D) -> void:
	nearby_actors.erase(body.name.to_lower())
	
	if nearby_actors.size() <= 0:
		alerted.emit(body.global_position)
		transitioned.emit(self, ALERT_STATE)
	
		
func _fight_nearby_actor(body: Node2D) -> void:
	if body._faction != parent._faction:
		transitioned.emit(self, ATTACK_STATE)
	

func _connect_signals() -> void:
	if !parent:
		push_error("Missing Parent on: ", self)
		
	if detection_component:
		detection_component.actor_entered.connect(_add_nearby_actor)
		detection_component.actor_left.connect(_remove_nearby_actor)
	else:
		push_error("Missing Detection Component on: ", self)
		
	if fight_component:
		fight_component.actor_entered.connect(_fight_nearby_actor)
	else:
		push_error("Missing Fight Component on: ", self)
