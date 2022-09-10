@tool
extends MultiMeshInstance3D

@export var runtime_instances: int = 500.0
var old_runtime_instances: int
@onready var School: MultiMeshInstance3D = %School
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refresh_fish()
	
func refresh_fish():
	School.multimesh.instance_count = runtime_instances
	for i in range(School.multimesh.instance_count):
		var pos: Transform3D
		pos = pos.translated(
			Vector3(randf() * 100 - 50,
					randf() * 50 - 20,
					randf() * 50 - 20)
				) * 10;
		School.multimesh.set_instance_transform(i, pos)
		School.multimesh.set_instance_custom_data(i, 
			Color(randf(), randf(), randf(), randf())
		)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if old_runtime_instances != runtime_instances:
		old_runtime_instances = runtime_instances
		refresh_fish()

