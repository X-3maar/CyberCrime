extends CharacterBody2D
@onready var sprite: AnimatedSprite2D = $Sprite

const SPEED = 100.0

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	if direction.x !=0:
		direction.y=0
	elif direction.y!=0:
		direction.x=0
	if direction.length() > 0:
		velocity = direction.normalized() * SPEED
		
		if abs(direction.x) > abs(direction.y):
			sprite.play("run_horizontal")
			if direction.x > 0:
				sprite.flip_h = false
			elif direction.x < 0:
				sprite.flip_h = true
		else:
			if direction.y < 0:
				sprite.play("run_up")
			elif direction.y > 0:
				sprite.play("run_down")
	else:
		if sprite.animation == "run_up":
			sprite.play("idle_up")
		elif sprite.animation == "run_down":
			sprite.play("idle_down")
		elif sprite.animation == "run_horizontal":
			sprite.play("idle_horizontal")
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
	move_and_slide()
