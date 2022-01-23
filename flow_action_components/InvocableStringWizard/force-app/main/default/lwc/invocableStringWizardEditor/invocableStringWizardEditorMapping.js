export function fieldMapping() {
  return [
    {
      method: "abbreviate",
      description:
        "Returns an abbreviated version of the String, of the specified length and with ellipses appended if the current String is longer than the specified length; otherwise, returns the original String without ellipses.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to be abbreviated",
        helpText: "String Type"
      },
      integer01: {
        show: true,
        required: true,
        label: "Max Width",
        helpText: "Integer Type"
      },
      integer02: {
        show: true,
        required: false,
        label: "Offset",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "capitalize",
      description:
        "Returns the current String with the first letter changed to title case.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to be capitalized",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "center",
      description:
        "Returns a version of the current String of the specified size padded with spaces on the left and right, so that it appears in the center. If the specified size is smaller than the current String size, the entire String is returned without added spaces.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to be centered",
        helpText: "String Type"
      },
      integer01: {
        show: true,
        required: true,
        label: "Size",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: false,
        label: "Padding String",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "charAt",
      description:
        "Returns a version of the current String of the specified size padded with spaces on the left and right, so that it appears in the center. If the specified size is smaller than the current String size, the entire String is returned without added spaces.",
      output: "Integer",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: true,
        required: true,
        label: "Index",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "Padding String",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "codePointAt",
      description:
        "Returns the Unicode code point value at the specified index.",
      output: "Integer",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: true,
        required: true,
        label: "Index",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "codePointBefore",
      description:
        "Returns the Unicode code point value that occurs before the specified index.",
      output: "Integer",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: true,
        required: true,
        label: "Index",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "codePointCount",
      description:
        "Returns the number of Unicode code points within the specified text range.",
      output: "Integer",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: true,
        required: true,
        label: "Begin Index",
        helpText: "Integer Type"
      },
      integer02: {
        show: true,
        required: true,
        label: "End Index",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "compareTo",
      description:
        "Compares two strings lexicographically, based on the Unicode value of each character in the Strings.",
      output: "Integer",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Second string",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "contains",
      description:
        "Returns true if and only if the String that called the method contains the specified sequence of characters in substring.",
      output: "Boolean",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Substring",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "containsAny",
      description:
        "Returns true if the current String contains any of the characters in the specified String; otherwise, returns false.",
      output: "Boolean",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Input String",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "containsIgnoreCase",
      description:
        "Returns true if the current String contains the specified sequence of characters without regard to case; otherwise, returns false.",
      output: "Boolean",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Substring",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "containsNone",
      description:
        "Returns true if the current String doesn’t contain any of the characters in the specified String; otherwise, returns false.",
      output: "Boolean",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Input String",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "containsOnly",
      description:
        "Returns true if the current String contains characters only from the specified sequence of characters and not any other characters; otherwise, returns false.",
      output: "Boolean",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Input String",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "containsWhitespace",
      description:
        "Returns true if the current String contains any white space characters; otherwise, returns false.",
      output: "Boolean",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "countMatches",
      description:
        "Returns the number of times the specified substring occurs in the current String.",
      output: "Integer",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Substring",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "deleteWhitespace",
      description:
        "Returns a version of the current String with all white space characters removed.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "difference",
      description:
        "Returns the difference between the current String and the specified String.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Second String",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "endsWith",
      description:
        "Returns true if the String that called the method ends with the specified suffix.",
      output: "Boolean",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Suffix",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "endsWithIgnoreCase",
      description:
        "Returns true if the current String ends with the specified suffix; otherwise, returns false.",
      output: "Boolean",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Suffix",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "equals",
      description:
        "Deprecated. This method is replaced by equals(stringOrId). Returns true if the passed-in string is not null and represents the same binary sequence of characters as the current string. Use this method to perform case-sensitive comparisons.",
      output: "Boolean",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Second String",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "equalsIgnoreCase",
      description:
        "Returns true if the secondString is not null and represents the same sequence of characters as the String that called the method, ignoring case.",
      output: "Boolean",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Second String",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "escapeCsv",
      description:
        "Returns a String for a CSV column enclosed in double quotes, if required.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "escapeEcmaScript",
      description:
        "Escapes the characters in the String using EcmaScript String rules.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "escapeHtml3",
      description:
        "Escapes the characters in a String using HTML 3.0 entities.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "escapeHtml4",
      description:
        "Escapes the characters in a String using HTML 4.0 entities.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "escapeJava",
      description:
        "Returns a String whose characters are escaped using Java String rules. Characters escaped include quotes and control characters, such as tab, backslash, and carriage return characters.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "escapeSingleQuotes",
      description:
        "Returns a String with the escape character (\n) added before any single quotation marks in the String s.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to escape",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "escapeUnicode",
      description:
        "Returns a String whose Unicode characters are escaped to a Unicode escape sequence.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to escape",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "escapeXml",
      description: "Escapes the characters in a String using XML entities.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to escape",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "fromCharArray",
      description: "Returns a String from the values of the list of integers.",
      output: "String",
      mainString: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: true,
        required: true,
        label: "character List/Array",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "getChars",
      description:
        "Returns an array of character values that represent the characters in this string.",
      output: "Integer List",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "getCommonPrefix",
      description:
        "Returns the initial sequence of characters as a String that is common to all the specified Strings.",
      output: "String",
      mainString: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String List Type"
      }
    },
    {
      method: "getLevenshteinDistance",
      description:
        "Returns the Levenshtein distance between the current String and the specified String if it is less than or equal than the given threshold; otherwise, returns -1.",
      output: "Integer",
      mainString: {
        show: true,
        required: true,
        label: "First string",
        helpText: "String Type"
      },
      integer01: {
        show: true,
        required: false,
        label: "Threshold",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Second string",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "hashCode",
      description: "Returns a hash code value for this string.",
      output: "Integer",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "indexOf",
      description:
        "Returns the zero-based index of the first occurrence of the specified substring from the point of the given index. If the substring does not occur, this method returns -1.",
      output: "Integer",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: true,
        required: false,
        label: "Index",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Substring",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "indexOfAny",
      description:
        "Returns the zero-based index of the first occurrence of any character specified in the substring. If none of the characters occur, returns -1.",
      output: "Integer",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Substring",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "indexOfAnyBut",
      description:
        "Returns the zero-based index of the first occurrence of a character that is not in the specified substring. Otherwise, returns -1.",
      output: "Integer",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Substring",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "indexOfChar",
      description:
        "Returns the index of the first occurrence of the character that corresponds to the specified character value, starting from the specified index.",
      output: "Integer",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: true,
        required: true,
        label: "Character",
        helpText: "Integer Type"
      },
      integer02: {
        show: true,
        required: false,
        label: "Start index",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "indexOfDifference",
      description:
        "Returns the zero-based index of the character where the current String begins to differ from the specified String.",
      output: "Integer",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Substring",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "indexOfIgnoreCase",
      description:
        "Returns the zero-based index of the first occurrence of the specified substring from the point of index i, without regard to case. If the substring does not occur, this method returns -1.",
      output: "Integer",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: true,
        required: false,
        label: "Start position",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Substring",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "isAllLowerCase",
      description:
        "Returns true if all characters in the current String are lowercase; otherwise, returns false.",
      output: "Boolean",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "isAllUpperCase",
      description:
        "Returns true if all characters in the current String are uppercase; otherwise, returns false.",
      output: "Boolean",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "isAlpha",
      description:
        "Returns true if all characters in the current String are Unicode letters only; otherwise, returns false.",
      output: "Boolean",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "isAlphaSpace",
      description:
        "Returns true if all characters in the current String are Unicode letters or spaces only; otherwise, returns false.",
      output: "Boolean",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "isAlphanumeric",
      description:
        "Returns true if all characters in the current String are Unicode letters or numbers only; otherwise, returns false.",
      output: "Boolean",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "isAlphanumericSpace",
      description:
        "Returns true if all characters in the current String are Unicode letters, numbers, or spaces only; otherwise, returns false.",
      output: "Boolean",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "isAsciiPrintable",
      description:
        "Returns true if the current String contains only ASCII printable characters; otherwise, returns false.",
      output: "Boolean",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "isBlank",
      description:
        "Returns true if the specified String is white space, empty (''), or null; otherwise, returns false.",
      output: "Boolean",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "isEmpty",
      description:
        "Returns true if the specified String is empty ('') or null; otherwise, returns false.",
      output: "Boolean",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "isNotBlank",
      description:
        "Returns true if the specified String is not whitespace, not empty (''), and not null; otherwise, returns false.",
      output: "Boolean",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "isNotEmpty",
      description:
        "Returns true if the specified String is not empty ('') and not null; otherwise, returns false.",
      output: "Boolean",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "isNumeric",
      description:
        "Returns true if the current String contains only Unicode digits; otherwise, returns false.",
      output: "Boolean",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "isNumericSpace",
      description:
        "Returns true if the current String contains only Unicode digits or spaces; otherwise, returns false.",
      output: "Boolean",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "isWhiteSpace",
      description:
        "Returns true if the current String contains only white space characters or is empty; otherwise, returns false.",
      output: "Boolean",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "join",
      description:
        "Joins the elements of the List String, into a single String separated by the specified separator.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "Separator",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: true,
        required: true,
        label: "List string to join",
        helpText: "String List Type"
      }
    },
    {
      method: "lastindexOf",
      description:
        "Returns the index of the last occurrence of the specified substring, starting from the character at index 0 and ending at the specified index.",
      output: "Integer",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: true,
        required: false,
        label: "End position",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Substring",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "lastIndexOfChar",
      description:
        "Returns the index of the last occurrence of the character that corresponds to the specified character value, starting from the specified index.",
      output: "Integer",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: true,
        required: true,
        label: "Character",
        helpText: "Integer Type"
      },
      integer02: {
        show: true,
        required: false,
        label: "End Index",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "lastIndexOfIgnoreCase",
      description:
        "Returns the index of the last occurrence of the specified substring regardless of case, starting from the character at index 0 and ending at the specified index.",
      output: "Integer",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: true,
        required: false,
        label: "End position",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Substring",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "left",
      description:
        "Returns the leftmost characters of the current String of the specified length.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: true,
        required: true,
        label: "Length",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "leftPad",
      description:
        "Returns the current String padded with String padStr on the left and of the specified length.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: true,
        required: true,
        label: "Length",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: false,
        label: "Pad string",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "length",
      description:
        "Returns the number of 16-bit Unicode characters contained in the String.",
      output: "Integer",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "mid",
      description:
        "Returns a new String that begins with the character at the specified zero-based startIndex with the number of characters specified by length.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: true,
        required: true,
        label: "Start index",
        helpText: "Integer Type"
      },
      integer02: {
        show: true,
        required: true,
        label: "Length",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "normalizeSpace",
      description:
        "Returns the current String with leading, trailing, and repeating white space characters removed.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "offsetByCodePoints",
      description:
        "Returns the index of the Unicode code point that is offset by the specified number of code points, starting from the given index.",
      output: "Integer",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: true,
        required: true,
        label: "Index",
        helpText: "Integer Type"
      },
      integer02: {
        show: true,
        required: true,
        label: "Code point offset",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "remove",
      description:
        "Removes all occurrences of the specified substring and returns the String result.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Substring",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "removeEnd",
      description:
        "Removes the specified substring only if it occurs at the end of the String.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Substring",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "removeEndIgnoreCase",
      description:
        "Removes the specified substring only if it occurs at the end of the String using a case-insensitive match.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Substring",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "removeStart",
      description:
        "Removes the specified substring only if it occurs at the beginning of the String.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Substring",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "removeStartIgnoreCase",
      description:
        "Removes the specified substring only if it occurs at the beginning of the String using a case-insensitive match.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Substring",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "repeat",
      description:
        "Returns the current String repeated the specified number of times using the specified separator to separate the repeated Strings.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to repeat",
        helpText: "String Type"
      },
      integer01: {
        show: true,
        required: true,
        label: "Number of times",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: false,
        label: "Separator",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "replace",
      description:
        "Replaces each substring of a string that matches the literal target sequence target with the specified literal replacement sequence replacement.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Target",
        helpText: "String Type"
      },
      string02: {
        show: true,
        required: true,
        label: "Replacement",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "replaceAll",
      description:
        "Replaces each substring of a string that matches the regular expression regExp with the replacement sequence replacement.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Regex exp",
        helpText: "String Type"
      },
      string02: {
        show: true,
        required: true,
        label: "Replacement",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "replaceFirst",
      description:
        "Replaces the first substring of a string that matches the regular expression regExp with the replacement sequence replacement.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Regex Exp",
        helpText: "String Type"
      },
      string02: {
        show: true,
        required: true,
        label: "Replacement",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "reverse",
      description: "Returns a String with all the characters reversed.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "right",
      description:
        "Returns the rightmost characters of the current String of the specified length.",
      output: "Stromg",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: true,
        required: true,
        label: "Length",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "rightPad",
      description:
        "Returns the current String padded with String padStr on the right and of the specified length.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: true,
        required: true,
        label: "Length",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: false,
        label: "Pad string",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "split",
      description:
        "Returns a list that contains each substring of the String that is terminated by either the regular expression regExp or the end of the String.",
      output: "String List",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: true,
        required: false,
        label: "Limit",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Regex Exp",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "splitByCharacterType",
      description:
        "Splits the current String by character type and returns a list of contiguous character groups of the same type as complete tokens.",
      output: "String List",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "splitByCharacterTypeCamelCase",
      description:
        "Splits the current String by character type and returns a list of contiguous character groups of the same type as complete tokens, with the following exception: the uppercase character, if any, immediately preceding a lowercase character token belongs to the following character token rather than to the preceding.",
      output: "String List",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "startsWith",
      description:
        "Returns true if the String that called the method begins with the specified prefix.",
      output: "Boolean",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Prefix",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "startsWithIgnoreCase",
      description:
        "Returns true if the current String begins with the specified prefix regardless of the prefix case.",
      output: "Boolean",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Prefix",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "stripHtmlTags",
      description: "Removes HTML markup and returns plain text.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "substring",
      description:
        "Returns a new String that begins with the character at the specified zero-based startIndex and extends to the character at endIndex - 1.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: true,
        required: true,
        label: "Start index",
        helpText: "Integer Type"
      },
      integer02: {
        show: true,
        required: false,
        label: "End Index",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "substringAfter",
      description:
        "Returns the substring that occurs after the first occurrence of the specified separator.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Separator",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "substringAfterLast",
      description:
        "Returns the substring that occurs after the last occurrence of the specified separator.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Separator",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "substringBefore",
      description:
        "Returns the substring that occurs before the first occurrence of the specified separator.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Separator",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "substringBeforeLast",
      description:
        "Returns the substring that occurs before the last occurrence of the specified separator.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Separator",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "substringBetween",
      description:
        "Returns the substring that occurs between the two specified Strings.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to check",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: true,
        label: "Open",
        helpText: "String Type"
      },
      string02: {
        show: true,
        required: false,
        label: "Close",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "swapCase",
      description:
        "Swaps the case of all characters and returns the resulting String by using the default (English US) locale.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "toLowerCase",
      description:
        "Converts all of the characters in the String to lowercase using the rules of the specified locale.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: false,
        label: "Locale",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "toUpperCase",
      description:
        "Converts all of the characters in the String to the uppercase using the rules of the specified locale.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: true,
        required: false,
        label: "Locale",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "trim",
      description:
        "Returns a copy of the string that no longer contains any leading or trailing white space characters.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "uncapitalize",
      description:
        "Returns the current String with the first letter in lowercase.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "unescapeCsv",
      description: "Returns a String representing an unescaped CSV column.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "unescapeEcmaScript",
      description: "Unescapes any EcmaScript literals found in the String.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "unescapeHtml3",
      description:
        "Unescapes the characters in a String using HTML 3.0 entities.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "unescapeHtml4",
      description:
        "Unescapes the characters in a String using HTML 4.0 entities.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "unescapeJava",
      description:
        'Returns a String whose Java literals are unescaped. Literals unescaped include escape sequences for quotes (") and control characters, such as tab (\\t), and carriage return (\\n).',
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "unescapeUnicode",
      description:
        "Returns a String whose escaped Unicode characters are unescaped.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    },
    {
      method: "unescapeXml",
      description: "Unescapes the characters in a String using XML entities.",
      output: "String",
      mainString: {
        show: true,
        required: true,
        label: "String to modify",
        helpText: "String Type"
      },
      integer01: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      integer02: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer Type"
      },
      string01: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      string02: {
        show: false,
        required: false,
        label: "",
        helpText: "String Type"
      },
      integerList: {
        show: false,
        required: false,
        label: "",
        helpText: "Integer List Type"
      },
      stringList: {
        show: false,
        required: false,
        label: "",
        helpText: "String List Type"
      }
    }
  ];
}
