extends CharacterBody3D

@export var speed = 14
var mouse_sens = 0.3
var camera_anglev = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



func _input(event):         
	if event is InputEventMouseMotion:
		$PivotX.rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		var changev =- event.relative.y * mouse_sens
		if camera_anglev + changev >- 50 and camera_anglev + changev < 50:
			camera_anglev += changev
			$PivotX/Camera.rotate_x(deg_to_rad(changev))
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
			
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(_delta):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_backward"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_up"):
		direction.y += 1
	if Input.is_action_pressed("move_down"):
		direction.y -= 1

	var look_forward : Vector3 = $PivotX/Camera.global_transform.basis.z
	
	var look_horizontal : Vector3 = $PivotX/Camera.global_transform.basis.x
	var look_vertical : Vector3 = $PivotX/Camera.global_transform.basis.y

	# velocity.y -= fall_acceleration * delta
	velocity = (look_forward * direction.z + look_horizontal * direction.x + look_vertical * direction.y).normalized() * speed
	#velocity = move_and_slide((look_forward * direction.z + look_horizontal * direction.x + look_vertical * direction.y).normalized() * speed, Vector3.UP)
	move_and_slide()
