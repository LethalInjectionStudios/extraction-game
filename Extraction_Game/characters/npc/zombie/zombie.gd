class_name Zombie
extends Character

func _ready():	
	_move_speed = 25.0
	_faction = Globals.Faction.ZOMBIE

	
func _process(_delta):
	if velocity.x < 0:
		$Sprite.flip_h = true
	if velocity.x > 0:
		$Sprite.flip_h = false

	
func _physics_process(_delta):
	move_and_slide()
