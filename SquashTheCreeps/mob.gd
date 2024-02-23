extends CharacterBody3D

# Emitted when the player jumped on the mob.
signal squashed

# Minimum speed of the mob in meters per second.
@export var min_speed = 4
# Maximum speed of the mob in meters per second.
@export var max_speed = 8

var random_speed = 0
var speed_multiplier = 1.5

func _physics_process(_delta):
	if $Sight.get_collision_count():
		print("A mob raycasted "+str($Sight.get_collision_count())+" somethings")
		var player_collided = $Sight.get_collision_point(0)
		print("A mob saw Player at "+str(player_collided))
		look_at(player_collided)
		velocity = Vector3.FORWARD * random_speed * speed_multiplier
		velocity = velocity.rotated(Vector3.UP, rotation.y)
		$AnimationPlayer.speed_scale = random_speed / min_speed
	else:
		velocity = Vector3.FORWARD * random_speed 
		velocity = velocity.rotated(Vector3.UP, rotation.y)
		$AnimationPlayer.speed_scale = random_speed / min_speed
	
	
	move_and_slide()

# This function will be called from the Main scene.
func initialize(start_position, player_position):
	# We position the mob by placing it at start_position
	# and rotate it towards player_position, so it looks at the player.
	look_at_from_position(start_position, player_position, Vector3.UP)
	# Rotate this mob randomly within range of -45 and +45 degrees,
	# so that it doesn't move directly towards the player.
	rotate_y(randf_range(-PI / 4, PI / 4))
	# We calculate a random speed (integer)
	random_speed = randi_range(min_speed, max_speed)
	# We calculate a forward velocity that represents the speed.
	velocity = Vector3.FORWARD * random_speed
	# We then rotate the velocity vector based on the mob's Y rotation
	# in order to move in the direction the mob is looking.
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	
	$AnimationPlayer.speed_scale = random_speed / min_speed

func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()

func squash():
	squashed.emit()
	queue_free()

func _on_sight_body_entered(body):
	print("A mob saw Player at "+str(body.position))
	look_at(body.position)
	velocity = Vector3.FORWARD * random_speed * speed_multiplier
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	$AnimationPlayer.speed_scale = random_speed / min_speed

func _on_sight_body_exited(_body):
	velocity = Vector3.FORWARD * random_speed 
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	$AnimationPlayer.speed_scale = random_speed / min_speed
