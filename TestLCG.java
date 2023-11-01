public class TestLCG {
    //模拟线性同余发生器
    private long seed;
    private long a;
    private long c;
    private long m;

    public TestLCG(long seed, long a, long c, long m) {
        this.seed = seed;
        this.a = a;
        this.c = c;
        this.m = m;
    }

    public long nextRandom() {
        seed = (a * seed + c) % m;
        return seed;
    }

    public static void main(String[] args) {
        long seed = 123; // 初始种子
        long a = 1664525; // 乘数
        long c = 1013904223; // 增量
        long m = 4294967296L; // 模数 (2^32)

        TestLCG generator = new TestLCG(seed, a, c, m);

        for (int i = 0; i < 10; i++) {
            long random = generator.nextRandom();
            System.out.println(random);
        }
    }
}
