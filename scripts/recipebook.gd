extends Node
class_name RecipeBook

# Singleton for managing recipes
var recipes = {
	   "Cooked_A": ["Cooked_A"],
	   "Cooked_B": ["Cooked_B"],
	   "Cooked_C": ["Cooked_C"],
	   "Cooked_A+Cooked_B": ["Cooked_A", "Cooked_B"],
	   "Cooked_A+Cooked_C": ["Cooked_A", "Cooked_C"],
	   "Cooked_B+Cooked_C": ["Cooked_B", "Cooked_C"],
	   "Cooked_A+Cooked_B+Cooked_C": ["Cooked_A", "Cooked_B", "Cooked_C"]
}

func get_meal(ingredients: Array) -> String:
	ingredients.sort()
	var key = ""
	for ingredient in ingredients:
		if key != "":
			key += "+"
		key += ingredient
	# Ensure the function returns a string by joining the array elements or an empty string if not found
	var meal_components = recipes.get(key, [])
	return "+".join(meal_components) if meal_components else ""
