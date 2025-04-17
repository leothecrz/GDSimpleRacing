extends Node3D

var mouseCaptured : bool = true;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
	mouseCaptured = true;
	return;
	
func _input(event: InputEvent) -> void:
	if(not event is InputEventMouseButton):
		return;
	var mouseEvent : InputEventMouseButton = event as InputEventMouseButton;
	if(not mouseEvent.pressed):
		return;
	if(mouseEvent.button_index == MOUSE_BUTTON_LEFT):
		if (mouseCaptured):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		mouseCaptured = !mouseCaptured;
	return;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("Escape")):
		get_tree().quit();
		return;
	
	pass
