part of 'category_bloc.dart';

@immutable
sealed class CategoryState {}

final class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryModel> categories;

  CategoryLoaded({required this.categories});
}

class CategorySuccess extends CategoryState {
  final String message;

  CategorySuccess({required this.message});
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError({required this.message});
}
