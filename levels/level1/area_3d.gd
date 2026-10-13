extends Area3D

var can_use_door: bool = false
var step: float = 0.05

@onready var el1 = get_parent().get_node("CSGCombiner3D").get_node("el1")
@onready var el2 = get_parent().get_node("CSGCombiner3D").get_node("el2")

# Store original positions and sizes to prevent infinite drift
@onready var el1_orig_pos = el1.position
@onready var el1_orig_size_z = el1.size.z
@onready var el2_orig_pos = el2.position
@onready var el2_orig_size_z = el2.size.z

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		can_use_door = true
		print("???")
	
func _on_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		can_use_door = false
		print("ne")

func open_elevator() -> void:
	# 1. Update the size using the current step
	el1.size.z = step
	el2.size.z = step
	
	# 2. Calculate total size difference from the original size
	var size_diff = step - el1_orig_size_z
	
	# 3. Set position relative to the original position (prevents accumulation)
	el1.position.z = el1_orig_pos.z - (size_diff / 2.0)
	el2.position.z = el2_orig_pos.z + (size_diff / 2.0)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("action_interact") and can_use_door:
		# Disable interaction while opening so it can't be triggered twice
		can_use_door = false 
		
		for i in range(10):
			step += 0.1
			open_elevator()
			print(step)
			await get_tree().create_timer(0.1).timeout # Changed to 0.1s for a smoother animation
