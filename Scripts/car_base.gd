extends Node3D

@onready var FL:RayCast3D = $RigidBody3D/FrontLeft;
@onready var FR:RayCast3D = $RigidBody3D/FrontRight;
@onready var BL:RayCast3D = $RigidBody3D/BackLeft;
@onready var BR:RayCast3D = $RigidBody3D/BackRight;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if(FL.is_colliding()):
		print("is colliding")
	
	pass
