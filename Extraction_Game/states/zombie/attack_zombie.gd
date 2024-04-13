class_name AttackZombie
extends State

const ATTACK_STATE: String = "attack zombie"
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
	_validate()


func enter() -> void:
	can_attack = true
	for actor: Node2D in detection_component.get_overlapping_bodies():
		if actor != parent:
			nearby_actors[actor.name.to_lower()] = actor
			print(actor)
	parent.velocity = Vector2.ZERO
	_pick_random_target()
	

func exit() -> void:
	attack_timer.stop()
	target = null
	
	
func update(_delta: float) -> void:
	if !target:
		_pick_random_target()
		
	print(can_attack)
		
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
	

func _remove_nearby_actor(body: Node2D) -> void:
	nearby_actors.erase(body.name.to_lower())
	
	if nearby_actors.size() <= 0:
		transitioned.emit(self, FOLLOW_STATE)


func _on_attack_timer_timeout() -> void:
	can_attack = true
	
	
func _validate() -> void:
	if !parent:
		push_error("Missing Parent on: ", self)
		
	if detection_component:
		detection_component.actor_entered.connect(_add_nearby_actor)
		detection_component.actor_left.connect(_remove_nearby_actor)
	else:
		push_warning("Missing Detection Component on", self)
		
