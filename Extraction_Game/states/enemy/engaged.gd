class_name Engaged
extends State

@export var parent: EnemyBase
@export var detection_component: DetectionComponent
@export var weapon_component: WeaponComponent

var nearby_actors: Dictionary = {}
var target: Character
var move_direction: Vector2
var can_fire: bool = true

@onready var wander_timer: Timer = $Timers/WanderTimer
@onready var attack_timer: Timer = $Timers/AttackTimer

func _ready():
	if detection_component:
		detection_component.actor_entered.connect(_add_nearby_actor)
		detection_component.actor_left.connect(_remove_nearby_actor)

func enter():
	_find_closest_target()
	randomize_wander()
	attack_timer.wait_time = weapon_component.rate_of_fire

	
func exit():
	parent.velocity = Vector2.ZERO
	target = null

	
func update(_delta):
	if is_instance_valid(target):
		print("have targeta")
		if target.position.x < 0:
			parent.sprite.flip_h = true
			weapon_component.weapon_sprite.scale.x = Globals.negative_weapon_component_scale
		else:
			parent.sprite.flip_h = false
			weapon_component.weapon_sprite.scale.x = Globals.positive_weapon_component_scale
			
		weapon_component.weapon_sprite.look_at(target.position)
		weapon_component.fire_weapon(target.position)
		
	if !target:
		print("target not found")
		_find_closest_target()

	
func process_update(_delta):
	if parent:
		parent.velocity = move_direction * parent.move_speed


func _find_closest_target():
	var distance = 100000000000
	for key in nearby_actors:
		var actor = nearby_actors[key]
		if actor.position.distance_to(parent.position):
			target = actor
			distance = target.position.distance_to(parent.position)
	print("Closest Target: " + target.name)
			
			
func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_timer.wait_time = randf_range(1, 3)


func _add_nearby_actor(body):
	print("Adding: " + str(body.name))
	nearby_actors[body.name.to_lower()] = body
	transitioned.emit(self, "engaged")
	
func _remove_nearby_actor(body):
	nearby_actors.erase(body.name.to_lower())
	
	if nearby_actors.size() <= 0:
		transitioned.emit(self, "wander")
		
