class_name FollowZombie
extends State

const WANDER_STATE: String = "wander zombie"
const FOLLOW_STATE: String = "follow zombie"
const ATTACK_STATE: String = "attack zombie"

@export var parent: Zombie
@export var detection_component : DetectionComponent
@export var fight_component : DetectionComponent

var nearby_actors: Dictionary = {}
var target: Character

func _ready():
	if detection_component:
		detection_component.actor_entered.connect(_add_nearby_actor)
		detection_component.actor_left.connect(_remove_nearby_actor)
		
	if fight_component:
		fight_component.actor_entered.connect(_fight_nearby_actor)

func enter():
	print("Follow Start")
	_find_closest_target()
	

func exit():
	print("Follow End")
	parent.velocity = Vector2.ZERO
	target = null
	
	
func update(_delta: float):
	if !target:
		_find_closest_target()


func physics_update(_delta: float):
	if parent and target:
		parent.velocity = (target.position - parent.position).normalized() * parent._move_speed
	
	
func _find_closest_target():
	var _distance = 100000000000
	for key in nearby_actors:
		var actor = nearby_actors[key]
		if actor.position.distance_to(parent.position):
			target = actor
			_distance = target.position.distance_to(parent.position)
			
	if nearby_actors.size() == 0:
		transitioned.emit(self, WANDER_STATE)


func _add_nearby_actor(body):
	nearby_actors[body.name.to_lower()] = body
	transitioned.emit(self, FOLLOW_STATE)
	
	
func _remove_nearby_actor(body):
	nearby_actors.erase(body.name.to_lower())
	
	if nearby_actors.size() <= 0:
		transitioned.emit(self, WANDER_STATE)
	
		
func _fight_nearby_actor(_body):
	transitioned.emit(self, ATTACK_STATE)
