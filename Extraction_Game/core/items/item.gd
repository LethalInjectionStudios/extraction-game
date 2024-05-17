class_name Item
extends Resource

## Name of the item
@export var name: String

## Type of item. See  [code]Globals.ItemType[/code]  for available values
@export var type: Globals.Item_Type

## Description of the item
@export_multiline var description: String

## Path to the sprite for the item
@export var sprite: String

## Monetary value of the item
@export var value: int

## Weight of the item in the inventory
@export var weight: float

## If [code]true[/code] the item can be stacked in the inventory
@export var is_stackable: bool

## If [code]true[/code] the item can be equipped to the player
@export var is_equipable: bool

## If [code]true[/code] the item can be consumed by the player
@export var is_consumable: bool

## How large a stack of items can be
@export var stack_size: int
