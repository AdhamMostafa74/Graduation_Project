// login exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// register exceptions
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUserAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// generic exceptions
class GenericAuthAuthException implements Exception {}

class UserNotLoggedInAuthAuthException implements Exception {}

