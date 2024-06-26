/// regexpattern: ^2.6.0
/// Strict Pattern
/// Symbol ^ and $ in pattern is to make sure all the string value following the pattern
/// Regex will return false if any of the character not following the pattern, even if using hasMatch function
/// Example: Pattern : Email -> 'This is your email : test@gmail.com' will return `false`, but 'test@gmail.com' will return `true`
class RegexPattern {
  RegexPattern._();

  /// Username regex (Simple)
  ///
  /// Minimum 3 character
  /// Allowed to use underscore ("_") and period (".") characters in middle of name
  static String username = r'^[a-zA-Z0-9][a-zA-Z0-9_.]+[a-zA-Z0-9]$';

  /// Username regex (v2)
  ///
  /// May start with @
  /// Minimum 3 characters
  /// Allowed to use aplhanumeric, underscore ("_"), dash ("-"), and period (".") characters.
  /// Has only one symbols in a row.
  /// Symbols can only be used in the middle of name.
  static String usernameV2 =
      r'^(?!.*[_\.\-]{2})@?[a-zA-Z0-9][a-zA-Z0-9_\.\-]+[a-zA-Z0-9]$';

  /// Username (Google) regex
  ///
  /// Minimum 6 characters, maximum 30 characters
  /// Contain letters (a-z), numbers (0-9), and period (.).
  /// Must start and end with with letters or numbers.
  /// Can't have consecutive period (.).
  static String usernameGoogle =
      r'^(?!.*\.\.)[a-zA-Z0-9][a-zA-Z0-9\.]{4,28}[a-zA-Z0-9]$';

  /// just name EN
  /// NOT Allowing "_" and "." in middle of name
  static String fullNameEn = r'^[a-zA-Z]{3,}(?: [a-zA-Z]+){0,2}$';

  ///just name AR
  static String fullNameAr = r'^[\u0621-\u064A ]+$';

  /// Username (Instagram) regex
  ///
  /// May start with @
  /// Minimum 3 characters, maximum 30 characters
  /// Allowed to use aplhanumeric, underscore ("_") and period (".") characters
  /// Can't start or end with period (".")
  /// Can't have consecutive period (.).
  static String usernameInstagram = r'^(?!.*\.\.)@?\w[\w\.]{1,28}\w$';

  /// Username (Discord) regex
  ///
  /// Reference: https://discord.com/developers/docs/resources/user#usernames-and-nicknames
  static String usernameDiscord =
      r'^(?!.*(discord|[`]{3}))(?!here|everyone).[^\#\@\:]{0,30}(#[0-9]{4})?$';

  /// Email regex
  ///
  /// References: [RFC2822 Email Validation](https://regexr.com/2rhq7) by Tripleaxis
  static String email =
      r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$";

  /// URL regex
  ///
  /// Eg:
  /// - https://medium.com/@diegoveloper/flutter-widget-size-and-position-b0a9ffed9407
  /// - https://www.youtube.com/watch?v=COYFmbVEH0k
  /// - https://stackoverflow.com/questions/53913192/flutter-change-the-width-of-an-alertdialog/57688555
  static String url =
      r"^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,6}(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&amp;%\$#\=~_\-@]+))*$";

  /// URI regex
  ///
  /// Examples:
  /// - https://medium.com/@diegoveloper/flutter-widget-size-and-position-b0a9ffed9407
  /// - https://www.youtube.com/watch?v=COYFmbVEH0k
  /// - https://stackoverflow.com/questions/53913192/flutter-change-the-width-of-an-alertdialog/57688555
  /// - http://192.168.0.1:8080
  /// - https://john.doe@www.example.com:123/forum/questions/?tag=networking&order=newest#top
  /// - http://a/b/c/d;p?q
  /// - twitter://
  /// - fb://profile/33138223345
  /// - mailto:John.Doe@example.com
  /// - ldap://[2001:db8::7]/c=GB?objectClass?one
  /// - tel:+1-816-555-1212
  /// - telnet://192.0.2.16:80/
  /// - news:comp.infosystems.www.servers.unix
  /// - urn:oasis:names:specification:docbook:dtd:xml:4.1.2
  ///
  /// Reference:
  /// https://datatracker.ietf.org/doc/html/rfc3986
  /// https://en.wikipedia.org/wiki/Uniform_Resource_Identifier
  static String uri =
      r"^(?!.*[?@!&`()*+,;=_\-~\]\[#$]{2})(?!.*[?@!&`()*+,;=_.\-~:?\[\]]$)(?!.*(\/\.|\.\/))(\w+:(\/\/)?)\S*$";

  /// Phone Number regex
  ///
  /// Must be started either with "0", "+", "+XX <X between 2 to 4 digit>", or "(+XX <X between 2 to 3 digit>)"
  /// It is possible to add whitespace separating digit with "+" or "(+XX)"
  ///
  /// Examples:
  /// - 05555555555
  /// - +555 5555555555
  /// - (+123) 5555555555
  /// - (555) 5555555555
  /// - +5555 5555555555
  static String phone =
      r'^(0|\+|(\+[0-9]{2,4}|\(\+?[0-9]{2,4}\)) ?)([0-9]*|\d{2,4}-\d{2,4}(-\d{2,4})?)$';

  /// Hexadecimal regex
  static String hexadecimal = r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$';

  /// Image vector regex
  static String vector = r'.(svg)$';

  /// Image regex
  static String image = r'.(jpeg|jpg|gif|png|bmp|webp|heic)$';

  /// Audio regex
  static String audio = r'.(mp3|wav|wma|amr|ogg)$';

  /// Video regex
  static String video = r'.(mp4|avi|wmv|rmvb|mpg|mpeg|3gp)$';

  /// Txt regex
  static String txt = r'.txt$';

  /// Document regex
  static String doc = r'.(doc|docx)$';

  /// Excel regex
  static String excel = r'.(xls|xlsx)$';

  /// PPT regex
  static String ppt = r'.(ppt|pptx)$';

  /// APK regex
  static String apk = r'.apk$';

  /// IPA regex
  static String ipa = r'.ipa$';

  /// PDF regex
  static String pdf = r'.pdf$';

  /// HTML regex
  static String html = r'.html$';

  /// DateTime regex (UTC)
  ///
  /// Valid Formats:
  /// - YYYY-MM-DDTHH:mm:ss.ffffffZ
  /// - YYYY-MM-DDTHH:mm:ss.ffffff
  /// - YYYY-MM-DD HH:mm:ss.ffffffZ
  /// - YYYY-MM-DD HH:mm:ss.ffffff
  /// - YYYY-MM-DDTHH:mm:ss.fffZ
  /// - YYYY-MM-DDTHH:mm:ss.fff
  /// - YYYY-MM-DD HH:mm:ss.fffZ
  /// - YYYY-MM-DD HH:mm:ss.fff
  ///
  /// Examples:
  /// - 2020-04-27 08:14:39.977
  /// - 2020-04-27T08:14:39.977
  /// - 2020-04-27 01:14:39.977Z
  /// - 2020-04-27 08:14:39
  /// - 2020-04-27T08:14:39
  /// - 2020-04-27 01:14:39Z
  static String dateTimeUTC =
      r'^\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}:\d{2}(.\d{3,})?[zZ]?$';

  /// Date Time regex
  /// Return [true] to utc & common formatted date time.
  ///
  /// Valid Formats:
  /// - All DateTime regex (UTC)
  /// - many combination of `YYYY-MM-DD HH:mm:ss`
  /// - HH:mm AM (or PM)
  /// - MMMM yyyy
  /// - MMM, d yyyy
  /// - etc.
  ///
  /// Examples:
  /// - 2018-01-04T05:52:34
  /// - 2018-01-04
  /// - 2018-01-04 05:52
  /// - 01/Oct/04 01:23
  /// - May 16, 2023
  /// - 07:00 PM
  /// - Wednesday, 21 May 2023
  /// - 01/25
  /// - 00:30:20
  /// - Wed, Jan 26
  /// - etc.
  static String dateTime =
      r'^([a-zA-Z]{3,},? ?)?([0-9]{1,4}|[a-zA-Z]{3,})[ -\/\.,:]([0-9]{1,4}|[a-zA-Z]{3,})([ -\/\.,:] ?\w+)?([ T]\d{2}:\d{2}(:\d{2})?(\.\d{3,})?[zZ]?)?([aApP]\.?[mM])?$';

  /// Binary regex
  /// Consist only 0 & 1
  static String binary = r'^[0-1]*$';

  /// MD5 regex
  static String md5 = r'^[a-f0-9]{32}$';

  /// CVV regex
  static String cvv = r'^\d{3}$';

  /// SHA1 regex
  static String sha1 =
      r'^(([A-Fa-f0-9]{2}\:){19}[A-Fa-f0-9]{2}|[A-Fa-f0-9]{40})$';

  /// SHA256 regex
  static String sha256 =
      r'^([A-Fa-f0-9]{2}\:){31}[A-Fa-f0-9]{2}|[A-Fa-f0-9]{64}$';

  /// SSN (Social Security Number) regex
  static String ssn =
      r'^(?!0{3}|6{3}|9[0-9]{2})[0-9]{3}-?(?!0{2})[0-9]{2}-?(?!0{4})[0-9]{4}$';

  /// IPv4 regex
  static String ipv4 = r'^(?:(?:^|\.)(?:2(?:5[0-5]|[0-4]\d)|1?\d?\d)){4}$';

  /// IPv6 regex
  static String ipv6 =
      r'^((([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}:[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){5}:([0-9A-Fa-f]{1,4}:)?[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){4}:([0-9A-Fa-f]{1,4}:){0,2}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){3}:([0-9A-Fa-f]{1,4}:){0,3}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){2}:([0-9A-Fa-f]{1,4}:){0,4}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|(([0-9A-Fa-f]{1,4}:){0,5}:((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|(::([0-9A-Fa-f]{1,4}:){0,5}((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|([0-9A-Fa-f]{1,4}::([0-9A-Fa-f]{1,4}:){0,5}[0-9A-Fa-f]{1,4})|(::([0-9A-Fa-f]{1,4}:){0,6}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){1,7}:))$';

  /// ISBN 10 & 13 regex
  static String isbn =
      r'^(ISBN(\-1[03])?[:]?[ ]?)?(([0-9Xx][- ]?){13}|([0-9Xx][- ]?){10})$';

  /// Github repository regex
  static String github =
      r'^((git|ssh|http(s)?)|(git@[\w\.]+))(:(\/\/)?)([\w\.@\:/\-~]+)(\.git)(\/)?$';

  /// Passport No. regex
  static String passport = r'^(?!^0+$)[a-zA-Z0-9]{6,9}$';

  /// Currency regex
  static String currency =
      r'^(S?\$|\₩|Rp|\¥|\€|\₹|\₽|fr|R$|R)?[ ]?[-]?([0-9]{1,3}[,.]([0-9]{3}[,.])*[0-9]{3}|[0-9]+)([,.][0-9]{1,2})?( ?(USD?|AUD|NZD|CAD|CHF|GBP|CNY|EUR|JPY|IDR|MXN|NOK|KRW|TRY|INR|RUB|BRL|ZAR|SGD|MYR))?$';

  /// Numeric Only regex
  static String numericOnly = r'^\d+$';

  /// Alphabet Only regex
  static String alphabetOnly = r'^[a-zA-Z]+$';

  /// Alphabet & Numeric Only regex
  static String alphaNumericOnly = r'^[a-zA-Z0-9]+$';

  /// Alphabet, Numeric, Symbol Only regex
  static String alphaNumericSymbolOnly =
      r'''^[a-zA-Z0-9!@#$%^&*()-_+=~{}:";',./|\\\[\]<>?]+$''';

  /// No Whitespace regex
  /// Contains: Alphabet, Numeric, & Symbol
  static String noWhitespace = r"^\S*$";

  /// Password (Easy) Regex
  ///
  /// No whitespace allowed
  /// Minimum characters: 8
  static String passwordEasy = r'^\S{8,}$';

  /// Password (Easy) Regex
  ///
  /// Minimum characters: 8
  static String passwordEasyWhitespace = r'^[\S ]{8,}$';

  /// Password (Normal) Regex
  ///
  /// No whitespace allowed
  /// Must contains at least: 1 letter & 1 number
  /// Minimum characters: 8
  static String passwordNormal1 = r'^(?=.*[A-Za-z])(?=.*\d)\S{8,}$';

  /// Password (Normal) Regex
  ///
  /// Must contains at least: 1 letter & 1 number
  /// Minimum characters: 8
  static String passwordNormal1Whitespace =
      r'^(?=.*[A-Za-z])(?=.*\d)[\S ]{8,}$';

  /// Password (Normal) Regex
  ///
  /// No symbolic characters allowed
  /// Must contains at least: 1 letter & 1 number
  /// Minimum characters: 8
  static String passwordNormal2 = r'^(?=.*[A-Za-z])(?=.*\d)[a-zA-Z0-9]{8,}$';

  /// Password (Normal) Regex
  ///
  /// No symbolic characters allowed
  /// Must contains: 1 letter & 1 number
  /// Minimum characters: 8
  static String passwordNormal2Whitespace =
      r'^(?=.*[A-Za-z])(?=.*\d)[a-zA-Z0-9 ]{8,}$';

  /// Password (Normal) Regex
  ///
  /// No whitespace allowed
  /// Must contains at least: 1 uppercase letter, 1 lowecase letter & 1 number
  /// Minimum characters: 8
  static String passwordNormal3 = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)\S{8,}$';

  /// Password (Normal) Regex
  ///
  /// Must contains at least: 1 uppercase letter, 1 lowecase letter & 1 number
  /// Minimum characters: 8
  static String passwordNormal3Whitespace =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[\S ]{8,}$';

  /// Password (Hard) Regex
  ///
  /// No whitespace allowed
  /// Must contains at least: 1 uppercase letter, 1 lowecase letter, 1 number, & 1 special character (symbol)
  /// Minimum characters: 8
  static String passwordHard =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])\S{8,}$';

  /// Password (Hard) Regex
  ///
  /// Must contains at least: 1 uppercase letter, 1 lowecase letter, 1 number, & 1 special character (symbol)
  /// Minimum characters: 8
  static String passwordHardWhitespace =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])[\S ]{8,}$';

  /// UUID
  static String uuid =
      r'^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$';

  /// Bitcoin Address
  ///
  /// Consist of 26-35 (42 on bc1) alphanumeric characters.
  /// Starts with 1, 3, or bc1.
  /// It contains digits in the range of 0 to 9.
  /// The uppercase letter O and the uppercase letter I are not used to avoid visual ambiguity.
  ///
  /// References:
  /// https://bitcoin.design/guide/glossary/address/
  /// https://ihateregex.io/expr/bitcoin-address/
  /// https://www.geeksforgeeks.org/regular-expression-to-validate-a-bitcoin-address/
  /// https://en.bitcoin.it/wiki/Invoice_address
  static String bitcoinAddress =
      r'^(?![13].{34,})(bc1|[13])[a-km-zA-HJ-NP-Z0-9]{25,39}$';

  /// Bitcoin (Taproot) Address
  ///
  /// Pay-to-Taproot (P2TR)
  /// Invoice address format: Bech32m
  /// 62 aplhanumeric characters, case insensitive
  /// Starts with bc1p.
  ///
  /// References:
  /// https://bitcoin.design/guide/glossary/address/
  /// https://blog.trezor.io/bitcoin-addresses-and-how-to-use-them-35e7312098ff
  static String bitcoinTaprootAddress = r'^(bc1p)[a-zA-Z0-9]{58}$';

  /// Bitcoin (Segwit) Address
  ///
  /// Pay-to-Witness-Public-Key-hash (P2WPKH)
  /// Invoice address format: Bech32m
  /// 42 aplhanumeric characters, case insensitive
  /// Starts with bc1q.
  ///
  /// References:
  /// https://bitcoin.design/guide/glossary/address/
  /// https://blog.trezor.io/bitcoin-addresses-and-how-to-use-them-35e7312098ff
  static String bitcoinSegwitAddress = r'^(bc1q)[a-zA-Z0-9]{38}$';

  /// Ethereum Address
  static String ethereumAddress = r'^0x[a-fA-F0-9]{40}$';

  /// Detect language of String
  static String persian = r'^[\u0600-\u06FF]+';
  static String english = r'^[a-zA-Z]+';
  static String arabic = r'^[\u0621-\u064A]+';
  static String chinese = r'^[\u4E00-\u9FFF]+';
  static String japanese = r'^[\u3040-\u30FF]+';
  static String korean = r'^[\uAC00-\uD7AF]+';
  static String ukrainian = r'^[\u0400-\u04FF\u0500-\u052F]+';
  static String russian = r'^[\u0400-\u04FF]+';
  static String italian = r'^[\u00C0-\u017F]+';
  static String french = r'^[\u00C0-\u017F]+';
  static String spanish =
      r'[\u00C0-\u024F\u1E00-\u1EFF\u2C60-\u2C7F\uA720-\uA7FF\u1D00-\u1D7F]+';
}
