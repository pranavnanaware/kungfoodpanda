import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_ai/core/utils/helper_methods.dart';
import 'package:meal_ai/features/recipes_page/models/recipe_model/recipe_model.dart';
import 'package:meal_ai/features/recipes_page/providers/recipe_from_url_provider/recipe_from_url_provider.dart';
import 'dart:math' as math;

import 'package:meal_ai/features/recipes_page/services/repo.dart';

class EnterAIDialogWidget extends ConsumerStatefulWidget {
  const EnterAIDialogWidget({
    super.key,
  });

  @override
  ConsumerState<EnterAIDialogWidget> createState() =>
      _EnterAIDialogWidgetState();
}

class _EnterAIDialogWidgetState extends ConsumerState<EnterAIDialogWidget> {
  late TextEditingController controller;
  late FocusNode focusNode;
  final List<String> inputTags = [];
  String response = "";
  String buttonState = "Generate";

  @override
  void initState() {
    controller = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipe Generator"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const Text(
                  'We will help you find recipes!',
                  maxLines: 3,
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        autofocus: true,
                        autocorrect: true,
                        focusNode: focusNode,
                        controller: controller,
                        onFieldSubmitted: (value) {
                          controller.clear();
                          setState(() {
                            inputTags.add(value);
                            focusNode.requestFocus();
                          });
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5.5),
                              bottomLeft: Radius.circular(5.5),
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                          labelText: "Enter Ingredients",
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Theme.of(context).colorScheme.primary,
                      child: Padding(
                        padding: const EdgeInsets.all(9),
                        child: IconButton(
                          onPressed: () {
                            controller.clear();
                            setState(() {
                              inputTags.add(controller.text);
                              focusNode.requestFocus();
                            });
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Wrap(
                    children: [
                      for (int i = 0; i < inputTags.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                          ),
                          child: Chip(
                            backgroundColor: Color(
                                    (math.Random().nextDouble() * 0xFFFFFF)
                                        .toInt())
                                .withOpacity(0.1),
                            label: Text(
                              inputTags[i],
                            ),
                            deleteIcon: const Icon(
                              Icons.close,
                              size: 20,
                            ),
                            onDeleted: () {
                              setState(() {
                                inputTags.remove(inputTags[i]);
                              });
                            },
                          ),
                        )
                    ],
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    child: Center(
                        child: SingleChildScrollView(
                      child: Text(
                        response,
                        style: const TextStyle(fontSize: 20),
                      ),
                    )),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    child: buttonState == "Generate"
                        ? const Text("Generate Recipe")
                        : const Text("Add Recipe"),
                    onPressed: () async {
                      if (buttonState == "Generate") {
                        setState(() => response = "Thinking....");
                        var temp =
                            await HomePageRepo().askAI(inputTags.toString());
                        if (!mounted) {
                          return;
                        }
                        setState(() {
                          response = temp;
                          buttonState = "Create";
                        });
                      } else {
                        var recipe = await HomePageRepo().addAIRecipe(response);
                        await ref
                            .read(recipeFromUrlProvider.notifier)
                            .addRecipeFromUrlToHive(recipe: recipe);
                        if (!mounted) {
                          return;
                        }
                        setState(() {
                          buttonState = "Generate";
                        });
                        Navigator.pop(context);
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
