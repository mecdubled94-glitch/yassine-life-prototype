extends CharacterBody2D

const WALK_SPEED := 180.0
const RUN_SPEED := 240.0

var health: float = 100.0
var money: int = 500
var heat: int = 0
var current_car: CharacterBody2D = null
var can_move := true

func _physics_process(_delta: float) -> void:
    if current_car != null:
        return

    var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    var speed := WALK_SPEED
    if Input.is_action_pressed("run"):
        speed = RUN_SPEED

    velocity = direction * speed
    move_and_slide()

    var viewport_rect := Rect2(Vector2.ZERO, Vector2(1600, 900))
    global_position.x = clamp(global_position.x, viewport_rect.position.x + 20, viewport_rect.size.x - 20)
    global_position.y = clamp(global_position.y, viewport_rect.position.y + 20, viewport_rect.size.y - 20)

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("interact"):
        if current_car != null:
            exit_car()
        else:
            enter_nearest_car()

func enter_nearest_car() -> void:
    var nearest_car: CharacterBody2D = null
    var nearest_dist := 80.0
    for car in get_tree().get_nodes_in_group("cars"):
        if car == current_car:
            continue
        var distance := global_position.distance_to(car.global_position)
        if distance < nearest_dist:
            nearest_car = car
            nearest_dist = distance

    if nearest_car == null:
        return

    current_car = nearest_car
    current_car.driver = self
    visible = false
    set_physics_process(true)

func exit_car() -> void:
    if current_car == null:
        return

    var current = current_car
    current.driver = null
    current_car = null
    visible = true
    global_position = current.global_position + Vector2(30, 0)

func is_driving() -> bool:
    return current_car != null

func get_car() -> CharacterBody2D:
    return current_car

func add_money(amount: int) -> void:
    money += amount

func add_heat(amount: int) -> void:
    heat = clamp(heat + amount, 0, 10)

func get_money() -> int:
    return money

func get_heat() -> int:
    return heat
