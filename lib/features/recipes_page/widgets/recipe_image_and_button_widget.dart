import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meal_ai/core/styles/text_styles.dart';
import 'package:meal_ai/core/widgets/app_button.dart';
import 'package:meal_ai/features/recipes_page/models/recipe_model/recipe_model.dart';

class RecipeImageAndButton extends StatelessWidget {
  const RecipeImageAndButton({
    super.key,
    required this.recipe,
  });

  final RecipeModel recipe;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CachedNetworkImage(
          imageUrl: recipe.image,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 300,
        ),
      ],
    );
  }
}
