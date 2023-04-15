class FirebaseUserInfo {
  String? userEmail;
  String? userName;
  String? userProfilePhotoUrl;

  FirebaseUserInfo({
    this.userEmail,
    this.userName,
    this.userProfilePhotoUrl,
  });

  factory FirebaseUserInfo.Instance() {
    return FirebaseUserInfo(
      userEmail: "",
      userName: "",
      userProfilePhotoUrl: "",
    );
  }
}
