class_name AttackZombie
extends State

@export var parent: Zombie
@export var detection_component : DetectionComponent
@export var damage: int

var nearby_actors: Dictionary = {}
var target: Character
var can_attack: bool = true
var hitbox_node_path: String = 'Components/HitBoxComponent'
var attack_state: String = "attack zombie"
var wander_state: String = "wander zombie"

@onready var attack_timer: Timer = $AttackTimer

func _ready():
	if detection_component:
		detection_component.actor_entered.connect(_add_nearby_actor)
		detection_component.actor_left.connect(_remove_nearby_actor)


func enter():
	for actor in detection_component.get_overlapping_bodies():
		if actor != parent:
			nearby_actors[actor.name.to_lower()] = actor
	parent.velocity = Vector2.ZERO
	_pick_random_target()
	

func exit():
	target = null
	
	
func update(_delta: float):
	if !target:
		_pick_random_target()
		
	if can_attack:
		if target.has_node(hitbox_node_path):
			var hitbox = target.get_node(hitbox_node_path) as HitBoxComponent
			hitbox.zombie_hit(damage)
			can_attack = false
			attack_timer.start()
				

func physics_update(_delta: float):
	pass
	
	
func _pick_random_target():
	var size = nearby_actors.size()
	var random_target = nearby_actors.keys()[randi() % size]
	target = nearby_actors[random_target]


func _add_nearby_actor(body):
	nearby_actors[body.name.to_lower()] = body
	transitioned.emit(self, attack_state)
	

func _remove_nearby_actor(body):
	nearby_actors.erase(body.name.to_lower())
	
	if nearby_actors.size() <= 0:
		transitioned.emit(self, wander_state)


func _on_attack_timer_timeout():
	can_attack = true
