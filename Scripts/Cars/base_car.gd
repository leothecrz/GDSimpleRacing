class_name  BaseCar;

extends RigidBody3D;

#SELF REFS
@onready var CasterReference : Node3D = $Casters;


@export_category("SPRINGS")
@export var SPRING_STRENGTH = 50.0;
@export var SPRING_DAMP = 5.0;

@export_category("SLIP")
@export var TIRE_MASS = 0.0005;
@export var IS_FOUR_WHEEL_DRIVE = false;
@export var FRONT_SLIP = 1.0;
@export var BACK_SLIP = 1.0;

@export_category("ACCELERATION")
@export var ACC_FORCE: float = 10.0  # Forward force applied to the car
@export var BRAKE_FORCE: float = 10.0  # Braking force

@export_category("DEBUG VARS")
@export var steerAngle 			: float = 0.0;
@export var lookAngle 			: float = 0.0;
@export var accelInput			: float = 0.0;
@export var MAX_STEER_ANGLE 	: float = 0.5;
@export var MAX_LOOKING_ANGLE 	: float = 2.0;


var currentSpeed	: float = 0.0;
var printbuffer		: int = 0;
var springoffset	: float = 0;

var tirevelocity = Vector3.ZERO;

##
func getPointVelocity(point : Vector3) -> Vector3:
	return linear_velocity + angular_velocity.cross(point - position);

##
func handleInputs(delta : float) -> void:
	var forward_direction = global_transform.basis.x;
	var steer_input = Input.get_action_strength("steer_right") - Input.get_action_strength("steer_left");
	steerAngle = clamp(steerAngle + (steer_input * delta), -MAX_STEER_ANGLE, MAX_STEER_ANGLE);
	steerAngle = lerp(steerAngle, 0.0, 0.1);
	if(printbuffer == 0): print("Steer Angle: ", steerAngle);
	
	var look_input = Input.get_action_strength("look_right") - Input.get_action_strength("look_left");
	lookAngle = clamp(lookAngle + (look_input * delta), -MAX_LOOKING_ANGLE, MAX_LOOKING_ANGLE);
	lookAngle = lerp(lookAngle, 0.0, 0.001);
	if(printbuffer == 0): print("Look Angle: ", lookAngle);
	
	accelInput = Input.get_action_strength("accelerate") - Input.get_action_strength("brake");
	if(printbuffer == 0): print("Accel Input: ", accelInput);
	
	currentSpeed = self.linear_velocity.dot(forward_direction)
	if(printbuffer == 0): print("Speed: ", currentSpeed);
	return;

##
func applyForceTo(delta : float, caster : BaseCarCaster, index : int) -> void:
	var TESTCOLPOINT : MeshInstance3D = caster.GetCollisionMesh();
	TESTCOLPOINT.visible = false;
	
	if(not caster.is_colliding()): return;
	var collisionPoint : Vector3 = caster.get_collision_point();
	var casterCollisionDiff : Vector3 = collisionPoint - caster.global_position
	
	var tireVelocity = getPointVelocity(caster.position)
	
	
	##Suspension
	springoffset = casterCollisionDiff.y - caster.target_position.y;
	var springForce = (springoffset * SPRING_STRENGTH) - ( tireVelocity.y * SPRING_DAMP);
	apply_impulse(caster.basis.y * springForce * delta, caster.position)
	caster.SetYLength(springForce);
	
	##Slip
	
	
	##Acceleration
	
	
	if(index == 0):
		tirevelocity = tireVelocity;
		
	TESTCOLPOINT.visible = true;
	TESTCOLPOINT.position = casterCollisionDiff;
	return;

##
func applyForces(delta : float) -> void:
	var i : int = 0;
	for caster : BaseCarCaster in CasterReference.get_children():
		applyForceTo(delta, caster, i);
		i += 1;
	return;



##
func updateTESTINFO() -> String:
	var outstring = "";
	outstring = "SPEED: %f | AC-IN: %f | LOOK ANGLE: %f | STEER ANGLE: %f" % [currentSpeed, accelInput, lookAngle, steerAngle];
	outstring += "\n SPRING_OFFSET: %f" % [springoffset]
	outstring += "\n TIRE VELOCITY: %v" % [tirevelocity]
	return outstring;



##
func _ready() -> void:
	return;

##
func _process(delta: float) -> void:
	#delta = clampf(delta, 0.0, 0.01);
	#handleInputs(delta);
	#applyForces(delta);
	printbuffer += 1;
	if(printbuffer > 10000):
		printbuffer = 0;
	return;
	
func _physics_process(delta: float) -> void:
	applyForces(delta);
	return;
	
