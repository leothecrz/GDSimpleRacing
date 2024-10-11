extends Node3D

@onready var FL:RayCast3D = $Casters/FrontLeft;
@onready var FR:RayCast3D = $Casters/FrontRight;
@onready var BL:RayCast3D = $Casters/BackLeft;
@onready var BR:RayCast3D = $Casters/BackRight;

@onready var CAM = $CamController;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	
	
	CAM.position = lerp(CAM.position, position, 0.01);
	
	pass
