@tool
extends MultiMeshInstance3D

@export var num_fish: int = 100:
	set = set_num_fish
	
func set_num_fish(value: int):
	if value != num_fish:
		set_fish(value)
	num_fish = value

class FishData:
	var custom_data: Color
	var pos: Transform3D
	var num: int
	
	func sync_with_multimesh(multimesh: MultiMesh):
		multimesh.set_instance_transform(num, pos)
		multimesh.set_instance_custom_data(num, custom_data)
	func del_from_multimesh(multimesh: MultiMesh):
		multimesh.instance_count 

# holds CPU fish data for fish persistence when reloading the multimeshinstance
# Useful for both changing the number of fish
# ...and reloading its state between program launches,
# if you really wanted to do that for some reason.
var fish_data_array: Array = []

# Old fish data is lost each time we change the number of fish instances
# So we have to instance all the ones we want at the start,
# or hold data in the CPU and iteratively sync it each time we change the number of fish
# Naturally, I chose the most awkward solution! :P
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

func set_fish(value: int) -> void:
	var diff = value -  multimesh.instance_count + 1
	if diff > 0:
		print('add ', diff, ' fish')
		for val in range(diff):
			add_fish()
		sync_fish()
	elif diff == 0:
		pass
	elif diff < 0:
		print('remove ', -diff, ' fish')
		for val in range(-diff):
			del_fish()
	
