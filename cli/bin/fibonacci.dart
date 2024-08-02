void main() {
  int n = 20;
  var result = fibonacci(n);
  print('Số finonacci thứ $n là: $result');
}

int fibonacci(int n) {
  if (n == 0 || n == 1) {
    return n;
  }
  return fibonacci(n - 1) + fibonacci(n - 2);
}
