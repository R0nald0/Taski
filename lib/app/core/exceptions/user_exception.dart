
sealed class UserException implements Exception {
  
}

class UserRepositoryException extends UserException {
      final String errorMessage;
    UserRepositoryException(this.errorMessage);
}
class UserNotFound extends UserException{
    
}
