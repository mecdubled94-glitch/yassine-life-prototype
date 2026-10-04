extends CharacterBody2D

var driver: Node = null
var max_speed := 260.0
var acceleration := 320.0

func _ready() -> void:
    add_to_group("cars")

func _physics_process(delta: float) -> void:
    if driver == null:
        velocity = velocity.move_toward(Vector2.ZERO, 30.0 * delta * 60.0)
        move_and_slide()
        return

    var input := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    var desired_velocity := input * max_speed
    velocity = velocity.move_toward(desired_velocity, acceleration * delta)
    move_and_slide()

    if driver != null:
        driver.global_position = global_position + Vector2(0, 0)

    global_position.x = clamp(global_position.x, 20, 1580)
    global_position.y = clamp(global_position.y, 20, 880)
