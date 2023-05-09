class HttpException implements Exception {
  final String message;
  HttpException(this.message); //constructor

  @override
  String toString() {
    return message;
    // return super.toString(); //instance of HttpException
  }
}
