class User {
  final String userId;
  final String userName;
  final String phoneNum;
  final String email;
  //FirebaseUser _firebaseUser;
  String displayName = 'Prueba';

  User({
    this.userId,
    this.userName,
    this.phoneNum,
    this.email,
  });

  //FirebaseUser get firebaseUser => _firebaseUser;


//  set firebaseUser(FirebaseUser user) {
//    this._firebaseUser = user;
//    notifyListeners();
//  }

  String get getDisplayName => displayName;

  set setDisplayName(String name){
    this.displayName = name;
  }
//
//  set errorLogin(String error) {
//    this._errorMessage = error;
//  }

  /// toEntity - This method converts the User POJO to an entity object
  /// The entity class has further methods to convert the POJO to datastore related objects
// UserEntity toEntity() {
//   return UserEntity(userId: this.userId, userName: this.userName, phoneNum: this.phoneNum);
// }

  /// fromEntity - This method creates the POJO back from the entity object
// static User fromEntity(UserEntity entity) {
//   return User(userId: entity.userId, userName: entity.userName, phoneNum: entity.phoneNum);
// }
}
