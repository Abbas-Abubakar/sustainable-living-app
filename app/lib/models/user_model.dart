
class UserModel {
  final String uid;
  final String name;
  final String email;
  final List<String> preferredProductCategories;
  final List<String> ecoGoals;
  final double carbonFootprint;
  final double wasteReducedKg;
  final int challengesCompleted;
  final Map<String, bool> currentChallenges;
  final List<String> completedChallenges;
  final List<String> savedRecipes;
  final List<String> bookmarkedProducts;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.preferredProductCategories = const [],
    this.ecoGoals = const [],
    this.carbonFootprint = 0.0,
    this.wasteReducedKg = 0.0,
    this.challengesCompleted = 0,
    this.currentChallenges = const {},
    this.completedChallenges = const [],
    this.savedRecipes = const [],
    this.bookmarkedProducts = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      preferredProductCategories: List<String>.from(json['preferredProductCategories'] ?? []),
      ecoGoals: List<String>.from(json['ecoGoals'] ?? []),
      carbonFootprint: (json['carbonFootprint'] ?? 0.0).toDouble(),
      wasteReducedKg: (json['wasteReducedKg'] ?? 0.0).toDouble(),
      challengesCompleted: json['challengesCompleted'] ?? 0,
      currentChallenges: Map<String, bool>.from(json['currentChallenges'] ?? {}),
      completedChallenges: List<String>.from(json['completedChallenges'] ?? []),
      savedRecipes: List<String>.from(json['savedRecipes'] ?? []),
      bookmarkedProducts: List<String>.from(json['bookmarkedProducts'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'preferredProductCategories': preferredProductCategories,
      'ecoGoals': ecoGoals,
      'carbonFootprint': carbonFootprint,
      'wasteReducedKg': wasteReducedKg,
      'challengesCompleted': challengesCompleted,
      'currentChallenges': currentChallenges,
      'completedChallenges': completedChallenges,
      'savedRecipes': savedRecipes,
      'bookmarkedProducts': bookmarkedProducts,
    };
  }
}
