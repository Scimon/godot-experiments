tool
extends Node2D

const BLANK = Vector2(0,4)
enum Body { PALE, TAN, BROWN, GREEN }
var ranges = {
	Body.PALE : Vector2(1,0),
	Body.TAN : Vector2(1,1),
	Body.BROWN : Vector2(1,2),
	Body.GREEN : Vector2(1,3),
}
enum ClothingMaterial { LEATHER, DWARVEN, ENCHANTED, ELVEN, STEEL, DARK }
const CHEST_WIDTH = 4
var chest_material_bases = {
	ClothingMaterial.LEATHER : Vector2(6,0),
	ClothingMaterial.DWARVEN : Vector2(10,0),
	ClothingMaterial.ENCHANTED : Vector2(14,0),
	ClothingMaterial.ELVEN : Vector2(6,5),
	ClothingMaterial.STEEL : Vector2(10,5),
	ClothingMaterial.DARK : Vector2(14,5),
}
enum HairColour { BROWN, RED, BLONDE, BLACK, WHITE, GREEN }
const HAIR_WIDTH = 4
var hair_bases = {
	HairColour.BROWN : Vector2(19,0), 
	HairColour.RED : Vector2(23,0), 
	HairColour.BLONDE: Vector2(19,4), 
	HairColour.BLACK: Vector2(23,4),
	HairColour.WHITE: Vector2(19,8), 
	HairColour.GREEN: Vector2(23,8)
}
const BOOT_WIDTH = 2
enum BootType { NONE = -1, BOOTS = 0, SHOES = 1 }
var boot_bases = {
	ClothingMaterial.LEATHER : Vector2(3,5),
	ClothingMaterial.DWARVEN : Vector2(3,6),
	ClothingMaterial.ENCHANTED : Vector2(3,7),
	ClothingMaterial.ELVEN : Vector2(3,6),
	ClothingMaterial.STEEL : Vector2(3,1),
	ClothingMaterial.DARK : Vector2(3,0),
}
const HELM_WIDTH = 4
enum HelmType { 
	NONE = -1, GOLD_HELM, SILVER_HELM, GOLD_CROWN, SILVER_CROWN,
	GOLD_CORONET, SILVER_CORONET, HORNED, JESTERS_CAP, WIZARDS_HAT	
}
enum HelmMaterial { DWARVEN, ENCHANTED, LEATHER, ELVEN }
var helm_bases = {
	HelmType.GOLD_HELM : Vector2(28,0), 
	HelmType.SILVER_HELM : Vector2(28,1), 
	HelmType.GOLD_CROWN : Vector2(28,2), 
	HelmType.SILVER_CROWN : Vector2(28,3), 
	HelmType.GOLD_CORONET : Vector2(28,4), 
	HelmType.SILVER_CORONET : Vector2(28,5), 
	HelmType.HORNED : Vector2(28,6), 
	HelmType.JESTERS_CAP : Vector2(28,7), 
	HelmType.WIZARDS_HAT : Vector2(28,8),
}

export(Body) var body = Body.TAN setget set_body
export(ClothingMaterial) var chest_material = ClothingMaterial.LEATHER setget set_chest_material
export(int,-1,19) var chest_design = 0 setget set_chest_design
export(HairColour) var hair_colour = HairColour.BROWN setget set_hair_colour
export(int,-1,15) var hair_style = -1 setget set_hair_style
export(ClothingMaterial) var boot_material = ClothingMaterial.LEATHER setget set_boot_material
export(BootType) var boot_type = BootType.NONE setget set_boot_type
export(HelmType) var helm_type = HelmType.NONE setget set_helm_type
export(HelmMaterial) var helm_material = HelmMaterial.DWARVEN setget set_helm_material


func set_body(value):
	body = value
	if $Body:
		$Body.frame_coords = ranges[body]
	return value

func set_helm_material(value):
	helm_material = value
	apply_image(helm_bases,HELM_WIDTH,
				helm_type,helm_material,$Helm)
	return value

func set_helm_type(value):
	helm_type = value
	apply_image(helm_bases,HELM_WIDTH,
				helm_type,helm_material,$Helm)
	return value


func set_hair_colour(value):
	hair_colour = value
	apply_image(hair_bases,HAIR_WIDTH,
				hair_colour,hair_style,$Hair)
	return value

func set_hair_style(value):
	hair_style = value
	apply_image(hair_bases,HAIR_WIDTH,
				hair_colour,hair_style,$Hair)
	return value

func set_boot_material(value):
	boot_material = value
	apply_image(boot_bases,BOOT_WIDTH,
				boot_material,boot_type,$Boots)
	return value

func set_boot_type(value):
	boot_type = value
	apply_image(boot_bases,BOOT_WIDTH,
				boot_material,boot_type,$Boots)
	return value

func set_chest_design(value):
	chest_design = value
	apply_image(chest_material_bases,CHEST_WIDTH,chest_material,chest_design,$Chest)
	return value

func set_chest_material(value):
	chest_material = value
	apply_image(chest_material_bases,CHEST_WIDTH,chest_material,chest_design,$Chest)
	return value

func apply_image(bases,width,type,design,sprite):
	if sprite:
		if design < 0 || type < 0:
			sprite.frame_coords = BLANK
		else:
			var base = bases[type]
			base.x += design % width
			base.y += floor(design / width)
			sprite.frame_coords = base


# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_body(body)
	self.set_chest_material(chest_material)
	self.set_hair_colour(hair_colour)
	self.set_boot_type(boot_type)
	
