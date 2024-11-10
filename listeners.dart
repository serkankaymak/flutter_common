typedef Action<T> = void Function(T? obj);
typedef Action2<T1, T2> = void Function(T1? obj1, T2 obj2);
typedef Func<T, T2> = T2 Function(T? obj);
typedef Predicate<T> = bool Function(T? obj);
