class_name Zombie
extends Character

func _ready():	
	move_speed = 25.0
	faction = Globals.Factions.ZOMBIE

	
func _process(_delta):
	if velocity.x < 0:
		$Sprite.flip_h = true
	if velocity.x > 0:
		$Sprite.flip_h = false

	
func _physics_process(_delta):
	move_and_slide()
