class_name BaseCarCaster;

extends RayCast3D;

const FORCE_FLOOR = 200;

@onready var CollisionPointMesh : MeshInstance3D = $COLPOINT;
@onready var XMesh = $XForce
@onready var YMesh = $YForce
@onready var ZMesh = $ZForce

func GetCollisionMesh() -> MeshInstance3D:
	return CollisionPointMesh;  

func SetXLength(force : float) -> void:
	var mesh : BoxMesh = XMesh.mesh;
	var newSize = force / FORCE_FLOOR;
	mesh.size.x = newSize;
	XMesh.position.x = newSize/2
	return;

func SetYLength(force : float) -> void:
	var mesh : BoxMesh = YMesh.mesh;
	var newSize = force / FORCE_FLOOR;
	mesh.size.y = newSize;
	YMesh.position.y = newSize/2
	return;
	
func SetZLength(force : float) -> void:
	var mesh : BoxMesh = ZMesh.mesh;
	var newSize = force / FORCE_FLOOR;
	mesh.size.z = newSize;
	ZMesh.position.z = newSize/2
	return;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
