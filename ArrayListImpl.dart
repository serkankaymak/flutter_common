

import 'dart:collection';

import 'delegates.dart';

class ItemWrapper<T> {
  T? item; // null olabilen bir item
  int index;
  ItemWrapper? next, previous;
  ItemWrapper(this.item, this.index); // Constructor
}

class ArrayListStream<T> extends ListBase<T?> {
  final List<T?> _innerList = [];

  static ArrayListStream<T> fromObject<T>(T t) {
    final arrayListStream = ArrayListStream<T>();
    arrayListStream.add(t);
    return arrayListStream;
  }

  static ArrayListStream<T> fromList<T>(List<T> list) {
    final arrayListStream = ArrayListStream<T>();
    for (var item in list) {
      arrayListStream.add(item);
    }
    return arrayListStream;
  }

  static ArrayListStream<T> fromArrayListStream<T>(
      ArrayListStream<T> arrayListStream) {
    final newList = ArrayListStream<T>();
    for (var item in arrayListStream) {
      newList.add(item);
    }
    return newList;
  }

  int findIndex(PredicateDelegate<T> predicate) {
    for (int i = 0; i < _innerList.length; i++) {
      if (predicate(_innerList[i])) return i;
    }
    return -1;
  }

  T? getFromIndex(int index) => _innerList[index];

  // selectWithIndex Metodu
  ArrayListStream<T2> selectWithIndex<T2>(FuncDelegate<ItemWrapper<T>, T2> func) {
    final returning = ArrayListStream<T2>();
    for (int i = 0; i < _innerList.length; i++) {
      T? item = _innerList[i];
      if (item != null) continue;

      T2 transformedItem = func(ItemWrapper(item, i));
      returning.add(transformedItem);
    }
    return returning;
  }

  // foreachExecuteThisWithIndex Metodu
  void foreachExecuteThisWithIndex(ActionDelegate<ItemWrapper<T?>> action) {
    for (int i = 0; i < _innerList.length; i++) {
      T? item = _innerList[i];
      if (item == null) continue;
      action(ItemWrapper(item, i));
    }
  }

  ArrayListStream<ItemWrapper> getLinkedItems() {
    var newList = ArrayListStream<ItemWrapper>();

    // First, create a single ItemWrapper for each item in _innerList and store in _newList
    for (var i = 0; i < _innerList.length; i++) {
      var c = ItemWrapper(getFromIndex(i), i);
      newList.add(c);
    }

    // Next, set the previous and next pointers
    for (var i = 0; i < newList.length; i++) {
      var c = newList.getFromIndex(i); // Current item
      if (i > 0) {
        var p = newList.getFromIndex(i - 1); // Previous item
        if (p != null) {
          c!.previous = p;
          p.next = c;
        }
      }
      if (i < newList.length - 1) {
        var n = newList.getFromIndex(i + 1); // Next item
        if (n != null) {
          c!.next = n;
          n.previous = c;
        }
      }
    }

    return newList;
  }

  @override
  int get length => _innerList.length;

  @override
  set length(int newLength) {
    _innerList.length = newLength;
  }

  @override
  T? operator [](int index) => _innerList[index];

  @override
  void operator []=(int index, T? value) => _innerList[index] = value;

  @override
  void add(T? element) => _innerList.add(element);
  @override
  void addAll(Iterable<T?> iterable) => _innerList.addAll(iterable);

  ArrayListStream<T> wheree(bool Function(T?) predicate) {
    var newList = ArrayListStream<T>();
    for (var item in _innerList) {
      if (predicate(item)) {
        newList.add(item);
      }
    }
    return newList;
  }

  void foreachExecuteThis(ActionDelegate<T?> action) {
    for (var element in _innerList) {
      if (element == null) continue;
      action(element);
    }
  }

  Map<R, ArrayListStream<T>> groupBy<R>(FuncDelegate<T?, R> func) {
    final Map<R, ArrayListStream<T>> groups = {};
    for (var item in _innerList) {
      if (item == null) continue;
      final key = func(item);
      groups.putIfAbsent(key, () => ArrayListStream<T>());
      groups[key]!.add(item);
    }
    return groups;
  }

  ArrayListStream<T?> getUniqueList<T2>(FuncDelegate<T?, T2> func) {
    if (_innerList.isEmpty) throw Exception("Liste boş");
    final uniqueValues = <T2>{};
    final uniqueList = ArrayListStream<T?>();
    for (var item in _innerList) {
      if (item == null) continue;
      final value = func(item);
      if (value != null && uniqueValues.add(value)) {
        uniqueList.add(item);
      }
    }
    return uniqueList;
  }

  T? findMax<R extends Comparable>(FuncDelegate<T?, R> func) {
    if (_innerList.isEmpty) throw Exception("Liste boş");

    T? maxItem;
    for (var item in _innerList) {
      if (item == null) continue;
      if (maxItem == null || func(item).compareTo(func(maxItem)) > 0) {
        maxItem = item;
      }
    }
    return maxItem;
  }

  int countForThisMatch(PredicateDelegate<T> predicate) =>
      _innerList.where(predicate).length;

  bool isAllMatch(PredicateDelegate<T> predicate) => _innerList.every(predicate);

  bool isThereAllSame<R>(FuncDelegate<T, R> func) {
    if (length <= 1) return true;
    final firstValue = func(_innerList.first);
    return _innerList.every((item) => func(item) == firstValue);
  }

  String convertToPlainStringArray(FuncDelegate<T, String> func) {
    return _innerList.map(func).join(',');
  }

  ArrayListStream<R> select<R>(FuncDelegate<T, R> func) {
    final result = ArrayListStream<R>();
    for (var item in _innerList) {
      if (item == null) continue;
      result.add(func(item));
    }
    return result;
  }

  T? firstOrDefault(PredicateDelegate<T> predicate) {
    for (var item in _innerList) {
      if (predicate(item)) return item;
    }
    return null;
  }
}



