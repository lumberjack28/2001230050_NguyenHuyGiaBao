/// View chỉ nhận thông tin công khai, không nhận hash/salt mật khẩu.
class AppUser {
  const AppUser({required this.id, required this.email});
  final int id;
  final String email;
  factory AppUser.fromMap(Map<String, Object?> map) =>
      AppUser(id: map['id'] as int, email: map['email'] as String);
}
