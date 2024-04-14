#Receipe book as a singleton in Autoload
extends Node
class_name RecipeBook

var recipes = {
	"Cooked_A": {
		"ingredients": ["Cooked_A"], 
		"difficulty": "easy", 
		"sprite": "res://assets/meals/green.png",
		"name": "Green Meal"
	},
	"Cooked_B": {
		"ingredients": ["Cooked_B"], 
		"difficulty": "easy", 
		"sprite": "res://assets/meals/red.png",
		"name": "Read Meal"
	},
	"Cooked_C": {
		"ingredients": ["Cooked_C"], 
		"difficulty": "easy", 
		"sprite": "res://assets/meals/pink.png",
		"name": "Pink Meal"
	},
	"Cooked_A+Cooked_B": {
		"ingredients": ["Cooked_A", "Cooked_B"], 
		"difficulty": "medium", 
		"sprite": "res://assets/meals/green-red.png",
		"name": "Red + Pink Meal"
	},
	"Cooked_A+Cooked_C": {
		"ingredients": ["Cooked_A", "Cooked_C"], 
		"difficulty": "medium", 
		"sprite": "res://assets/meals/green-pink.png",
		"name": "Green + Red Meal"
	},
	"Cooked_B+Cooked_C": {
		"ingredients": ["Cooked_B", "Cooked_C"], 
		"difficulty": "medium", 
		"sprite": "res://assets/meals/red-pink.png",
		"name": "Green and Pink Meal"
	},
	"Cooked_A+Cooked_B+Cooked_C": {
		"ingredients": ["Cooked_A", "Cooked_B", "Cooked_C"], 
		"difficulty": "hard", 
		"sprite": "res://assets/meals/green-pink-red.png",
		"name": "Green + Red + Pink Meal"
	}
}

func get_meal_info(ingredients: Array) -> Dictionary:
	ingredients.sort()
	var key = ""
	for ingredient in ingredients:
		if key != "":
			key += "+"
		key += ingredient
	return recipes.get(key, {})

func get_random_recipe() -> String:
	var keys = recipes.keys()
	return keys[randi() % keys.size()]
