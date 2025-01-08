extends KinematicBody

export var sensitivity = 0.03
export var move_speed = 5

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(delta):
	move()
	
func _input(event):
	aim(event)
	
func move():
	var velocity = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		velocity  += transform.basis.z * -1
	if Input.is_action_pressed("move_backwards"):
		velocity += transform.basis.z 
	if Input.is_action_pressed("move_left"):
		velocity += transform.basis.x * -1
	if Input.is_action_pressed("move_right"):
		velocity += transform.basis.x
		
	move_and_slide(velocity.normalized() * move_speed)
	
func aim(event):
	if event is InputEventMouseMotion:
		rotate_y((event.relative.x * sensitivity) * -1)
		$Camera.rotate_x((event.relative.y* sensitivity) * -1)
		$Camera.rotation_degrees.x = clamp($Camera.rotation_degrees.x, -90, 90)



