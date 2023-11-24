import java.util.Random;
import java.util.Scanner;

public class Game2048 {
    private static final int UP = 1;
    private static final int DOWN = 2;
    private static final int LEFT = 3;
    private static final int RIGHT = 4;
    //创建游戏主体：一个4*4二维数组
    static int[][] board = new int[4][4];
    static Random r = new Random();
    //判断用户的指令是否有效，即数组是否真的发生了变化
    private static boolean changed;

    private Game2048() {
    }

    public static void play() {
        System.out.println("输入WASD移动，输入quit退出");
        System.out.println("------------------------");
        changed = true;
        spawn();
        changed = true;
        spawn();
        initContent();
    }

    //打印游戏
    private static void print() {
        for (int[] row : board) {
            for (int i : row) {
                if (i == 0)
                    System.out.print("-    ");
                else {
                    if (i < 9) System.out.print(i + "    ");
                    else if (i < 99) System.out.print(i + "   ");
                    else if (i < 999) System.out.print(i + "  ");
                    else System.out.print(i + " ");
                }
            }
            System.out.println();
        }
    }

    private static void initContent() {
        print();
        while (true) {
            switch (new Scanner(System.in).nextLine().toLowerCase()) {
                case "w" -> act(UP);
                case "s" -> act(DOWN);
                case "a" -> act(LEFT);
                case "d" -> act(RIGHT);
                case "quit" -> {
                    System.out.println("退出游戏");
                    System.exit(-1);
                }
                case "exit" -> System.exit(0);
            }
        }
    }

    //将合并，移动和展示整合成一个动作。先移动，再合并，最后再移动一次。
    private static void act(int direction) {
        move(direction);
        merge(direction);
        move(direction);
        spawn();
        print();
    }

    //生成新数字的方法：随机找一个元素，如果不是0则再循环一次；如果是0就在这里生成2或4（概率五五开）。如果用户执行了移动操作但是数组没有变化则不生成。
    private static void spawn() {
        if (changed) {
            while (true) {
                int a = r.nextInt(4);
                int b = r.nextInt(4);
                if (board[a][b] == 0) {
                    board[a][b] = (r.nextInt(2) + 1) * 2;
                    changed = false;
                    return;
                }
            }
        }
    }

    //移动
    private static void move(int direction) {
        // 一种思路是 用一个do while嵌套减少无效遍历 如果一个方向不可能继续移动就停止循环 减少了资源的无效利用
        final int size = 4;
        boolean tileMoved;
        if (direction == UP) {
            do {
                tileMoved = false;
                for (int j = 0; j < size; j++) {
                    for (int i = 0; i < size - 1; i++) {
                        if (board[i][j] == 0 && board[i + 1][j] != 0) {
                            board[i][j] = board[i + 1][j];
                            board[i + 1][j] = 0;
                            tileMoved = true;
                            changed = true;
                        }
                    }
                }
            } while (tileMoved);
        } else if (direction == DOWN) {
            do {
                tileMoved = false;
                for (int j = 0; j < size; j++) {
                    for (int i = size - 1; i > 0; i--) {
                        if (board[i][j] == 0 && board[i - 1][j] != 0) {
                            board[i][j] = board[i - 1][j];
                            board[i - 1][j] = 0;
                            tileMoved = true;
                            changed = true;
                        }
                    }
                }
            } while (tileMoved);
        } else if (direction == LEFT) {
            do {
                tileMoved = false;
                for (int i = 0; i < size; i++) {
                    for (int j = 0; j < size - 1; j++) {
                        if (board[i][j] == 0 && board[i][j + 1] != 0) {
                            board[i][j] = board[i][j + 1];
                            board[i][j + 1] = 0;
                            tileMoved = true;
                            changed = true;
                        }
                    }
                }
            } while (tileMoved);
        } else if (direction == RIGHT) {
            do {
                tileMoved = false;
                for (int i = 0; i < size; i++) {
                    for (int j = size - 1; j > 0; j--) {
                        if (board[i][j] == 0 && board[i][j - 1] != 0) {
                            board[i][j] = board[i][j - 1];
                            board[i][j - 1] = 0;
                            tileMoved = true;
                            changed = true;
                        }
                    }
                }
            } while (tileMoved);
        }
    }

    //合并
    private static void merge(int direction) {
        if (direction == UP) {
            for (int j = 0; j < 4; j++) {
                for (int i = 0; i < 3; i++) {
                    if (board[i][j] != 0 && board[i][j] == board[i + 1][j]) {
                        changed = true;
                        board[i][j] = board[i + 1][j] * 2;
                        board[i + 1][j] = 0;
                    }
                }
            }
        } else if (direction == DOWN) {
            for (int j = 0; j < 4; j++) {
                for (int i = 3; i > 0; i--) {
                    if (board[i][j] != 0 && board[i][j] == board[i - 1][j]) {
                        changed = true;
                        board[i][j] = board[i - 1][j] * 2;
                        board[i - 1][j] = 0;
                    }
                }
            }
        } else if (direction == LEFT) {
            for (int i = 0; i < 4; i++) {
                for (int j = 0; j < 3; j++) {
                    if (board[i][j] != 0 && board[i][j] == board[i][j + 1]) {
                        changed = true;
                        board[i][j] = board[i][j + 1] * 2;
                        board[i][j + 1] = 0;
                    }
                }
            }
        } else if (direction == RIGHT) {
            for (int i = 0; i < 4; i++) {
                for (int j = 3; j > 0; j--) {
                    if (board[i][j] != 0 && board[i][j] == board[i][j - 1]) {
                        changed = true;
                        board[i][j] = board[i][j - 1] * 2;
                        board[i][j - 1] = 0;
                    }
                }
            }
        }
    }
}
