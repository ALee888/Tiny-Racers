## Source: https://kidscancode.org/godot_recipes/4.x/2d/car_steering/index.html
extends CharacterBody2D

# Gear shifting variables
enum gears {PARK, NEUTRAL, REVERSE, DRIVE}
var gear: gears = gears.DRIVE
# Steering
var wheel_base = 16  # Distance from front to rear wheel
var steering_angle = 10  # Amount that front wheel turns, in degrees
var steer_direction
# Forward
var engine_power = 900
var acceleration = Vector2.ZERO
# Friction/drag
var friction = -55
var drag = -0.06
# Brakes/Reverse
var braking = -450
var max_speed_reverse = 250
# Drift/Slide
var slip_speed = 400  # Speed where traction is reduced
var traction_fast = 2.5 # High-speed traction
var traction_slow = 10  # Low-speed traction


## Physics call
func _physics_process(delta: float) -> void:
	acceleration = Vector2.ZERO
	get_input()	
	apply_friction(delta)
	calculate_steering(delta)
	velocity += acceleration * delta
	move_and_slide()

## Update the acceleration and angle based on the user input
func get_input():
	var turn = Input.get_axis("TurnLeft", "TurnRight")
	steer_direction = turn * deg_to_rad(steering_angle)
	if Input.is_action_pressed("Gas"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("Break"):
		acceleration = transform.x * braking


func apply_friction(delta):
	# Set a minimum speed so car doesn't creep forward at negligible speeds
	if acceleration == Vector2.ZERO and velocity.length() < 50:
		velocity = Vector2.ZERO
	# Calculate 2 forces that will be negative forces to the acceleration
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	acceleration += drag_force + friction_force


func calculate_steering(delta):
	# 1. Find the wheel positions
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	# 2. Move the wheels forward
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	# 3. Find the new direction vector
	# TODO: STUDY THIS
	var new_heading = (front_wheel - rear_wheel).normalized()
	
	# choose which traction value to use - at lower speeds, slip should be low
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	# Calculate the dot product
	var d = new_heading.dot(velocity.normalized())
	# Apply velocity
	if d > 0:
		velocity = lerp(velocity, new_heading * velocity.length(), traction * delta)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	# Apply Rotation
	rotation = new_heading.angle()


func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("GearUp")):
		gear_shift(1)
	elif (event.is_action_pressed("GearDown")):
		gear_shift(0)


## Handle state switching of gears
func gear_shift(direction: int):
	match gear:
		gears.PARK:
			if !direction:
				gear = gears.NEUTRAL
		gears.NEUTRAL:
			if direction:
				gear = gears.PARK
			else:
				gear = gears.REVERSE
		gears.REVERSE:
			if direction:
				gear = gears.NEUTRAL
			else:
				gear = gears.DRIVE
		gears.DRIVE:
			if direction:
				gear = gears.REVERSE
	print("New gear: ", gear)
			
			
	
