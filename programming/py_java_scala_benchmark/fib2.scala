object flib3 extends App {
  def flib3(n: Int): Int = {
    if (n <= 2) 1
    else flib3(n - 1) + flib3(n - 2)
  }
  println(flib3(36))
}
