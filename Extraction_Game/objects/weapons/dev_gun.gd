extends BaseItem
class_name Weapon

var bullet_scene: PackedScene = preload("res://objects/projectiles/bullet.tscn")

signal fire(projectile)

# Called when the node enters the scene tree for the first time.
func _ready():
	name = "Dev Gun"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_sprite()

func fire_weapon() -> void:
	var bullet = bullet_scene.instantiate() as Projectile
	var gun_direction = (get_global_mouse_position() - $Sprite2D.global_position).normalized()
	bullet.global_position = $Sprite2D/Marker2D.global_position
	bullet.global_rotation = $Sprite2D.rotation
	bullet.direction = gun_direction
	bullet.ownerActor = self
	fire.emit(bullet)
	$Audio/Gunshot.play()
	
func update_sprite() -> void:
	$Sprite2D.look_at(get_global_mouse_position())
	
	if get_global_mouse_position().x < global_position.x:
		$Sprite2D.flip_v = true
	else:
		$Sprite2D.flip_v = false

