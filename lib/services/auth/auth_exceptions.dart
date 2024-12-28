// Login exceptions
class WrongCredentialsAuthException implements Exception {

}

// Register exceptions
class UsernameAlreadyTakenAuthException implements Exception {

}

class EmailAlreadyUsedAuthException implements Exception {

}

class EmailFormatAuthException implements Exception {

}

class PasswordDoesntMatchAuthException implements Exception {

}

class WeakPasswordAuthException implements Exception {

}

// Generic exceptions
class GenericAuthException implements Exception {

}

class UserNotLoggedInAuthException implements Exception {

}