public class InvocableStringWizard {
  public class Request {
    @InvocableVariable(label='Method' required=true)
    public String method;
    @InvocableVariable(label='Main String')
    public String mainString;
    @InvocableVariable(label='Integer01')
    public Integer integer01;
    @InvocableVariable(label='Integer02')
    public Integer integer02;
    @InvocableVariable(label='String01')
    public String string01;
    @InvocableVariable(label='String02')
    public String string02;
    @InvocableVariable(label='Integer List')
    public List<Integer> integerList;
    @InvocableVariable(label='String List')
    public List<String> stringList;
  }

  public class Response {
    @InvocableVariable(label='String Result')
    public String stringResult;
    @InvocableVariable(label='Integer Result')
    public Integer integerResult;
    @InvocableVariable(label='Boolean Result')
    public Boolean booleanResult;
    @InvocableVariable(label='Integer List Result')
    public List<Integer> integerListResult;
    @InvocableVariable(label='String List Result')
    public List<String> stringListResult;
  }

  @InvocableMethod(
    label='String Wizard'
    configurationEditor='c-invocable-string-wizard-editor'
  )
  public static List<Response> Invoke(List<Request> requests) {
    List<Response> responseList = new List<Response>();
    for (Request curRequest : requests) {
      Response response = new Response();
      if (curRequest.method == 'abbreviate') {
        response.stringResult = abbreviate(
          curRequest.mainString,
          curRequest.integer01,
          curRequest.integer02
        );
      } else if (curRequest.method == 'capitalize') {
        response.stringResult = capitalize(curRequest.mainString);
      } else if (curRequest.method == 'center') {
        response.stringResult = center(
          curRequest.mainString,
          curRequest.integer01,
          curRequest.string01
        );
      } else if (curRequest.method == 'charAt') {
        response.integerResult = charAt(
          curRequest.mainString,
          curRequest.integer01
        );
      } else if (curRequest.method == 'codePointAt') {
        response.integerResult = codePointAt(
          curRequest.mainString,
          curRequest.integer01
        );
      } else if (curRequest.method == 'codePointBefore') {
        response.integerResult = codePointBefore(
          curRequest.mainString,
          curRequest.integer01
        );
      } else if (curRequest.method == 'codePointCount') {
        response.integerResult = codePointCount(
          curRequest.mainString,
          curRequest.integer01,
          curRequest.integer02
        );
      } else if (curRequest.method == 'compareTo') {
        response.integerResult = compareTo(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'contains') {
        response.booleanResult = contains(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'containsAny') {
        response.booleanResult = containsAny(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'containsIgnoreCase') {
        response.booleanResult = containsIgnoreCase(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'containsNone') {
        response.booleanResult = containsNone(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'containsOnly') {
        response.booleanResult = containsOnly(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'containsWhitespace') {
        response.booleanResult = containsWhitespace(curRequest.mainString);
      } else if (curRequest.method == 'countMatches') {
        response.integerResult = countMatches(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'deleteWhitespace') {
        response.stringResult = deleteWhitespace(curRequest.mainString);
      } else if (curRequest.method == 'difference') {
        response.stringResult = difference(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'endsWith') {
        response.booleanResult = endsWith(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'endsWithIgnoreCase') {
        response.booleanResult = endsWithIgnoreCase(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'equals') {
        response.booleanResult = equals(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'equalsIgnoreCase') {
        response.booleanResult = equalsIgnoreCase(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'escapeCsv') {
        response.stringResult = escapeCsv(curRequest.mainString);
      } else if (curRequest.method == 'escapeEcmaScript') {
        response.stringResult = escapeEcmaScript(curRequest.mainString);
      } else if (curRequest.method == 'escapeHtml3') {
        response.stringResult = escapeHtml3(curRequest.mainString);
      } else if (curRequest.method == 'escapeHtml4') {
        response.stringResult = escapeHtml4(curRequest.mainString);
      } else if (curRequest.method == 'escapeJava') {
        response.stringResult = escapeJava(curRequest.mainString);
      } else if (curRequest.method == 'escapeSingleQuotes') {
        response.stringResult = escapeSingleQuotes(curRequest.mainString);
      } else if (curRequest.method == 'escapeUnicode') {
        response.stringResult = escapeUnicode(curRequest.mainString);
      } else if (curRequest.method == 'escapeXml') {
        response.stringResult = escapeXml(curRequest.mainString);
      } else if (curRequest.method == 'fromCharArray') {
        response.stringResult = fromCharArray(curRequest.integerList);
      } else if (curRequest.method == 'getChars') {
        response.integerListResult = getChars(curRequest.mainString);
      } else if (curRequest.method == 'getCommonPrefix') {
        response.stringResult = getCommonPrefix(curRequest.stringList);
      } else if (curRequest.method == 'getLevenshteinDistance') {
        response.integerResult = getLevenshteinDistance(
          curRequest.mainString,
          curRequest.string01,
          curRequest.integer01
        );
      } else if (curRequest.method == 'hashCode') {
        response.integerResult = hashCode(curRequest.mainString);
      } else if (curRequest.method == 'indexOf') {
        response.integerResult = indexOf(
          curRequest.mainString,
          curRequest.string01,
          curRequest.integer01
        );
      } else if (curRequest.method == 'indexOfAny') {
        response.integerResult = indexOfAny(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'indexOfAnyBut') {
        response.integerResult = indexOfAnyBut(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'indexOfChar') {
        response.integerResult = indexOfChar(
          curRequest.mainString,
          curRequest.integer01,
          curRequest.integer02
        );
      } else if (curRequest.method == 'indexOfDifference') {
        response.integerResult = indexOfDifference(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'indexOfIgnoreCase') {
        response.integerResult = indexOfIgnoreCase(
          curRequest.mainString,
          curRequest.string01,
          curRequest.integer01
        );
      } else if (curRequest.method == 'isAllLowerCase') {
        response.booleanResult = isAllLowerCase(curRequest.mainString);
      } else if (curRequest.method == 'isAllUpperCase') {
        response.booleanResult = isAllUpperCase(curRequest.mainString);
      } else if (curRequest.method == 'isAlpha') {
        response.booleanResult = isAlpha(curRequest.mainString);
      } else if (curRequest.method == 'isAlphaSpace') {
        response.booleanResult = isAlphaSpace(curRequest.mainString);
      } else if (curRequest.method == 'isAlphanumeric') {
        response.booleanResult = isAlphanumeric(curRequest.mainString);
      } else if (curRequest.method == 'isAlphanumericSpace') {
        response.booleanResult = isAlphanumericSpace(curRequest.mainString);
      } else if (curRequest.method == 'isAsciiPrintable') {
        response.booleanResult = isAsciiPrintable(curRequest.mainString);
      } else if (curRequest.method == 'isBlank') {
        response.booleanResult = isBlank(curRequest.mainString);
      } else if (curRequest.method == 'isEmpty') {
        response.booleanResult = isEmpty(curRequest.mainString);
      } else if (curRequest.method == 'isNotBlank') {
        response.booleanResult = isNotBlank(curRequest.mainString);
      } else if (curRequest.method == 'isNotEmpty') {
        response.booleanResult = isNotEmpty(curRequest.mainString);
      } else if (curRequest.method == 'isNumeric') {
        response.booleanResult = isNumeric(curRequest.mainString);
      } else if (curRequest.method == 'isNumericSpace') {
        response.booleanResult = isNumericSpace(curRequest.mainString);
      } else if (curRequest.method == 'isWhitespace') {
        response.booleanResult = isWhitespace(curRequest.mainString);
      } else if (curRequest.method == 'join') {
        response.stringResult = join(
          curRequest.stringList,
          curRequest.mainString
        );
      } else if (curRequest.method == 'lastIndexOf') {
        response.integerResult = lastIndexOf(
          curRequest.mainString,
          curRequest.string01,
          curRequest.integer01
        );
      } else if (curRequest.method == 'lastIndexOfChar') {
        response.integerResult = lastIndexOfChar(
          curRequest.mainString,
          curRequest.integer01,
          curRequest.integer02
        );
      } else if (curRequest.method == 'lastIndexOfIgnoreCase') {
        response.integerResult = lastIndexOfIgnoreCase(
          curRequest.mainString,
          curRequest.string01,
          curRequest.integer01
        );
      } else if (curRequest.method == 'left') {
        response.stringResult = left(
          curRequest.mainString,
          curRequest.integer01
        );
      } else if (curRequest.method == 'leftPad') {
        response.stringResult = leftPad(
          curRequest.mainString,
          curRequest.integer01,
          curRequest.string01
        );
      } else if (curRequest.method == 'length') {
        response.integerResult = length(curRequest.mainString);
      } else if (curRequest.method == 'mid') {
        response.stringResult = mid(
          curRequest.mainString,
          curRequest.integer01,
          curRequest.integer02
        );
      } else if (curRequest.method == 'normalizeSpace') {
        response.stringResult = normalizeSpace(curRequest.mainString);
      } else if (curRequest.method == 'offsetByCodePoints') {
        response.integerResult = offsetByCodePoints(
          curRequest.mainString,
          curRequest.integer01,
          curRequest.integer02
        );
      } else if (curRequest.method == 'remove') {
        response.stringResult = remove(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'removeEnd') {
        response.stringResult = removeEnd(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'removeEndIgnoreCase') {
        response.stringResult = removeEndIgnoreCase(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'removeStart') {
        response.stringResult = removeStart(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'removeStartIgnoreCase') {
        response.stringResult = removeStartIgnoreCase(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'repeat') {
        response.stringResult = repeat(
          curRequest.mainString,
          curRequest.string01,
          curRequest.integer01
        );
      } else if (curRequest.method == 'replace') {
        response.stringResult = replace(
          curRequest.mainString,
          curRequest.string01,
          curRequest.string02
        );
      } else if (curRequest.method == 'replaceAll') {
        response.stringResult = replaceAll(
          curRequest.mainString,
          curRequest.string01,
          curRequest.string02
        );
      } else if (curRequest.method == 'replaceFirst') {
        response.stringResult = replaceFirst(
          curRequest.mainString,
          curRequest.string01,
          curRequest.string02
        );
      } else if (curRequest.method == 'reverse') {
        response.stringResult = reverse(curRequest.mainString);
      } else if (curRequest.method == 'right') {
        response.stringResult = right(
          curRequest.mainString,
          curRequest.integer01
        );
      } else if (curRequest.method == 'rightPad') {
        response.stringResult = rightPad(
          curRequest.mainString,
          curRequest.integer01,
          curRequest.string01
        );
      } else if (curRequest.method == 'split') {
        response.stringListResult = split(
          curRequest.mainString,
          curRequest.string01,
          curRequest.integer01
        );
      } else if (curRequest.method == 'splitByCharacterType') {
        response.stringListResult = splitByCharacterType(curRequest.mainString);
      } else if (curRequest.method == 'splitByCharacterTypeCamelCase') {
        response.stringListResult = splitByCharacterTypeCamelCase(
          curRequest.mainString
        );
      } else if (curRequest.method == 'startsWith') {
        response.booleanResult = startsWith(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'startsWithIgnoreCase') {
        response.booleanResult = startsWithIgnoreCase(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'stripHtmlTags') {
        response.stringResult = stripHtmlTags(curRequest.mainString);
      } else if (curRequest.method == 'substring') {
        response.stringResult = substring(
          curRequest.mainString,
          curRequest.integer01,
          curRequest.integer02
        );
      } else if (curRequest.method == 'substringAfter') {
        response.stringResult = substringAfter(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'substringAfterLast') {
        response.stringResult = substringAfterLast(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'substringBefore') {
        response.stringResult = substringBefore(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'substringBeforeLast') {
        response.stringResult = substringBeforeLast(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'substringBetween') {
        response.stringResult = substringBetween(
          curRequest.mainString,
          curRequest.string01,
          curRequest.string02
        );
      } else if (curRequest.method == 'swapCase') {
        response.stringResult = swapCase(curRequest.mainString);
      } else if (curRequest.method == 'toLowerCase') {
        response.stringResult = toLowerCase(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'toUpperCase') {
        response.stringResult = toUpperCase(
          curRequest.mainString,
          curRequest.string01
        );
      } else if (curRequest.method == 'trim') {
        response.stringResult = trim(curRequest.mainString);
      } else if (curRequest.method == 'uncapitalize') {
        response.stringResult = uncapitalize(curRequest.mainString);
      } else if (curRequest.method == 'unescapeCsv') {
        response.stringResult = unescapeCsv(curRequest.mainString);
      } else if (curRequest.method == 'unescapeEcmaScript') {
        response.stringResult = unescapeEcmaScript(curRequest.mainString);
      } else if (curRequest.method == 'unescapeHtml3') {
        response.stringResult = unescapeHtml3(curRequest.mainString);
      } else if (curRequest.method == 'unescapeHtml4') {
        response.stringResult = unescapeHtml4(curRequest.mainString);
      } else if (curRequest.method == 'unescapeJava') {
        response.stringResult = unescapeJava(curRequest.mainString);
      } else if (curRequest.method == 'unescapeUnicode') {
        response.stringResult = unescapeUnicode(curRequest.mainString);
      } else if (curRequest.method == 'unescapeXml') {
        response.stringResult = unescapeXml(curRequest.mainString);
      }
      responseList.add(response);
    }
    return responseList;
  }

  private static String abbreviate(
    String mainString,
    Integer maxWidth,
    Integer offset
  ) {
    String result;
    if (offset != null) {
      result = mainString.abbreviate(maxWidth, offset);
    } else if (offset == null) {
      result = mainString.abbreviate(maxWidth);
    }
    return result;
  }
  private static String capitalize(String mainString) {
    return mainString.capitalize();
  }
  private static String center(
    String mainString,
    Integer size,
    String paddingString
  ) {
    String result;
    if (paddingString != null) {
      result = mainString.center(size, paddingString);
    } else if (paddingString == null) {
      result = mainString.center(size);
    }
    return result;
  }
  private static Integer charAt(String mainString, Integer index) {
    return mainString.charAt(index);
  }
  private static Integer codePointAt(String mainString, Integer index) {
    return mainString.codePointAt(index);
  }
  private static Integer codePointBefore(String mainString, Integer index) {
    return mainString.codePointBefore(index);
  }
  private static Integer codePointCount(
    String mainString,
    Integer beginIndex,
    Integer endIndex
  ) {
    return mainString.codePointCount(beginIndex, endIndex);
  }
  private static Integer compareTo(String mainString, String substring) {
    return mainString.compareTo(substring);
  }
  private static Boolean contains(String mainString, String substring) {
    return mainString.contains(substring);
  }
  private static Boolean containsAny(String mainString, String inputString) {
    return mainString.containsAny(inputString);
  }
  private static Boolean containsIgnoreCase(
    String mainString,
    String substring
  ) {
    return mainString.containsIgnoreCase(substring);
  }
  private static Boolean containsNone(String mainString, String inputString) {
    return mainString.containsNone(inputString);
  }
  private static Boolean containsOnly(String mainString, String inputString) {
    return mainString.containsOnly(inputString);
  }
  private static Boolean containsWhitespace(String mainString) {
    return mainString.containsWhitespace();
  }
  private static Integer countMatches(String mainString, String substring) {
    return mainString.countMatches(substring);
  }
  private static String deleteWhitespace(String mainString) {
    return mainString.deleteWhitespace();
  }
  private static String difference(String mainString, String secondString) {
    return mainString.difference(secondString);
  }
  private static Boolean endsWith(String mainString, String suffix) {
    return mainString.endsWith(suffix);
  }
  private static Boolean endsWithIgnoreCase(String mainString, String suffix) {
    return mainString.endsWithIgnoreCase(suffix);
  }
  private static Boolean equals(String mainString, String secondString) {
    return mainString.equals(secondString);
  }
  private static Boolean equalsIgnoreCase(
    String mainString,
    String secondString
  ) {
    return mainString.equalsIgnoreCase(secondString);
  }
  private static String escapeCsv(String mainString) {
    return mainString.escapeCsv();
  }
  private static String escapeEcmaScript(String mainString) {
    return mainString.escapeEcmaScript();
  }
  private static String escapeHtml3(String mainString) {
    return mainString.escapeHtml3();
  }
  private static String escapeHtml4(String mainString) {
    return mainString.escapeHtml4();
  }
  private static String escapeJava(String mainString) {
    return mainString.escapeJava();
  }
  private static String escapeSingleQuotes(String mainString) {
    return String.escapeSingleQuotes(mainString);
  }
  private static String escapeUnicode(String mainString) {
    return mainString.escapeUnicode();
  }
  private static String escapeXml(String mainString) {
    return mainString.escapeXml();
  }
  private static String fromCharArray(List<Integer> charArray) {
    return String.fromCharArray(charArray);
  }
  private static List<Integer> getChars(String mainString) {
    return mainString.getChars();
  }
  private static String getCommonPrefix(List<String> strings) {
    return String.getCommonPrefix(strings);
  }
  private static Integer getLevenshteinDistance(
    String mainString,
    String stringToCompare,
    Integer threshold
  ) {
    Integer result;
    if (threshold != null) {
      result = mainString.getLevenshteinDistance(stringToCompare, threshold);
    } else if (threshold == null) {
      result = mainString.getLevenshteinDistance(stringToCompare);
    }
    return result;
  }
  private static Integer hashCode(String mainString) {
    return mainString.hashCode();
  }
  private static Integer indexOf(
    String mainString,
    String substring,
    Integer index
  ) {
    Integer result;
    if (index != null) {
      result = mainString.indexOf(substring, index);
    } else if (index == null) {
      result = mainString.indexOf(substring);
    }
    return result;
  }
  private static Integer indexOfAny(String mainString, String substring) {
    return mainString.indexOfAny(substring);
  }
  private static Integer indexOfAnyBut(String mainString, String substring) {
    return mainString.indexOfAnyBut(substring);
  }
  private static Integer indexOfChar(
    String mainString,
    Integer character,
    Integer startIndex
  ) {
    Integer result;
    if (startIndex != null) {
      result = mainString.indexOfChar(character, startIndex);
    } else if (startIndex == null) {
      result = mainString.indexOfChar(character);
    }
    return result;
  }
  private static Integer indexOfDifference(
    String mainString,
    String stringToCompare
  ) {
    return mainString.indexOfDifference(stringToCompare);
  }
  private static Integer indexOfIgnoreCase(
    String mainString,
    String substring,
    Integer startPosition
  ) {
    Integer result;
    if (startPosition != null) {
      result = mainString.indexOfIgnoreCase(substring, startPosition);
    } else if (startPosition == null) {
      result = mainString.indexOfIgnoreCase(substring);
    }
    return result;
  }
  private static Boolean isAllLowerCase(String mainString) {
    return mainString.isAllLowerCase();
  }
  private static Boolean isAllUpperCase(String mainString) {
    return mainString.isAllUpperCase();
  }
  private static Boolean isAlpha(String mainString) {
    return mainString.isAlpha();
  }
  private static Boolean isAlphaSpace(String mainString) {
    return mainString.isAlphaSpace();
  }
  private static Boolean isAlphanumeric(String mainString) {
    return mainString.isAlphanumeric();
  }
  private static Boolean isAlphanumericSpace(String mainString) {
    return mainString.isAlphanumericSpace();
  }
  private static Boolean isAsciiPrintable(String mainString) {
    return mainString.isAsciiPrintable();
  }
  private static Boolean isBlank(String mainString) {
    return String.isBlank(mainString);
  }
  private static Boolean isEmpty(String mainString) {
    return String.isEmpty(mainString);
  }
  private static Boolean isNotBlank(String mainString) {
    return String.isNotBlank(mainString);
  }
  private static Boolean isNotEmpty(String mainString) {
    return String.isNotEmpty(mainString);
  }
  private static Boolean isNumeric(String mainString) {
    return mainString.isNumeric();
  }
  private static Boolean isNumericSpace(String mainString) {
    return mainString.isNumericSpace();
  }
  private static Boolean isWhiteSpace(String mainString) {
    return mainString.isWhiteSpace();
  }
  private static String join(List<String> listString, String separator) {
    return String.join(listString, separator);
  }
  private static Integer lastindexOf(
    String mainString,
    String substring,
    Integer endPosition
  ) {
    Integer result;
    if (endPosition != null) {
      result = mainString.lastIndexOf(substring, endPosition);
    } else if (endPosition == null) {
      result = mainString.lastIndexOf(substring);
    }
    return result;
  }
  private static Integer lastIndexOfChar(
    String mainString,
    Integer character,
    Integer endIndex
  ) {
    Integer result;
    if (endIndex != null) {
      result = mainString.lastIndexOfChar(character, endIndex);
    } else if (endIndex == null) {
      result = mainString.lastIndexOfChar(character);
    }
    return result;
  }
  private static Integer lastIndexOfIgnoreCase(
    String mainString,
    String substring,
    Integer endPosition
  ) {
    Integer result;
    if (endPosition != null) {
      result = mainString.lastIndexOfIgnoreCase(substring, endPosition);
    } else if (endPosition == null) {
      result = mainString.lastIndexOfIgnoreCase(substring);
    }
    return result;
  }
  private static String left(String mainString, Integer length) {
    return mainString.left(length);
  }
  private static String leftPad(
    String mainString,
    Integer length,
    String padStr
  ) {
    String result;
    if (padStr != null) {
      result = mainString.leftPad(length, padStr);
    } else if (padStr == null) {
      result = mainString.leftPad(length);
    }
    return result;
  }
  private static Integer length(String mainString) {
    return mainString.length();
  }
  private static String mid(
    String mainString,
    Integer startIndex,
    Integer length
  ) {
    return mainString.mid(startIndex, length);
  }
  private static String normalizeSpace(String mainString) {
    return mainString.normalizeSpace();
  }
  private static Integer offsetByCodePoints(
    String mainString,
    Integer index,
    Integer codePointOffset
  ) {
    return mainString.offsetByCodePoints(index, codePointOffset);
  }
  private static String remove(String mainString, String substring) {
    return mainString.remove(substring);
  }
  private static String removeEnd(String mainString, String substring) {
    return mainString.removeEnd(substring);
  }
  private static String removeEndIgnoreCase(
    String mainString,
    String substring
  ) {
    return mainString.removeEndIgnoreCase(substring);
  }
  private static String removeStart(String mainString, String substring) {
    return mainString.removeStart(substring);
  }
  private static String removeStartIgnoreCase(
    String mainString,
    String substring
  ) {
    return mainString.removeStartIgnoreCase(substring);
  }
  private static String repeat(
    String mainString,
    String separator,
    Integer numberOfTimes
  ) {
    String result;
    if (separator != null) {
      result = mainString.repeat(separator, numberOfTimes);
    } else if (separator == null) {
      result = mainString.repeat(numberOfTimes);
    }
    return result;
  }
  private static String replace(
    String mainString,
    String target,
    String replacement
  ) {
    return mainString.replace(target, replacement);
  }
  private static String replaceAll(
    String mainString,
    String regExp,
    String replacement
  ) {
    return mainString.replaceAll(regExp, replacement);
  }
  private static String replaceFirst(
    String mainString,
    String regExp,
    String replacement
  ) {
    return mainString.replaceFirst(regExp, replacement);
  }
  private static String reverse(String mainString) {
    return mainString.reverse();
  }
  private static String right(String mainString, Integer length) {
    return mainString.right(length);
  }
  private static String rightPad(
    String mainString,
    Integer length,
    String padStr
  ) {
    String result;
    if (padStr != null) {
      result = mainString.rightPad(length, padStr);
    } else if (padStr == null) {
      result = mainString.rightPad(length);
    }
    return result;
  }
  private static List<String> split(
    String mainString,
    String regExp,
    Integer limitInt
  ) {
    List<String> result = new List<String>();
    if (limitInt != null) {
      result = mainString.split(regExp, limitInt);
    } else if (limitInt == null) {
      result = mainString.split(regExp);
    }
    return result;
  }
  private static List<String> splitByCharacterType(String mainString) {
    return mainString.splitByCharacterType();
  }
  private static List<String> splitByCharacterTypeCamelCase(String mainString) {
    return mainString.splitByCharacterTypeCamelCase();
  }
  private static Boolean startsWith(String mainString, String prefix) {
    return mainString.startsWith(prefix);
  }
  private static Boolean startsWithIgnoreCase(
    String mainString,
    String prefix
  ) {
    return mainString.startsWithIgnoreCase(prefix);
  }
  private static String stripHtmlTags(String mainString) {
    return mainString.stripHtmlTags();
  }
  private static String substring(
    String mainString,
    Integer startIndex,
    Integer endIndex
  ) {
    String result;
    if (endIndex != null) {
      result = mainString.substring(startIndex, endIndex);
    } else if (endIndex == null) {
      result = mainString.substring(startIndex);
    }
    return result;
  }
  private static String substringAfter(String mainString, String separator) {
    return mainString.substringAfter(separator);
  }
  private static String substringAfterLast(
    String mainString,
    String separator
  ) {
    return mainString.substringAfterLast(separator);
  }
  private static String substringBefore(String mainString, String separator) {
    return mainString.substringBefore(separator);
  }
  private static String substringBeforeLast(
    String mainString,
    String separator
  ) {
    return mainString.substringBeforeLast(separator);
  }
  private static String substringBetween(
    String mainString,
    String open,
    String close
  ) {
    String result;
    if (close != null) {
      result = mainString.substringBetween(open, close);
    } else if (close == null) {
      result = mainString.substringBetween(open);
    }
    return result;
  }
  private static String swapCase(String mainString) {
    return mainString.swapCase();
  }
  private static String toLowerCase(String mainString, String locale) {
    String result;
    if (locale != null) {
      result = mainString.toLowerCase(locale);
    } else if (locale == null) {
      result = mainString.toLowerCase();
    }
    return result;
  }
  private static String toUpperCase(String mainString, String locale) {
    String result;
    if (locale != null) {
      result = mainString.toUpperCase(locale);
    } else if (locale == null) {
      result = mainString.toUpperCase();
    }
    return result;
  }
  private static String trim(String mainString) {
    return mainString.trim();
  }
  private static String uncapitalize(String mainString) {
    return mainString.uncapitalize();
  }
  private static String unescapeCsv(String mainString) {
    return mainString.unescapeCsv();
  }
  private static String unescapeEcmaScript(String mainString) {
    return mainString.unescapeEcmaScript();
  }
  private static String unescapeHtml3(String mainString) {
    return mainString.unescapeHtml3();
  }
  private static String unescapeHtml4(String mainString) {
    return mainString.unescapeHtml4();
  }
  private static String unescapeJava(String mainString) {
    return mainString.unescapeJava();
  }
  private static String unescapeUnicode(String mainString) {
    return mainString.unescapeUnicode();
  }
  private static String unescapeXml(String mainString) {
    return mainString.unescapeXml();
  }
}
