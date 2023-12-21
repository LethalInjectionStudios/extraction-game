extends CharacterBody2D

var health: int
var hunger: int
var thirst: int

var inRaid: bool = false

const MAX_HEALTH: int = 100
const MAX_HUNGER: int = 100
const MAX_THIRST: int = 100
const SPEED: float = 300.0

func _ready():
	health = MAX_HEALTH
	hunger = MAX_HUNGER
	thirst = MAX_THIRST
	
func _process(delta):
	pass

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
