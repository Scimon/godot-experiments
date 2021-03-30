tool
extends KinematicBody2D
class_name Character

const SHEETS = [
	preload("res://SpriteSheets/CastleSpriteSheet.png"),
	preload("res://SpriteSheets/InfernoSpriteSheet.png"),
	preload("res://SpriteSheets/NecromancerSpriteSheet.png"),
	preload("res://SpriteSheets/RampartSpriteSheet.png"),
	preload("res://SpriteSheets/StrongholdSpriteSheet.png"),
	preload("res://SpriteSheets/TowerSpriteSheet.png"),
]

enum CharacterTypes {
	Spearman,
	Crossbowman,
	Griffon,
	Swordsman,
	Priest,
	Mounted_Knight,
	Knight,
	Pikeman,
	Armoured_Crossbowman,
	Grey_Griffon,
	Paladin,
	Warrior_Priest,
	Mounted_Lord,
	Lord,
	Spear_Imp,
	Fire_Imp,
	Hellhound,
	Demon,
	Flail_Demon,
	Effret,
	Demon_Lord,
	Pike_Imp,
	Armoured_Fire_Imp,
	Frilled_Hellhound,
	Armoured_Demon,
	Flail_Demon_Lord,
	Effret_Mage,
	Demon_Count,
	Skeleton_Scythe,
	Zombie_Cleaver,
	Spider,
	Vampire,
	Vampire_Lord,
	Necromancer,
	Mounted_Vampire,
	Skeleton_Sword,
	Zombie_Mace,
	Giant_Spider,
	Banshee,
	Ancient_Vampire,
	Necromancer_Lord,
	Dark_Knight,
	Magic_Sprite,
	Dwarf,
	Satyr,
	Elf,
	Magic_Deer,
	Elf_Wizard,
	Entling,
	Fairie,
	Dawrf_Lord,
	Saytr_Lord,
	Elf_Lord,
	Stag,
	Elf_Wizard_Load,
	Ent,
	Goblin,
	Harpy,
	Warg_Rider,
	Centaur,
	Druid,
	Hobgoblin_Rock_Lobber,
	Ogre,
	Forest_Goblin,
	Harpy_Lord,
	Armoured_Warg_Rider,
	Armoured_Centaur,
	Druid_Lord,
	Minotaur,
	Ogre_Lord,
	Gremlin_Shotgun,
	Gargoyle,
	Golem,
	Carpet_Mage,
	Djinn,
	Leonin,
	Titan,
	Gremlin_Lord,
	Gargoyle_Lord,
	Rollin_Golem,
	Carpet_Mage_Lord,
	Djinn_Lord,
	Leonin_king,
	Titan_Lord
}

export( CharacterTypes ) var character_type = 0 setget set_character_type

var character_offset : int = 0 setget set_character_offset
export var face_left : bool = false setget set_face_left
export var max_move_distance : int = 100
export var speed : float = 10.0

onready var anim = $AnimationPlayer
onready var sprite = $CharacterSprite

var move_to_location

func set_face_left( value : bool ) -> bool:
	if (sprite):
		sprite.flip_h = value
	face_left = value
	return value

func set_character_type( value : int ) -> String :
	var offset = value % 14
	var sheet = floor(value/14)
	character_type = value
	if (sprite):
		sprite.texture = SHEETS[sheet]
	self.character_offset = offset
	return character_type

func set_character_offset( value : int ) -> int :
	value = clamp( value, 0, 13 )
	character_offset = value
	if (anim):
		anim.update_animations()
	return value

func init():
	EventBus.connect("move_to_location", self, "_on_move_to_updated")
	
func _on_move_to_updated(position):
	if ( self.position.distance_to(position) <= max_move_distance ):
		move_to_location = position
		
func _process(delta):
	if (move_to_location):
		if (self.position.distance_to(move_to_location) <= 10):
			anim.play("Idle")
			move_to_location = null
		else :
			anim.play("Walk")
			var direction = self.position.direction_to(move_to_location).normalized() * speed * delta
			self.position += direction
			self.face_left = direction.x < 0
