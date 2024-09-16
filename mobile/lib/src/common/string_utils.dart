class StringUtils {
  static String truncateWithEllipsis(String text, int maxLength) {
    const ellipsis = '...';
    if (text.length <= maxLength) {
      return text;
    }
    // Ensure the final string length, including ellipsis, is maxLength
    return text.substring(0, maxLength - ellipsis.length) + ellipsis;
  }

  static String capitalize(String text) {
    return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
  }
}
