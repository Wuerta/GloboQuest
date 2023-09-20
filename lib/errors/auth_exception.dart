abstract class AuthException implements Exception {}

base class LoginException implements AuthException {
  const LoginException();
}

base class AbortedGoogleLoginException implements AuthException {
  const AbortedGoogleLoginException();
}

base class GoogleLoginException implements AuthException {
  const GoogleLoginException();
}
