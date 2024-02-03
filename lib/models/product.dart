 class Product{
  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.photo,
    required this.isDiscounted,
  });
  int id;
  String title;
  double price;
  String description;
  String photo; 
  bool isDiscounted;
}