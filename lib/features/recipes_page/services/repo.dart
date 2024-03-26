import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meal_ai/core/utils/helper_methods.dart';
import 'package:meal_ai/features/recipes_page/models/recipe_model/ai_model.dart';
import 'package:meal_ai/features/recipes_page/models/recipe_model/recipe_model.dart';

abstract class HomePageRepository {
  Future<dynamic> askAI(String prompt);
}

class HomePageRepo extends HomePageRepository {
  Future<dynamic> addAIRecipe(String responseString) async {
    try {
      var splittedText = responseString.split("\n\n");
      var title = splittedText[1].replaceAll("Recipe:", "");
      var ingredients = splittedText[2].replaceAll("Ingredients:", "");
      var cleanedIngredients = ingredients.replaceAll("-", "");
      List<String> ingredientsList = cleanedIngredients.split('\n');
      var nutrionalInformation =
          splittedText[3].replaceAll("Nutritional Facts:", "");
      var instructions = splittedText.sublist(5, splittedText.length - 1);

      var instructionsString = instructions.join('\n');
      RegExp regex = RegExp(r'^\d+\.\s+', multiLine: true);
      String stringWithoutNumbers = instructionsString.replaceAll(regex, '');
      Map<String, String> extractNutrition(String str) {
        Map<String, String> nutritionMap = {};

        // Regular expression to match the pattern: "- Key: Value"
        RegExp exp = RegExp(r'-\s*([A-Za-z]+):\s*(\S+)', multiLine: true);

        // Use the RegExp to find matches and fill the map
        for (final match in exp.allMatches(str)) {
          String key = match.group(1)!; // Extracting the key
          String value = match.group(2)!; // Extracting the value
          nutritionMap[key] = value; // Adding the key-value pair to the map
        }

        return nutritionMap;
      }

      print(extractNutrition(nutrionalInformation));

      var recipe = RecipeModel(
          key: Random().nextInt(1000000).toString(),
          host: "Undefined",
          title: title,
          total_time: 30,
          image:
              "https://www.foodandwine.com/thmb/fjNakOY7IcuvZac1hR3JcSo7vzI=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/FAW-recipes-pasta-sausage-basil-and-mustard-hero-06-cfd1c0a2989e474ea7e574a38182bbee.jpg",
          ingredients: ingredientsList.sublist(1, ingredientsList.length),
          instructions: stringWithoutNumbers,
          nutrients: Nutrients(
              calories: (extractNutrition(nutrionalInformation)['Calories'])
                  .toString(),
              carbohydrateContent:
                  (extractNutrition(nutrionalInformation)['Carbohydrates'])
                      .toString(),
              proteinContent:
                  (extractNutrition(nutrionalInformation)['Protein'])
                      .toString(),
              fatContent:
                  (extractNutrition(nutrionalInformation)['Fat']).toString(),
              saturatedFatContent: '--',
              sodiumContent: '--',
              fiberContent: '--',
              sugarContent: '--',
              servingSize: '--'),
          servings: "4",
          addTime: "30");
      return recipe;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<dynamic> askAI(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer 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'
        },
        body: jsonEncode(
          {
            "model": "gpt-3.5-turbo-instruct",
            "prompt":
                "Create a recipe from a list of ingredients: \n$prompt with nutrional facts",
            "max_tokens": 250,
            "temperature": 0,
            "top_p": 1,
          },
        ),
      );

      var responseString =
          ResponseModel.fromJson(response.body).choices[0]['text'];

      return responseString;
    } catch (e) {
      return e.toString();
    }
  }
}
