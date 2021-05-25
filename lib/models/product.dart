class Product {
  String id;
  String name;
  String type;
  bool isSalable;

  Product();

  Product.fromProducts(
    this.id,
    this.name,
    this.type,
    this.isSalable,
  );
}
