public class LCG {
    public static void main(String[] args) {
        int x1 = 1998;
        int a = 11;
        int c = 19;
        int m = 32749;
        int before = -1;
        for (int i = 0; i < 100; i++) {
            if (before == -1) before = 1998;
            int next = (a * before + c) % m;
            int result = next % 4;
            System.out.println(result);
            before = next;
        }
    }
}
