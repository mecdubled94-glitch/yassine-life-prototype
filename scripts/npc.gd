extends CharacterBody2D

var direction := Vector2.ZERO
var speed := 55.0
var timer := 0.0

func _ready() -> void:
    direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
    if direction == Vector2.ZERO:
        direction = Vector2.RIGHT

func _physics_process(delta: float) -> void:
    timer -= delta
    if timer <= 0.0:
        direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
        if direction == Vector2.ZERO:
            direction = Vector2.RIGHT
        timer = randf_range(1.0, 3.0)

    velocity = direction * speed
    move_and_slide()

    if global_position.x < 30 or global_position.x > 1570:
        direction.x *= -1
    if global_position.y < 30 or global_position.y > 870:
        direction.y *= -1
