extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var mission_marker: Marker2D = $MissionMarker
@onready var money_label: Label = $HUD/MoneyLabel
@onready var heat_label: Label = $HUD/HeatLabel
@onready var objective_label: Label = $HUD/ObjectiveLabel
@onready var time_label: Label = $HUD/TimeLabel
@onready var info_label: Label = $HUD/InfoLabel

var mission_completed := false
var time_of_day := 8.0
var day_number := 1

func _ready() -> void:
    update_hud()

func _process(delta: float) -> void:
    time_of_day += delta * 0.2
    if time_of_day >= 24.0:
        time_of_day -= 24.0
        day_number += 1

    if not mission_completed and player is CharacterBody2D:
        var player_object = player as CharacterBody2D
        if player_object.has_method("is_driving") and player_object.is_driving():
            if player_object.get_car().global_position.distance_to(mission_marker.global_position) < 100:
                complete_mission()

    update_hud()

func update_hud() -> void:
    var player_money := 500
    var player_heat := 0
    if player.has_method("get_money"):
        player_money = player.get_money()
    if player.has_method("get_heat"):
        player_heat = player.get_heat()

    money_label.text = "Argent : %d $" % player_money
    heat_label.text = "Police : %d\u00b0" % player_heat

    if mission_completed:
        objective_label.text = "Objectif : Mission réussie. Explore la ville et construit ta vie."
        info_label.text = "Tu as gagné 1 500 $. La vie continue dans la ville."
    elif player.has_method("is_driving") and player.is_driving():
        objective_label.text = "Objectif : Conduis jusqu'au point de livraison."
        info_label.text = "La ville est vivante. Garde un œil sur les voitures et la police."
    else:
        objective_label.text = "Objectif : Trouve une voiture et va jusqu'au point de livraison."
        info_label.text = "Appuie sur E pour entrer dans un véhicule."

    var hour := int(floor(time_of_day))
    var minutes := int(round((time_of_day - floor(time_of_day)) * 60.0))
    if minutes >= 60:
        minutes = 0
        hour += 1
    if hour >= 24:
        hour = 0
    var hour_string := "%02d:%02d" % [hour, minutes]
    time_label.text = hour_string + "  -  Jour %d" % day_number

func complete_mission() -> void:
    mission_completed = true
    if player.has_method("add_money"):
        player.add_money(1500)
    if player.has_method("add_heat"):
        player.add_heat(2)
