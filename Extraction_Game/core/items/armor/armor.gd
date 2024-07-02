class_name Armor
extends Item

## Armor Class value of the armor (1 - 6)
@export_range(1, 6) var armor_class: int

## How fragile the armor is, effects how quickly it degrades
@export var fragility: int

## Appearance in game when equipped
@export var character_sprite: String
