import 'dart:collection';

typedef ActionDelegate<T> = void Function(T? obj);
typedef Action2Delegate<T1, T2> = void Function(T1? obj1, T2 obj2);
typedef FuncDelegate<T, T2> = T2 Function(T? obj);
typedef PredicateDelegate<T> = bool Function(T? obj);