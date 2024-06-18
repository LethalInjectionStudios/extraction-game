class_name Ammunition
extends Item

## Caliber of Bullet
@export var caliber: Globals.Caliber

## Armor Penetration Value of the Bullet
@export var armor_penetration: int

## Percent damage modifier (Positive values mean increased damage)
@export var damage_modifier: int

## Modifier to the location the bullet travels to (Negative values mean increased accuracy)
@export var accuracy_modifier: int

## Modifier to how far the player gets pushed back when shooting (Negative values mean decreased recoil)
@export var recoil_modifier: int

## How much durability penalty applied to the fired weapon
@export var durability_burn: int

## Modifier to how loud the shot was (Negative values mean quieter shot)
@export var sound_modifier: int
