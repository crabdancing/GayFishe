extends Node3D

@onready var ManyFish: MultiMeshInstance3D = %ManyFish
var fish_inc_rate = 1.0

func _physics_process(delta: float) -> void:
	var fish_factor = Input.get_axis("less_fish", "more_fish") * 10.0
	fish_factor += Input.get_axis("less_fish_big", "more_fish_big") * 1000.0
	if fish_factor > 0.0:
		ManyFish.add_fish()
		ManyFish.sync_fish()
	elif fish_factor < 0.0:
		ManyFish.del_fish()
