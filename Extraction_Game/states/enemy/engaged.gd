class_name Engaged
extends State

const ENGAGED_STATE: String = "engaged"
const WANDER_STATE: String = "wander"

@export var parent: EnemyBase
@export var weapon_component: WeaponComponent
@export var wander_timer: Timer
@export var attack_timer: Timer

var nearby_actors: Dictionary = {}
var target: Character
var move_direction: Vector2
var can_fire: bool = true

func _ready():
	pass

func enter():
	_find_closest_target()
	randomize_wander()
	#attack_timer.wait_time = weapon_component.rate_of_fire

	
func exit():
	parent.velocity = Vector2.ZERO
	target = null

	
func update(_delta):
	if is_instance_valid(target):
		if target.position.x < parent.position.x:
			parent.sprite.flip_h = true
			weapon_component.weapon_sprite.scale.y = Globals.negative_weapon_component_scale
		else:
			parent.sprite.flip_h = false
			weapon_component.weapon_sprite.scale.y = Globals.positive_weapon_component_scale
			
		weapon_component.weapon_sprite.look_at(target.position)
		weapon_component.fire_weapon(target.position)
		
		if weapon_component.magazine_count == 0:
			weapon_component.reload_weapon()
		
	if !target:
		_find_closest_target()

	
func physics_update(_delta):
	if parent:
		parent.velocity = move_direction * parent._move_speed


func _find_closest_target():
	var _distance = 100000000000
	for key in nearby_actors:
		var actor = nearby_actors[key]
		if actor.position.distance_to(parent.position):
			target = actor
			_distance = target.position.distance_to(parent.position)
			
			
func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_timer.wait_time = randf_range(1, 3)


func _add_nearby_actor(body: Node2D) -> void:
	print("Engaged" + str(body))
	if body is Character:
		nearby_actors[body.name.to_lower()] = body
		transitioned.emit(self, ENGAGED_STATE)


func _remove_nearby_actor(body):
	nearby_actors.erase(body.name.to_lower())
	
	if nearby_actors.size() <= 0:
		transitioned.emit(self, WANDER_STATE)
		
