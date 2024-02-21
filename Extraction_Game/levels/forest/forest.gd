class_name Forest
extends Level

const MAP_SIZE = Vector2(128, 128)
const LAND_CAP = 0.1

@onready var tilemap = $TileMap
@onready var scenery = $Scenery


func _ready():
	super._ready()
	_connect_signals()
	generate_world()
	audio_listener.make_current()


func _connect_signals() -> void:
	super._connect_signals()


func _process(_delta):
	audio_listener.global_position = _player.global_position


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

	const tree = "res://levels/forest/objects/forest_tree_01.tscn"
	const rock = "res://levels/forest/objects/rock_01.tscn"
	const bush = "res://levels/forest/objects/bush_01.tscn"
	const poi = "res://levels/forest/poi/campsite.tscn"
	const poi2 = "res://levels/forest/poi/army_camp.tscn"

	for i in range(2500):
		var tree_instance = preload(tree).instantiate() as Scenery
		tree_instance.position = Vector2(randf_range(8,MAP_SIZE.x * 16), randf_range(8,MAP_SIZE.y * 16))
		scenery.add_child(tree_instance)
		tree_instance.calculate_z_index(tree_instance.global_position.y)

	for i in range(500):
		var rock_instance = preload(rock).instantiate() as Scenery
		rock_instance.position = Vector2(randf_range(8,MAP_SIZE.x * 16), randf_range(8,MAP_SIZE.y * 16))
		scenery.add_child(rock_instance)
		rock_instance.calculate_z_index(rock_instance.global_position.y)

	for i in range(500):
		var bush_instance = preload(bush).instantiate() as Scenery
		bush_instance.position = Vector2(randf_range(8,MAP_SIZE.x * 16), randf_range(8,MAP_SIZE.y * 16))
		scenery.add_child(bush_instance)
		bush_instance.calculate_z_index(bush_instance.global_position.y)

	var poi_instance = preload(poi).instantiate() as POI
	poi_instance.position = Vector2(180,180)
	scenery.add_child(poi_instance)

	var poi_instance2 = preload(poi2).instantiate() as POI
	poi_instance2.position = Vector2(300,300)
	scenery.add_child(poi_instance2)
