public class fib {
    public static int flib(int n) {
        if (n < 2)
            return n;
        else
            return flib(n - 1) + flib(n - 2);
    }

    public static void main(String[] args) {
        System.out.println(flib(36));
    }
}
