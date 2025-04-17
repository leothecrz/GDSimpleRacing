extends Camera3D


@export var carRef : BaseCar;

@export var speed : float = 5.0;
@export var sensitivity : float = 0.2;

@onready var labelUI = $Label3D;

var ETA : float = 0.0;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func rotate_camera(mouse_delta: Vector2):
	# Rotate around Y-axis (left/right) using parent (Node3D)
	rotation_degrees.y -= mouse_delta.x * sensitivity  

	rotation_degrees.x -= mouse_delta.y * sensitivity  
	rotation_degrees.x = clamp(rotation_degrees.x, -90, 90)
	return;


func _input(event: InputEvent) -> void:
	if(event is InputEventKey):
		var keyEvent = event as InputEventKey;
		if(event.is_released()):
			return;
		match(keyEvent.keycode):
			KEY_SPACE:
				current = !current
				return;
		return;
	
	if(not current):
		return;
	
	if(event is InputEventMouseMotion):
		if(Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
			rotate_camera(event.relative);
		return;
	
	return;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if(not current):
		return;
	
	var inputVector : Vector2 = Input.get_vector("steer_left", "steer_right", "brake", "accelerate").normalized();
	var direction = Vector3.ZERO
	
	direction += inputVector.y * -global_transform.basis.z  # Forward direction
	direction += inputVector.x * global_transform.basis.x  # Forward direction
	global_translate(direction * speed * delta)

	ETA += delta
	if(ETA >= 2):
		ETA = 0;
		labelUI.text = carRef.updateTESTINFO() if carRef else "";
		labelUI.text += "\n %v" % [inputVector];
	
	return;
