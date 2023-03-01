List<To> mapToList<From, To>(
    List<From> eList, To Function(From) map) {
  final list = <To>[];
  for (var element in eList) {
      final value = map(element);
      list.add(value);
  }
  return list;
}
