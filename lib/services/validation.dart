

// abstract class 
abstract class ValidationBase {

  bool checkIfEmpty(String string);

}

// a class that has a funct that checks if string is empty - implemented from above abstract class 
class CheckIfEmptyValidator implements ValidationBase {

  @override
  bool checkIfEmpty(String string) {
  
    return string.isEmpty ? true : false;
  } 

}

// mixin wich will add functionality to the other function, which includes above class and 2 more error texts
mixin EmailAndPasswordValidationFunctionality {

  CheckIfEmptyValidator checkIfEmptyValidatorEmail = CheckIfEmptyValidator();
  CheckIfEmptyValidator checkIfEmptyValidatorPassword = CheckIfEmptyValidator();
  
  final String invalidEmailErrorText = 'Email can\'t be empty';
  final String invalidPasswordErrorText = 'Password can\'t be empty';

}