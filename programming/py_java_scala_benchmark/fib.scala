object flib2 extends App {

  @scala.annotation.tailrec
  def flib(n: Int, preResult: Int, result: Int): Int = {
    if (n <= 1) result
    else flib(n - 1, result, preResult + result)
  }

  println(flib(36, 0, 1))
}
