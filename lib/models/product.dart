class Product {
  String productId;
  String categoryId;
  String title;
  String description;
  double quantity;
  String imageURL;
  String paintingURL;
  List<String> additionalPictures;
  Map<String, String> additionalFields;

  Product({
    this.productId,
    this.categoryId,
    this.title,
    this.description,
    this.quantity = 0,
    this.imageURL = '',
    this.paintingURL = '',
    this.additionalPictures,
    this.additionalFields,
  });
}
