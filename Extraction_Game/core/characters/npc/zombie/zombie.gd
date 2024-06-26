class_name Zombie
extends Character

@export var health_component: HealthComponent
@export var hitbox_component: HitBoxComponent
@export var idle_state: IdleZombie
@export var follow_state: FollowZombie
@export var alert_state: AlertZombie

#NOTE Not Critical for Testing
@onready var state: Label = $Label
@onready var state_machine: StateMachine = $StateMachine
@onready var _animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	_connect_signals()
	_move_speed = 25.0
	_faction = Globals.Faction.ZOMBIE

	
func _process(_delta: float) -> void:
		
	if velocity == Vector2.ZERO:
		_animation_player.play("idle")
		
	if velocity != Vector2.ZERO:
		_animation_player.play("walk")
		if velocity.x < 0:
			$Sprite.flip_h = true
		if velocity.x > 0:
			$Sprite.flip_h = false
		
	state.text = state_machine.current_state.to_string()

	
func _physics_process(_delta: float) -> void:
	move_and_slide()
	

func sound_heard(sound_position: Vector2) -> void:
	alerted.emit(sound_position)
	
func _connect_signals() -> void:
	if health_component:
		health_component.destroyed.connect(_on_actor_destroyed)
	else:
		push_warning("Missing Health Component on: ", self)
		
	if hitbox_component:
		hitbox_component.hit_taken.connect(_on_actor_hit_taken)
	else:
		push_error("Missing Hitbox Component on: ", self)
		
	if idle_state:
		idle_state.alerted.connect(_on_actor_alerted)
	else:
		push_error("Missing Idle State on: ", self)
		
	if follow_state:
		follow_state.alerted.connect(_on_actor_alerted)
	else:
		push_warning("Missing Follow State on: ", self)
		
	if !alert_state:
		push_error("Missing Alert State on: ", self)
		


func _on_actor_destroyed() -> void:
	queue_free()
	
	
func _on_actor_hit_taken(projectile: Projectile) -> void:
	health_component.damage(projectile.damage)


func _on_actor_alerted(last_known_position: Vector2) -> void:
	alert_state.target_position = last_known_position
