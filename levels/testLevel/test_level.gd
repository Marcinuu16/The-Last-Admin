extends Node3D
var can_open: bool = false

const BOX_SCENE = preload("res://entities/box/box.tscn")
@onready var arrena = $Area3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Control/Label.text = str(Engine.get_frames_per_second())+" fps"

func _on_area_3d_body_entered(body: Node3D) -> void:
	can_open = true
	print(arrena.get_overlapping_bodies())
	for i in range(5):
		spawn_box(body)
	
func _on_area_3d_body_exited(body: Node3D) -> void:
	can_open = false

func spawn_box(body):
	
	
	if body is not CharacterBody3D:
		return
		
	print("hello body!")
	var box = BOX_SCENE.instantiate()
	var meshy: MeshInstance3D = box.get_node("MeshInstance3D")
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(randf(),randf(),randf())
	meshy.set_surface_override_material(0,mat)
	
	box.position = Vector3(6,10,16)
	add_child(box)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("action_interact") and can_open:
		if is_instance_valid($CSGBox3D/door):
			$CSGBox3D/door.queue_free()
