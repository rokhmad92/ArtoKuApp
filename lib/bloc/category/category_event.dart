// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'category_bloc.dart';

@immutable
sealed class CategoryEvent {}

class GetCategoryEvent extends CategoryEvent {
  final String category;

  GetCategoryEvent({required this.category});
}

class CreateCategoryEvent extends CategoryEvent {
  final CategoryModel model;

  CreateCategoryEvent({required this.model});
}

class UpdateCategoryEvent extends CategoryEvent {
  final String uid;
  final String name;

  UpdateCategoryEvent({required this.uid, required this.name});
}

class DestroyCategoryEvent extends CategoryEvent {
  final String uid;
  final String category;

  DestroyCategoryEvent({
    required this.uid,
    required this.category,
  });
}
