class Helpers {
  Helpers._();

  /// Format a double as currency string, e.g. â‚¹8.00
  static String formatCurrency(double amount) {
    return 'â‚¹${amount.toStringAsFixed(2)}';
  }

  /// Parse a price string like "â‚¹8.00" into a double.
  static double parsePrice(String price) {
    return double.tryParse(price.replaceAll('â‚¹', '')) ?? 0.0;
  }
}
