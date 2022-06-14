class UserInformation {
  String? uid, fitbitAccessToken, fitbitRefreshToken, fitbitUserId;
  String firstName,
      lastName,
      nationality,
      age,
      email,
      password,
      // exposureValue,
      // symptoms,
      gender;
  // List? checkUp;
  // bool isVaccinated, haveSymptoms;

  UserInformation({
    this.uid,
    this.fitbitUserId,
    this.firstName = '',
    this.lastName = '',
    this.nationality = '',
    this.age = '',
    this.email = '',
    this.password = '',
    // this.checkUp,
    // this.exposureValue = '',
    // this.symptoms = '',
    this.gender = '',
    // this.isVaccinated = false,
    // this.haveSymptoms = false,
    this.fitbitAccessToken,
    this.fitbitRefreshToken,
  });

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'nationality': nationality,
        'age': age,
        'gender': gender,
        // 'exposure':exposureValue,
        // 'isVaccinated':isVaccinated,
        // 'haveSymptoms':haveSymptoms,
        // 'checkUp': checkUp,
        // 'symptoms': symptoms,
        'fitbitAccessToken': fitbitAccessToken,
        'fitbitRefreshToken': fitbitRefreshToken,
        'fitbitUserId': fitbitUserId,
      };
  factory UserInformation.fromJson(Map<String, dynamic>? data) =>
      UserInformation(
        firstName: data!['firstName'] ?? '',
        lastName: data['lastName'] ?? '',
        // email: data['email'] ?? '',
        // nationality: data['nationality'] ?? '',
        // age: data['age'] ?? '',
        // gender: data['gender'] ?? '',
        // exposureValue: data['exposure'] ?? '',
        // isVaccinated: data['isVaccinated']?? false,
        // haveSymptoms: data['haveSumptoms'] ?? false,
        // checkUp: data['checkUp'] ?? [],
        // symptoms: data['symtoms'] ?? '',
        fitbitAccessToken: data['fitbitAccessToken'] ?? '',
        fitbitRefreshToken: data['fitbitRefreshToken'] ?? '',
        fitbitUserId: data['fitbitUserId'] ?? '',
      );
}
