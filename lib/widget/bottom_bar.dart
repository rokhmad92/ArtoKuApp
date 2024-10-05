import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:artoku/bloc/auth/auth_bloc.dart';
import 'package:artoku/bloc/category/category_bloc.dart';
import 'package:artoku/bloc/laporan/laporan_bloc.dart';
import 'package:artoku/models/category_model.dart';
import 'package:artoku/pages/home.dart';
import 'package:artoku/pages/input.dart';
import 'package:artoku/pages/report.dart';
import 'package:artoku/pages/category.dart';
import 'package:artoku/widget/elevated_button.dart';
import 'package:artoku/widget/select_field.dart';
import 'package:artoku/widget/text_field.dart';

// bottom bar bloc
class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => AuthBloc()),
      BlocProvider(create: (context) => CategoryBloc()),
      BlocProvider(create: (context) => LaporanBloc())
    ], child: const BottomBarView());
  }
}

// bottom bar view
class BottomBarView extends StatefulWidget {
  const BottomBarView({super.key});

  @override
  State<BottomBarView> createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView> {
  int currentIndex = 0;
  DateTime? currentBackPressTime;
  bool canPopNow = false;
  final List<Widget> screens = [
    const Home(),
    const Input(),
    Report(),
    const Categorys(),
  ];

  // form category
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  String? _selectedCategory = 'Pemasukan';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (event, state) {
      if (state is UnAuthenticated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'login', (Route<dynamic> route) => false);
        });
      }

      return PopScope(
        canPop: canPopNow,
        onPopInvokedWithResult: (didPop, dynamic) {
          final now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime!) >
                  const Duration(seconds: 1)) {
            currentBackPressTime = now;
            setState(() {
              canPopNow = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tekan sekali lagi')),
            );
            return;
          } else {
            setState(() {
              canPopNow = true;
            });
          }
        },
        child: Scaffold(
          body: screens[currentIndex],
          floatingActionButton: currentIndex == 3
              ? FloatingActionButton.extended(
                  backgroundColor: Colors.blue,
                  onPressed: () {
                    formDialog(context);
                  },
                  label: const Text(
                    'Tambah',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                )
              : null,
          bottomNavigationBar: NavigationBar(
            indicatorColor: Colors.grey[300],
            backgroundColor: Colors.grey[100],
            height: 60,
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                selectedIcon: Icon(
                  Icons.home,
                ),
                icon: Icon(Icons.home_outlined),
                label: 'Beranda',
              ),
              NavigationDestination(
                  selectedIcon: Icon(
                    Icons.view_agenda,
                  ),
                  icon: Icon(
                    Icons.view_agenda_outlined,
                  ),
                  label: 'Input Data'),
              NavigationDestination(
                  selectedIcon: Icon(
                    Icons.account_balance,
                  ),
                  icon: Icon(Icons.account_balance_outlined),
                  label: 'Laporan'),
              NavigationDestination(
                  selectedIcon: Icon(
                    Icons.category,
                  ),
                  icon: Icon(Icons.category_outlined),
                  label: 'Kategori'),
            ],
          ),
        ),
      );
    });
  }

  // category dialog
  Future formDialog(context) => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                'Form Kategori',
                style: Theme.of(context).primaryTextTheme.displayLarge,
              ),
            ),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FormText(
                    controller: _nameController,
                    labelText: 'Name',
                    hintText: 'Contoh : Liburan',
                    inputActionDone: true,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  FormSelect(
                    list: const ['Pemasukan', 'Pengeluaran'],
                    value: _selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              ButtonElevated(
                onPress: () {
                  if (_formKey.currentState!.validate()) {
                    submit();
                  }
                },
                text: 'Submit',
              ),
            ],
          );
        },
      );

  void submit() async {
    final categoryName = _nameController.text;
    final categoryType = _selectedCategory ?? '';
    final categoryBloc = BlocProvider.of<CategoryBloc>(context);

    final model = CategoryModel(name: categoryName, category: categoryType);

    categoryBloc.add(CreateCategoryEvent(model: model));
    _nameController.clear();

    Navigator.pop(context, categoryName);
  }
}
