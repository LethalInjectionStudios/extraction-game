class_name Forest
extends Level

@export var point_of_interests: Node2D
@export var extraction_points: Node2D
@export var tilemap: Node2D
@export var scenery: Node2D

const EXTRACTION: PackedScene = preload("res://levels/_base/extraction.tscn")
const MAP_SIZE: Vector2 = Vector2(256, 256)
const LAND_CAP: float = 0.1

func _ready() -> void:
	super._ready()
	generate_world()
	audio_listener.make_current()
	_connect_signals()
	

func _connect_signals() -> void:
	super._connect_signals()


func _process(_delta: float) -> void:
	audio_listener.global_position = _player.global_position


func generate_world() -> void:
	var noise: FastNoiseLite = FastNoiseLite.new()
	noise.seed = randi()
	
	#var cells = []
	
	for x: float in MAP_SIZE.x:
		for y: float in MAP_SIZE.y:
			#var a = noise.get_noise_2d(x, y)
			#if a <= LAND_CAP:
				#cells.append(Vector2(x,y))
			tilemap.set_cell(0, Vector2(x,y), 2, Vector2(randi_range(0,1),0), 0)
				
	#tilemap.set_cells_terrain_connect(0, cells, 0, 0)

	const tree: String = "res://levels/forest/objects/forest_tree_01.tscn"
	const rock: String = "res://levels/forest/objects/rock_01.tscn"
	const bush: String = "res://levels/forest/objects/bush_01.tscn"
	#const poi: String = "res://levels/forest/poi/campsite.tscn"
	const poi2: String = "res://levels/forest/poi/army_camp.tscn"

	for i: int in range(5000):
		var tree_instance: Scenery = preload(tree).instantiate() as Scenery
		tree_instance.position = Vector2(randf_range(8,MAP_SIZE.x * 16), randf_range(8,MAP_SIZE.y * 16))
		scenery.add_child(tree_instance)
		tree_instance.calculate_z_index(tree_instance.global_position.y)

	for i: int in range(1000):
		var rock_instance: Scenery = preload(rock).instantiate() as Scenery
		rock_instance.position = Vector2(randf_range(8,MAP_SIZE.x * 16), randf_range(8,MAP_SIZE.y * 16))
		scenery.add_child(rock_instance)
		rock_instance.calculate_z_index(rock_instance.global_position.y)

	for i: int in range(1000):
		var bush_instance: Scenery = preload(bush).instantiate() as Scenery
		bush_instance.position = Vector2(randf_range(8,MAP_SIZE.x * 16), randf_range(8,MAP_SIZE.y * 16))
		scenery.add_child(bush_instance)
		bush_instance.calculate_z_index(bush_instance.global_position.y)

	# var poi_instance: POI = preload(poi).instantiate() as POI
	# poi_instance.position = Vector2(180,180)
	# point_of_interests.add_child(poi_instance)

	var poi_instance2: POI = preload(poi2).instantiate() as POI
	poi_instance2.position = Vector2(1000,1000)
	point_of_interests.add_child(poi_instance2)

	var extraction_point: Extraction = EXTRACTION.instantiate() as Extraction
	extraction_point.position = Vector2(randf_range(8,MAP_SIZE.x * 16), randf_range(8,MAP_SIZE.y * 16))
	extraction_points.add_child(extraction_point)
