import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_ai/features/recipes_page/widgets/enter_ai_dialog.dart';
import 'package:meal_ai/features/recipes_page/widgets/enter_url_dialog_widget.dart';
import 'package:pull_down_button/pull_down_button.dart';

class AddRecipeMenu extends ConsumerStatefulWidget {
  const AddRecipeMenu({super.key, required this.builder});
  final PullDownMenuButtonBuilder builder;

  @override
  ConsumerState<AddRecipeMenu> createState() => _MealPlanMenuState();
}

class _MealPlanMenuState extends ConsumerState<AddRecipeMenu> {
  @override
  Widget build(BuildContext context) {
    return PullDownButton(
        itemBuilder: (context) => [
              PullDownMenuItem(
                title: 'AI Suggestion',
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const EnterAIDialogWidget(),
                      fullscreenDialog: true));
                },
                icon: CupertinoIcons.pencil,
              ),
              PullDownMenuItem(
                title: 'Enter URL',
                icon: Icons.link,
                onTap: () {
                  showCupertinoDialog(
                    context: context,
                    useRootNavigator: true,
                    builder: (context) {
                      return const EnterUrlDialogWidget();
                    },
                  );
                },
              ),
              PullDownMenuItem(
                title: 'Scan Recipe',
                onTap: () {},
                icon: Icons.document_scanner_outlined,
              ),
              PullDownMenuItem(
                onTap: () {},
                title: 'Pick Image',
                icon: Icons.image_outlined,
              ),
              PullDownMenuItem(
                onTap: () {},
                title: 'Choose PDF',
                icon: Icons.picture_as_pdf_outlined,
              ),
            ],
        position: PullDownMenuPosition.automatic,
        buttonBuilder: widget.builder);
  }
}
