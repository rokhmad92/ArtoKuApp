import 'package:flutter/material.dart';
import 'package:artoku/widget/dialog.dart';

class ListCategory extends StatelessWidget {
  const ListCategory(
      {super.key,
      required this.uid,
      required this.name,
      required this.category});
  final String uid;
  final String name;
  final String category;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: Theme.of(context).primaryTextTheme.displayMedium,
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  DialogWidget.editCategory(context, uid, name, category);
                },
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                onPressed: () {
                  DialogWidget.deleteCategory(context, uid, category);
                },
                icon: const Icon(Icons.delete_outlined),
              ),
            ],
          ),
        ],
      ),
      const Divider(
        color: Colors.black54,
        thickness: 1,
        height: 20,
      ),
    ]);
  }
}
