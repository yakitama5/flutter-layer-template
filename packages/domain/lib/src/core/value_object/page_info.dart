class PageInfo<T> {
  const PageInfo({required this.items, required this.totalCount});

  final List<T> items;
  final int totalCount;
}
