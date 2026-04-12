extension BrazilianTimeZone on DateTime {
  DateTime toBrazilianTimeZone() {
    return toUtc().subtract(const Duration(hours: 3));
  }
}
