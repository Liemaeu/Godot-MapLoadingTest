extends KinematicBody

onready var Body = get_node(".")

var default_speed = 25
var acceleration = 5
var velocity = Vector3()
var gravity = 0.98

var speed


func _physics_process(delta):
	#sets the speed to default speed
	speed = default_speed
	#move to direction
	var body_basis = Body.get_global_transform().basis
	var direction = Vector3()
	#movement directions
	if Input.is_action_pressed("Forward"):
		direction -= body_basis.z
	elif Input.is_action_pressed("Backward"):
		direction += body_basis.z	
	if Input.is_action_pressed("Left"):
		direction -= body_basis.x
	elif Input.is_action_pressed("Right"):
		direction += body_basis.x
	direction = direction.normalized()
	#start moving slower, more natural
	velocity = velocity.linear_interpolate(direction * speed, acceleration \
	* delta)
	velocity.y -= gravity
	velocity = move_and_slide(velocity)
