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
export var max_move_distance : int = 200
export var speed : float = 25.0

onready var anim = $AnimationPlayer
onready var sprite = $CharacterSprite

var team_id : int = 0
var move_to_location
var attack_damage = [1,10]
var hit_points = 10

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
	anim.play("Idle")
	EventBus.connect("move_to_location", self, "_on_move_to_updated")
	
func _on_move_to_updated(position):
	if ( self.position.distance_to(position) <= max_move_distance ):
		move_to_location = position
		
func _physics_process(delta):
	if self.hit_points == 0:
		return
	var target_right = $AttackRight.get_collider()
	var target_left = $AttackLeft.get_collider()
	if ( target_right && target_right.team_id != self.team_id && target_right.hit_points > 0):
		move_to_location = null
		anim.play("Attack")
		target_right.attacked_for( int(rand_range(attack_damage[0], attack_damage[1]) ) )
	elif ( target_left && target_left.team_id != self.team_id && target_left.hit_points > 0):
		self.face_left = true
		move_to_location = null
		anim.play("Attack")
		target_left.attacked_for( int(rand_range(attack_damage[0], attack_damage[1]) ) )
	elif (move_to_location):
		if (self.position.distance_to(move_to_location) <= 4):
			anim.play("Idle")
			move_to_location = null
		else :
			anim.play("Walk")
			var direction = self.position.direction_to(move_to_location).normalized() * speed * delta
			var new_pos = self.position + self.move_and_slide(direction)
			self.position = new_pos
			self.face_left = direction.x < 0
	else:
		if (anim):
			anim.play("Idle")

func attacked_for( damage ):
	anim.clear_queue()
	anim.queue("Hit")
	self.hit_points -= clamp( damage, 0, self.hit_points )
	if self.hit_points <= 0:
		anim.queue("Death")
		$DeathTimer.start()

func _on_AttackView_body_entered(body : Character):
	if (body.team_id != self.team_id):
		self.move_to_location = body.global_position


func _on_DeathTimer_timeout():
	self.queue_free() # Replace with function body.
