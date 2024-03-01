class_name AttackZombie
extends State

const ATTACK_STATE: String = "attack zombie"
const WANDER_STATE: String = "wander zombie"
const FOLLOW_STATE: String = "follow zombie"

@export var parent: Zombie
@export var detection_component : DetectionComponent
@export var damage: int

var nearby_actors: Dictionary = {}
var target: Character
var can_attack: bool = true
var hitbox_node_path: String = 'Components/HitBoxComponent'

@onready var attack_timer: Timer = $AttackTimer

func _ready() -> void:
	if detection_component:
		detection_component.actor_entered.connect(_add_nearby_actor)
		detection_component.actor_left.connect(_remove_nearby_actor)


func enter() -> void:
	print("Attack Start")
	for actor: Node2D in detection_component.get_overlapping_bodies():
		if actor != parent:
			nearby_actors[actor.name.to_lower()] = actor
	parent.velocity = Vector2.ZERO
	_pick_random_target()
	

func exit() -> void:
	print("Attack End")
	attack_timer.stop()
	target = null
	
	
func update(_delta: float) -> void:
	if !target:
		_pick_random_target()
		
	if can_attack:
		if target.has_node(hitbox_node_path):
			var hitbox: HitBoxComponent = target.get_node(hitbox_node_path) as HitBoxComponent
			hitbox.zombie_hit(damage)
			can_attack = false
			attack_timer.start()
				

func physics_update(_delta: float) -> void:
	pass
	
	
func _pick_random_target() -> void:
	var size: int = nearby_actors.size()
	var random_target: String = nearby_actors.keys()[randi() % size]
	target = nearby_actors[random_target]


func _add_nearby_actor(body: Node2D) -> void:
	nearby_actors[body.name.to_lower()] = body
	transitioned.emit(self, ATTACK_STATE)
	

func _remove_nearby_actor(body: Node2D) -> void:
	nearby_actors.erase(body.name.to_lower())
	
	if nearby_actors.size() <= 0:
		transitioned.emit(self, FOLLOW_STATE)


func _on_attack_timer_timeout() -> void:
	can_attack = true
