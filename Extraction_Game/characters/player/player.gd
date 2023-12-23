extends CharacterBody2D

var health: int
var hunger: int
var thirst: int

var inRaid: bool = false

var bullet_scene: PackedScene = preload("res://objects/projectiles/bullet.tscn")

const MAX_HEALTH: int = 100
const MAX_HUNGER: int = 100
const MAX_THIRST: int = 100
const SPEED: float = 300.0

signal fire(projectile)

func _ready():
	health = MAX_HEALTH
	hunger = MAX_HUNGER
	thirst = MAX_THIRST
	
func _process(_delta):
	$WeaponSprite.look_at(get_global_mouse_position())	
	if get_global_mouse_position().x < $WeaponSprite.global_position.x:
		$WeaponSprite.flip_v = true
	else:
		$WeaponSprite.flip_v = false
		
	if Input.is_action_just_pressed("fire"):
		var bullet = bullet_scene.instantiate() as Projectile
		var gun_direction = (get_global_mouse_position() - $WeaponSprite.global_position).normalized()
		bullet.global_position = position
		bullet.global_rotation = $WeaponSprite.rotation
		bullet.direction = gun_direction
		fire.emit(bullet)
		$Audio/GunshotAudio.play()
		
	print("Player Transform: " + str(position))
	print("Audio Transform: " + str($Audio/GunshotAudio.global_position))

func _physics_process(_delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	move_and_slide()


func _on_hunger_timer_timeout():
	hunger -= 1
	print("Hunger: " + str(hunger))
	$Timers/HungerTimer.start()

func _on_thirst_timer_timeout():
	thirst -= 1
	print("Thirst: " + str(thirst))
	$Timers/ThirstTimer.start()
