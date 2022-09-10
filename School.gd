@tool
extends MultiMeshInstance3D

class FishData:
	var custom_data: Color
	var pos: Transform3D
	var num: int
	
	func sync_with_multimesh(multimesh: MultiMesh):
		multimesh.set_instance_transform(num, pos)
		multimesh.set_instance_custom_data(num, custom_data)
	func del_from_multimesh(multimesh: MultiMesh):
		multimesh.instance_count 
			

# Old fish do not sync
var fish_data_array: Array = []

func sync_fish():
	for fish in fish_data_array:
		fish.sync_with_multimesh(multimesh)
		
func add_fish() -> int:
	var fish_data = FishData.new()
	fish_data.num = len(fish_data_array) + 1
	multimesh.instance_count = fish_data.num + 1
	fish_data.pos = fish_data.pos.translated(
		Vector3(randf() * 100 - 50,
				randf() * 50 - 20,
				randf() * 50 - 20)
			) * 10;
	fish_data.custom_data = Color(randf(), randf(), randf(), randf())
	fish_data_array.push_back(fish_data)
	return fish_data.num

func del_fish() -> int:
	if multimesh.instance_count <= 0:
		return 0
	multimesh.instance_count -= 1
	fish_data_array.pop_back()
	return multimesh.instance_count
