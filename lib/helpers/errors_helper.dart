class ErrorCodeHelper {
  static String title(int errorCode) {
    switch (errorCode) {
      case 1:
        {
          return "Niepoprawny numer";
        }
        break;
      case 2:
        {
          return "Limit wykorzystany";
        }
        break;
      default:
        {
          return 'Nieznany tytuł kodu błędu';
        }
        break;
    }
  }

  static String content(int errorCode) {
    switch (errorCode) {
      case 1:
        {
          return "Wprowadzony numer telefonu jest niepoprawny";
        }
        break;
      case 2:
        {
          return "Niestety wykoszystałeś już dzisiejszy limit 10 podejść rejestracji. Użyj innego numeru albo spróbuj jutro.";
        }
        break;
      default:
        {
          return 'Nieznana treść kodu błędu';
        }
        break;
    }
  }
}
