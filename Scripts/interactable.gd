extends Area3D
class_name Interactable

@onready var in_zone: float = false

func _physics_process(delta: float) -> void:
	if len(get_overlapping_bodies()) > 0:
		var player: ThePlayer = get_overlapping_bodies()[0]
		
		if (get_parent().global_position - player.global_position).dot(-player.global_basis.z) >= 0:
			in_zone = true
			return
	in_zone = false
