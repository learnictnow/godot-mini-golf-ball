extends RigidBody3D

var current_direction = Vector3.FORWARD
var ball_multiplier = 5

var hit_strength = 0.0
var hit_pressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Marker3D.visible = sleeping # Make the marker visible only when ball isn't moving
	
	if Input.is_action_pressed("ui_accept") and sleeping:
		#hit_ball()
		hit_strength += delta
		
	if Input.is_action_just_released("ui_accept") and sleeping:
		hit_ball()
		hit_strength = 0.0
		
	if Input.is_action_pressed("ui_left"):
		current_direction = current_direction.rotated(Vector3.UP, deg_to_rad(1))
		$Marker3D.rotate_object_local(Vector3.UP, deg_to_rad(1))
	if Input.is_action_pressed("ui_right"):
		current_direction = current_direction.rotated(Vector3.UP, deg_to_rad(-1))
		$Marker3D.rotate_object_local(Vector3.UP, deg_to_rad(-1))
	
	#print(current_direction)
	
	look_at_cursor()

func hit_ball():
	current_direction = current_direction.rotated(Vector3.UP, deg_to_rad($Marker3D.rotation_degrees.y))
	apply_central_impulse(current_direction * ball_multiplier * hit_strength * 5)
	#apply_central_impulse(current_direction * ball_multiplier)

func look_at_cursor():
	var drop_plane = Plane(Vector3(0,1,0), position.y)
	var ray_length = 1000
	var mouse_pos = get_viewport().get_mouse_position()
	var from = $TopDownCamera.project_ray_origin(mouse_pos)
	var to = from + $TopDownCamera.project_ray_normal(mouse_pos) * ray_length
	var cursor_pos = drop_plane.intersects_ray(from, to)
	
	#var tmp = $Marker3D.angle_to(cursor_pos)
	
	#print(tmp)
	
	$Marker3D.look_at(cursor_pos, Vector3.UP)
	print($Marker3D.rotation_degrees.y)
	#current_direction = current_direction.rotated(Vector3.UP, deg_to_rad($Marker3D.rotation_degrees.y))
