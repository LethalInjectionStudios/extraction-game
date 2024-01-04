class_name FollowZombie
extends State

@export var detection_component : DetectionComponent
@export var owning_actor: Zombie

var nearby_actors: Dictionary = {}
var target

func _ready():
	if detection_component:
		detection_component.actor_entered.connect(_add_nearby_actor)
		detection_component.actor_left.connect(_remove_nearby_actor)

func enter():
	_find_closest_target()
	

func exit():
	owning_actor.velocity = Vector2.ZERO
	
	
func update(_delta: float):
	if !target:
		_find_closest_target()	

func physics_update(_delta: float):
	if owning_actor and target:
		owning_actor.velocity = (target.position - owning_actor.position).normalized() * owning_actor.move_speed
	
	
func _find_closest_target():
	var distance = 100000000000
	for key in nearby_actors:
		var actor = nearby_actors[key]
		if actor.position.distance_to(owning_actor.position):
			target = actor
			distance = target.position.distance_to(owning_actor.position)

func _add_nearby_actor(body):
	nearby_actors[body.name.to_lower()] = body
	transitioned.emit(self, "follow zombie")
	
func _remove_nearby_actor(body):
	nearby_actors.erase(body.name.to_lower())
	
	if nearby_actors.size() <= 0:
		transitioned.emit(self, "wander zombie")
