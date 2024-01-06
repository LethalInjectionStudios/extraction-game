class_name FollowZombie
extends State

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
	_find_closest_target()
	

func exit():
	parent.velocity = Vector2.ZERO
	target = null
	
	
func update(_delta: float):
	if !target:
		_find_closest_target()	

func physics_update(_delta: float):
	if parent and target:
		parent.velocity = (target.position - parent.position).normalized() * parent.move_speed
	
	
func _find_closest_target():
	var distance = 100000000000
	for key in nearby_actors:
		var actor = nearby_actors[key]
		if actor.position.distance_to(parent.position):
			target = actor
			distance = target.position.distance_to(parent.position)

func _add_nearby_actor(body):
	nearby_actors[body.name.to_lower()] = body
	print(body.name)
	transitioned.emit(self, "follow zombie")
	
func _remove_nearby_actor(body):
	nearby_actors.erase(body.name.to_lower())
	
	if nearby_actors.size() <= 0:
		transitioned.emit(self, "wander zombie")
		
func _fight_nearby_actor(body):
	transitioned.emit(self, "attack zombie")
