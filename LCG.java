public class LCG {
    public static void main(String[] args) {
        int a = 11;
        int c = 19;
        int m = 10007;
        int before = -1;
        for (int i = 0; i < 50; i++) {
            if (before == -1) before = 1997;
            int next = (a * before + c) % m;
            int result = next % 4;
            System.out.println(next);
            System.out.println(result);
            before = next;
        }
    }
}
