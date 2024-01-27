extends CharacterBody2D

var moving := false
var flipped := false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction != Vector2():
		if not moving:
			$AnimationPlayer.play("WalkingRight")
			moving = true
		if not flipped and direction.x < 0:
			$NotMickeySprite.flip_h = true
			flipped = true
		elif flipped and direction.x > 0:
			$NotMickeySprite.flip_h = false
			flipped = false
	else:
		$AnimationPlayer.stop()
		moving = false
	
	velocity = direction * 500
	move_and_slide()
	
