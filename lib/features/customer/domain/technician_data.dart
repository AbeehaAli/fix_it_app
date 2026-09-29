class Technician {
  final String id;
  final String name;
  final String service;
  final String imageUrl;
  final double rating;
  final int reviews;
  final String distance;
  final String price;
  final String experience;
  final String about;
  final bool availableToday;

  const Technician({
    required this.id,
    required this.name,
    required this.service,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.distance,
    required this.price,
    required this.experience,
    required this.about,
    required this.availableToday,
  });
}