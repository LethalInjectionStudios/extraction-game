class_name Forest
extends Level

const MAP_SIZE = Vector2(128, 128)
const LAND_CAP = 0.1

@onready var tilemap = $TileMap

func _ready():
	super._ready()
	generate_world()
	audio_listener.make_current()


func _process(delta):
	audio_listener.global_position = player.global_position


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
