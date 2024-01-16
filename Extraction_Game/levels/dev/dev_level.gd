class_name DevLevel
extends Node2D

const MAP_SIZE = Vector2(128, 128)
const LAND_CAP = 0.1

@onready var tilemap = $TileMap

func _ready():
	generate_world()
	
	for actor in get_tree().get_nodes_in_group("Weapon"):
		actor.connect("weapon_fired", _on_weapon_fired)


func _process(_delta):
	pass


func _on_weapon_fired(projectile) -> void:
	$Projectiles.add_child(projectile)


func generate_world() -> void:
	var noise = FastNoiseLite.new()
	noise.seed = randi()
	
	#var cells = []
	
	for x in MAP_SIZE.x:
		for y in MAP_SIZE.y:
			#var a = noise.get_noise_2d(x, y)
			#if a <= LAND_CAP:
				#cells.append(Vector2(x,y))
			tilemap.set_cell(0, Vector2(x,y), 0, Vector2(randi_range(0,1),0), 0)
				
	#tilemap.set_cells_terrain_connect(0, cells, 0, 0)
	
	
func _load_scene() -> void:	
		get_tree().change_scene_to_packed(load("res://levels/hideout.tscn"))
	
	
func _on_area_2d_body_entered(body):
	if body == $Player:
		call_deferred("_load_scene")
