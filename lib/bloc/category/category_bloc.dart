import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:artoku/models/category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final Uuid uuid = const Uuid();

  CategoryBloc() : super(CategoryInitial()) {
    on<GetCategoryEvent>((event, emit) async {
      emit(CategoryLoading());

      try {
        await _loadCategories(event.category, emit);
      } catch (e) {
        emit(CategoryError(message: e.toString()));
      }
    });

    on<CreateCategoryEvent>((event, emit) async {
      emit(CategoryLoading());

      final String userId = await getIdUser();

      // Validate
      if (event.model.name.isEmpty ||
          event.model.name.toString() == '' ||
          event.model.name.toString() == 'Kosong') {
        emit(CategoryError(message: 'Nama kategori tidak boleh kosong.'));
        await _loadCategories(event.model.category.toString(), emit);
        return;
      }

      final AggregateQuerySnapshot queryCount = await fireStore
          .collection("category")
          .where('userId', isEqualTo: userId)
          .where('category', isEqualTo: event.model.category.toString())
          .count()
          .get();

      final QuerySnapshot cekUniqueName = await fireStore
          .collection("category")
          .where('userId', isEqualTo: userId)
          .where('name ', isEqualTo: event.model.name)
          .get();

      if (cekUniqueName.docs.isNotEmpty) {
        emit(CategoryError(message: 'Nama kategori sudah dipakai.'));
        await _loadCategories(event.model.category.toString(), emit);
        return;
      }

      if (queryCount.count! >= 6) {
        emit(CategoryError(message: 'Jumlah kategori sudah mencapai batas.'));
        await _loadCategories(event.model.category.toString(), emit);
        return;
      }

      try {
        final String generateUid = uuid.v4();
        fireStore.collection('category').doc(generateUid).set({
          'uid': generateUid,
          'userId': userId,
          'name': event.model.name.toString(),
          'category': event.model.category.toString()
        });

        emit(CategorySuccess(
            message:
                'Berhasil tambah kategori ${event.model.category.toString()}'));
        await _loadCategories(event.model.category.toString(), emit);
      } catch (e) {
        emit(CategoryError(message: e.toString()));
        await _loadCategories(event.model.category.toString(), emit);
      }
    });

    on<UpdateCategoryEvent>((event, emit) async {
      emit(CategoryLoading());

      final String userId = await getIdUser();

      final updateData = fireStore.collection("category").doc(event.uid);
      final docSnapshot = await updateData.get();

      final QuerySnapshot children = await fireStore
          .collection("laporan")
          .where('userId', isEqualTo: userId)
          .where('categoryName', isEqualTo: docSnapshot['name'])
          .get();

      if (!docSnapshot.exists) {
        emit(CategoryError(message: 'Category not found.'));
        return;
      }

      try {
        // proses update
        await fireStore.runTransaction((transaction) async {
          transaction.update(updateData, {"name": event.name});

          for (var item in children.docs) {
            transaction.update(item.reference, {'categoryName': event.name});
          }
        });

        emit(CategorySuccess(message: 'Berhasil update kategori'));
        await _loadCategories(docSnapshot['category'], emit);
      } catch (e) {
        emit(CategoryError(message: e.toString()));
        await _loadCategories(docSnapshot['category'], emit);
      }
    });

    on<DestroyCategoryEvent>((event, emit) async {
      emit(CategoryLoading());

      final String userId = await getIdUser();

      // get Data
      final DocumentReference dataCategory =
          fireStore.collection("category").doc(event.uid);
      final DocumentSnapshot getDataCategory = await dataCategory.get();

      // validate
      if (!getDataCategory.exists) {
        emit(CategoryError(message: 'Kategori tidak ditemukan'));
        return;
      }

      final QuerySnapshot children = await fireStore
          .collection("laporan")
          .where('userId', isEqualTo: userId)
          .where('categoryName', isEqualTo: getDataCategory['name'])
          .get();

      try {
        // proses delete
        await fireStore.runTransaction((transaction) async {
          transaction.delete(dataCategory);

          for (var item in children.docs) {
            transaction.delete(item.reference);
          }
        });

        emit(CategorySuccess(message: 'Berhasil menghapus kategori'));
        await _loadCategories(event.category, emit);
      } catch (e) {
        emit(CategoryError(message: e.toString()));
        await _loadCategories(event.category, emit);
      }
    });
  }

  Future<void> _loadCategories(
      String category, Emitter<CategoryState> emit) async {
    final String userId = await getIdUser();
    try {
      final QuerySnapshot docRef = await fireStore
          .collection("category")
          .where('category', isEqualTo: category)
          .where('userId', isEqualTo: userId)
          .get();

      final categories = docRef.docs.map((doc) {
        return CategoryModel(
          uid: doc.id,
          name: doc['name'],
          category: doc['category'],
        );
      }).toList();

      emit(CategoryLoaded(categories: categories));
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }

  Future<String> getIdUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid') ?? '';
  }
}
