class Profile {
  String email;
  String password;

  Profile(this.email, this.password);
}

class ResponseLogin {
  String status;
  String token;
  String username;
  String ErrorM;
  ResponseLogin(this.status, this.token, this.username, this.ErrorM);
}

class CallPO {
  String BU;
  String PONum;

  CallPO(this.BU, this.PONum);
}
