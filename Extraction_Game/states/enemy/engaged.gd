class_name Engaged
extends State

signal alerted(position: Vector2)

const ENGAGED_STATE: String = "engaged"
#const WANDER_STATE: String = "wander"
const ALERT_STATE: String = "alert"

@export var parent: EnemyBase
@export var weapon_component: WeaponComponent
@export var detection_component: DetectionComponent
@export var wander_timer: Timer
@export var attack_timer: Timer

var nearby_actors: Dictionary = {}
var target: Character
var move_direction: Vector2
var can_fire: bool = true

func _ready() -> void:
	if detection_component:
		detection_component.actor_entered.connect(_actor_entered_nearby)
		detection_component.actor_left.connect(_actor_left_nearby)

func enter() -> void:
	_find_closest_target()
	randomize_wander()
	weapon_component.weapon_sprite.flip_h = false
	attack_timer.wait_time = weapon_component.rate_of_fire

	
func exit() -> void:
	parent.velocity = Vector2.ZERO
	target = null

	
func update(_delta: float) -> void:
	if is_instance_valid(target):
		if target.global_position.x < parent.global_position.x:
			parent.sprite.flip_h = true
			weapon_component.weapon_sprite.scale.y = Globals.negative_weapon_component_scale
		else:
			parent.sprite.flip_h = false
			weapon_component.weapon_sprite.scale.y = Globals.positive_weapon_component_scale
			
		weapon_component.weapon_sprite.look_at(target.position)
		weapon_component.fire_weapon(target.position)
		
		if weapon_component.magazine_count <= 0:
			print("reloaded")
			weapon_component.reload_weapon()
		
	if !target:
		_find_closest_target()

	
func physics_update(_delta: float) -> void:
	if parent:
		parent.velocity = move_direction * parent._move_speed


func _find_closest_target() -> void:
	var _distance: float = 100000000000
	for key: String in nearby_actors:
		var actor: Character = nearby_actors[key]
		if actor.position.distance_to(parent.position):
			target = actor
			_distance = target.position.distance_to(parent.position)
			
			
func randomize_wander() -> void:
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_timer.wait_time = randf_range(1, 3)


func _actor_entered_nearby(body: Node2D) -> void:
	if body is Character and body != self:
		if body._faction != parent._faction:
			nearby_actors[body.name.to_lower()] = body
			transitioned.emit(self, ENGAGED_STATE)


func _actor_left_nearby(body: Node2D) -> void:
	nearby_actors.erase(body.name.to_lower())
	
	if nearby_actors.size() <= 0:
		alerted.emit(body.global_position)
		transitioned.emit(self, ALERT_STATE)
		
