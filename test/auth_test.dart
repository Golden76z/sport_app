import 'package:sport_app/services/auth/auth_exceptions.dart';
import 'package:sport_app/services/auth/auth_provider.dart';
import 'package:sport_app/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should not be initialized to begin with', () {
      expect(
        provider.isInitialized, 
        false
      );
    });
    test('Cannot log out if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
        );
    });

    test('Should be able to be initialized', () async {
      await provider.initialize();
      expect(
        provider.isInitialized, 
        true
      );
    });

    test('User should be null after initialization', () {
      expect(
        provider.currentUser, 
        null
      );
    });

    test('Should be able to initialized in less than 2 seconds', () async {
      await provider.initialize();
      expect(
        provider.isInitialized, 
        true
      );
    }, timeout: const Timeout(Duration(seconds: 2))
    );

    test('Create user should delegate to login function', () async {
      // Testing the bad email error
      final badEmailUser = provider.createUser(
        email: 'test@test.com', 
        password: 'password'
      );
      expect(
        badEmailUser, 
        throwsA(const TypeMatcher<UserNotLoggedInAuthException>())
      );

      // Testing the bad password error
      final badPasswordUser = provider.createUser(
        email: 'test', 
        password: 'test'
      );
      expect(
        badPasswordUser, 
        throwsA(const TypeMatcher<WrongCredentialsAuthException>())
      );

      // Testing if the user has been successfully created
      final user = await provider.createUser(
        email: 'good_test', 
        password: 'good_test'
      );
      expect(
        provider.currentUser, 
        user
      );
      expect(
        user.isEmailVerified, 
        false
      );
    });
    test('Logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(
        user, 
        isNotNull
      );
      expect(
        user?.isEmailVerified, 
        true
      );
    });

    test('Should be able to log out and log in again', () async {
      await provider.logOut();
      await provider.logIn(
        email: 'email', 
        password: 'password'
      );
      final user = provider.currentUser;
      expect(
        user,
        isNotNull
      );
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({required String email, required String password}) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email, 
      password: password
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'test@test.com') throw UserNotLoggedInAuthException();
    if (password == 'test') throw WrongCredentialsAuthException();
    const user = AuthUser(
      id: 'my_id',
      isEmailVerified: false, 
      email: 'test@test.fr'
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotLoggedInAuthException;
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotLoggedInAuthException();
    const newUser = AuthUser(
      id: 'my_id', 
      isEmailVerified: true, 
      email: 'test@test.fr'
    );
    _user = newUser;
  }

}