extends Node3D

const BOX_SCENE = preload("res://entities/box/box.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is not CharacterBody3D:
		return
		
	print("hello body!")
	var box = BOX_SCENE.instantiate()
	box.position = Vector3(3,4,16)
	add_child(box)
	
	
