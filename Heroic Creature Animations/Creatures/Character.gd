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
var face_left : bool = false setget set_face_left
export var max_move_distance : int = 200
export var speed : float = 25.0
export var attack_speed : float = 1.0
export var retreat_distance : float = 24.0
export var attack_distance : float = 24.0
export var min_damage : int = 1
export var max_damage : int = 10
export var hit_points : int = 10

onready var anim = $AnimationPlayer
onready var sprite = $CharacterSprite

var team_id : int = 0
var move_to_location
var target

enum STATE { IDLE, ORDERED, TRACKING, RETREATING, ATTACKING, HIT, DEAD }
var state = STATE.IDLE

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
	return value

func init(t_id : int, pos : Vector2):
	self.position = pos
	self.team_id = t_id
	
func _ready():
	self.anim.update_animations()
	self.anim.play("Idle")
	EventBus.connect("move_to_location", self, "_on_move_to_updated")
	EventBus.connect("creature_died", self, "_on_creature_died")
	EventBus.connect("creature_hit", self, "_on_creature_hit")
	anim.connect("animation_finished", self, "_on_animation_finished")

func _on_move_to_updated(position):
	if ( self.position.distance_to(position) <= max_move_distance ):
		move_to_location = position
	
func play_anim(name : String, stop : bool = false):
	if (self.anim):
		if(stop):
			self.anim.stop()
		self.anim.play(name)
		
func do_idle():
	state = STATE.IDLE
	self.play_anim("Idle")
		
func do_tracking(delta : float):
	state = STATE.TRACKING
	self.play_anim("Walk")
	var direction = self.position.direction_to(target.position).normalized() * speed * delta
	var new_pos = self.position + self.move_and_slide(direction)
	self.position = new_pos
	self.face_left = direction.x < 0
	
func do_retreating(delta : float):
	state = STATE.RETRATING
	self.play_anim("Walk")
	var direction = self.position.direction_to(target.position).normalized() * speed * delta * -1
	var new_pos = self.position + self.move_and_slide(direction)
	self.position = new_pos
	self.face_left = direction.x < 0
	
func do_attack():
	state = STATE.ATTACKING
	self.play_anim("Attack")

func _physics_process(delta : float):
	if (state == STATE.HIT || state == STATE.DEAD):
		return
	if (state == STATE.TRACKING || state == STATE.RETREATING):
		if ( ! target):
			self.state = STATE.IDLE
		else:
			var dist_to = self.position.distance_to(target.position)
			if ( dist_to < self.attack_distance):
				self.do_attack()
			elif ( dist_to <= self.retreat_distance ):
				self.do_retreating(delta)
			else:
				self.do_tracking(delta)
	elif(target):
		state = STATE.TRACKING
			
	if (state == STATE.IDLE):
		self.do_idle()

func _on_animation_finished(name):
	if (name == "Attack"):
		var hit = $AttackRight.get_collider()
		if ( ! hit ):
			hit = $AttackLeft.get_collider()
		if ( hit ):
			if ( hit.state != STATE.DEAD ):
				EventBus.emit_signal("creature_hit", hit, int( rand_range(self.min_damage, self.max_damage)))
				self.state = STATE.TRACKING
			else :
				self.state = STATE.IDLE
		else :
			self.state = STATE.RETREATING
	if (name == "Hit"):
		self.state = STATE.RETREATING

func _on_creature_died(character):
	if ( target == character ):
		target = null
		state = STATE.IDLE
		
func _on_creature_hit(hit, damage):
	if( hit != self):
		return
	print( String(team_id) + " Hit for " + String(damage) + " HP " + String(self.hit_points))
	self.play_anim("Hit", true)
	state = STATE.HIT
	self.hit_points -= clamp( damage, 0, self.hit_points )
	print( self.hit_points )
	if self.hit_points <= 0:
		self.state = STATE.DEAD
		self.play_anim("Death", true)
		EventBus.emit_signal("creature_died", self)
		$DeathTimer.start()

func _on_AttackView_body_entered(body : Character):
	if (body.team_id == self.team_id):
		return
	if ( ! self.target ):
		self.target = body
		self.state = STATE.TRACKING
	elif ( self.position.distance_to(target.position) > self.position.distance_to(body.position) ):
		self.target = body
		self.state = STATE.TRACKING

func _on_DeathTimer_timeout():
	self.queue_free() # Replace with function body.
