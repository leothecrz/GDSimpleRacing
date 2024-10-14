extends RigidBody3D

enum CASTER_CHILD {FL,FR,BL,BR};
@onready var CASTERS = $Casters;

@onready var CAM = $CamController;

var SPRING_STRENGHT = 100.0;
var SPRING_DAMP = 15.0;
var SPRING_MAX_FORCE = 500;

var FRICTION_FORCE = 10;

var STEER_ANGLE: float = 10.0  # Steering input
var MAX_STEER_ANGLE: float = 0.5  # Maximum steering angle (radians)
var ACC_FORCE: float = 10.0  # Forward force applied to the car
var BRAKE_FORCE: float = 10.0  # Braking force

var current_speed: float = 0.0  # Current forward speed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func applyforces(ray:RayCast3D, delta: float):
	if not ray.is_colliding():
		return;
	
	var collision_point = ray.get_collision_point();
	var current_length = (ray.global_transform.origin - collision_point).length();
	var offset = current_length - ray.target_position.y;
	
	
	if(offset <= 0):
		return;
		
	print(collision_point);
	print(current_length);
	print(offset);
	
	var RayBasis = ray.global_transform.basis;
	var relative_velocity = self.linear_velocity.dot(RayBasis.y);
	var spring_force = -SPRING_STRENGHT * offset;
	var damping_force = -SPRING_DAMP * relative_velocity;
	
	var total_force = spring_force + damping_force
	total_force = clamp(total_force, 0, SPRING_MAX_FORCE)
	
	#apply_central_force(RayBasis.y * total_force)
	apply_force(RayBasis.y * delta * total_force, ray.position);
	
	var lateral_velocity = linear_velocity.dot(RayBasis.x)
	apply_central_impulse(-RayBasis.x * lateral_velocity * delta * FRICTION_FORCE)

	return;

func castingProcess(delta: float):
	for caster in CASTER_CHILD.values():
		applyforces(CASTERS.get_child(caster), delta);
	return;

func handle_input(delta: float) -> void:
	var forward_direction = global_transform.basis.x

	var steer_input = Input.get_action_strength("steer_right") - Input.get_action_strength("steer_left")
	if(steer_input != 0):
		print(steer_input);
	STEER_ANGLE = clamp(STEER_ANGLE + steer_input * delta, -MAX_STEER_ANGLE, MAX_STEER_ANGLE)

	CASTERS.get_child(CASTER_CHILD.FL).rotation.y = STEER_ANGLE
	CASTERS.get_child(CASTER_CHILD.FR).rotation.y = STEER_ANGLE

	var accel_input = Input.get_action_strength("accelerate") - Input.get_action_strength("brake")
	if accel_input != 0:
		var accel_force = forward_direction * ACC_FORCE * accel_input
		apply_central_force(accel_force)
		if accel_input < 0:
			apply_central_impulse(-linear_velocity * BRAKE_FORCE * delta)

	current_speed = linear_velocity.dot(forward_direction)
	return;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	castingProcess(delta);
	handle_input(delta);
	CAM.position = lerp(CAM.position, position, 0.01);
	pass
