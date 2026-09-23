class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final int totalOrders;
  final int wishlistCount;
  final int blinkCartPoints;
  final String avatarUrl;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.totalOrders = 24,
    this.wishlistCount = 8,
    this.blinkCartPoints = 420,
    this.avatarUrl = '',
  });

  factory UserProfile.sample() {
    return const UserProfile(
      id: 'USR1001',
      name: 'Sanchita',
      email: 'sanchita@example.com',
      phoneNumber: '+91 98765 43210',
      totalOrders: 24,
      wishlistCount: 8,
      blinkCartPoints: 420,
    );
  }
}
