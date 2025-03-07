T? tryCast<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}
