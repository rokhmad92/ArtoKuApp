import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:artoku/bloc/category/category_bloc.dart';
import 'package:artoku/widget/button_select.dart';
import 'package:artoku/listData/list_category.dart';
import 'package:artoku/widget/templete.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Categorys extends StatelessWidget {
  const Categorys({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryBloc>().add(GetCategoryEvent(category: 'Pemasukan'));
    });
    final List<Widget> skeletonLoaders = List.generate(
      6,
      (index) => const Skeletonizer(
        enabled: true,
        child: ListCategory(
          name: 'skeleton',
          uid: '',
          category: '',
        ),
      ),
    );

    return Templete(
        withScrollView: true,
        content: Column(
          children: [
            const ButtonSelect(
              options: ['Pemasukan', 'Pengeluaran'],
              getCategory: true,
            ),
            const SizedBox(height: 20),
            BlocListener<CategoryBloc, CategoryState>(
              listener: (context, state) {
                if (state is CategorySuccess) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                } else if (state is CategoryError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              child: BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoading) {
                    return Column(children: skeletonLoaders);
                  } else if (state is CategoryLoaded) {
                    return state.categories.isEmpty
                        ? const Center(
                            child: Text(
                            'Category belum tersedia',
                            style: TextStyle(
                                color: Colors.black45, fontSize: 20.0),
                          ))
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.categories.length,
                            itemBuilder: (context, index) {
                              final category = state.categories[index];
                              return ListCategory(
                                uid: category.uid!,
                                name: category.name,
                                category: category.category,
                              );
                            },
                          );
                  } else {
                    return const Center();
                  }
                },
              ),
            )
          ],
        ));
  }
}
