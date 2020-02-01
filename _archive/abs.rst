ABS(AtCoder Beginners Selection)
===================================

簡単な文法のおさらいとして、プログラミングコンテストサイトのオンラインジャッジを用いて理解度を確認してみましょう。ここでは `ABS(AtCoder Beginners Selection) <https://atcoder.jp/contests/abs>`_ を用いて確認してみます。

1. ABC086A - Product
-----------------------------------

【問題概要】

二つの正整数 :math:`a, b` が与えられます。 :math:`a` と :math:`b` の積が偶数か奇数か判定してください。

【制約】

+ :math:`1 \le a, b \le 10000`
+ :math:`a, b` は整数

.. code-block:: go

    func main() {
        var a, b int
        fmt.Scan(&a, &b)

        if a*b%2 == 0 {
            fmt.Println("Even")
        } else {
            fmt.Println("Odd")
        }
    }

2. ABC081A - Placing Marbles
-----------------------------------

**【問題概要】**

0 と 1 のみから成る 3 桁の番号 s が与えられます。1 が何個含まれるかを求めてください。

.. code-block:: go

    func main() {
        s := ""
        fmt.Scan(&s)
        ans := 0
        for _, v := range s {
            if v == '1' {
                ans++
            }
        }
        fmt.Println(ans)
    }

3. ABC081B - Shift only
-----------------------------------

**【問題概要】**
黒板に :math:`N` 個の正の整数 :math:`A_1, \dots, A_N` が書かれています。
すぬけ君は，黒板に書かれている整数がすべて偶数であるとき，次の操作を行うことができます。
    
+ 黒板に書かれている整数すべてを，`2` で割ったものに置き換える。

すぬけ君は最大で何回操作を行うことができるかを求めてください。

**【制約】**

+ :math:`1 \le N \le 200`

.. code-block:: go

    func main() {
        n := 0
        fmt.Scan(&n)
        a := make([]int, n)
        for i := 0; i < n; i++ {
            fmt.Scan(&a[i])
        }

        ans := 1 << 30
        for _, v := range a {
            cnt := 0
            for v%2 == 0 {
                cnt++
                v /= 2
            }
            ans = min(ans, cnt)
        }
        fmt.Println(ans)
    }

    func min(x, y int) int {
        if x < y {
            return x
        } else {
            return y
        }
    }

4. ABC087B - Coins
-----------------------------------

**【問題概要】**
500 円玉を :math:`A` 枚、100 円玉を :math:`B` 枚、50 円玉を :math:`C` 枚持っています。これらの硬貨の中から何枚かを選び、合計金額をちょうど :math:`X` 円にする方法は何通りあるでしょうか？

**【制約】**

+ :math:`0 \le A, B, C \le 50`
+ :math:`A + B + C \ge 1`
+ :math:`50 \le X \le 20000`
+ :math:`A, B, C` は整数である
+ :math:`X` は :math:`50` の倍数である

.. code-block:: go

    func main() {
        var a, b, c, x int
        fmt.Scan(&a, &b, &c, &x)
        ans := 0
        for i := 0; i <= a; i++ {
            for j := 0; j <= b; j++ {
                for k := 0; k <= c; k++ {
                    if 500*i+100*j+50*k == x {
                        ans++
                    }
                }
            }
        }
        fmt.Println(ans)
    }

5. ABC083B - Some Sums
-----------------------------------

**【問題概要】**
`1` 以上 :math:`N` 以下の整数のうち、`10` 進法で各桁の和が :math:`A` 以上 :math:`B` 以下であるものについて、総和を求めてください。

**【制約】**

+ :math:`1 \le N \le 10^4`
+ :math:`1 \le A \le B \le 36`
+ 入力はすべて整数

.. code-block:: go

    func main() {
        var n, a, b int
        fmt.Scan(&n, &a, &b)
        ans := 0
        for i := 1; i <= n; i++ {
            sum := dsum(i)
            if a <= sum && sum <= b {
                ans += i
            }
        }
        fmt.Println(ans)
    }

    func dsum(x int) int {
        ret := 0
        for x > 0 {
            ret += x % 10
            x /= 10
        }
        return ret
    }

6. ABC088B - Card Game for Two
-----------------------------------

**【問題概要】**
`N` 枚のカードがあり、`i` 枚目のカードには :math:`a_i` という数が書かれています。
Alice と Bob はこれらのカードを使ってゲームを行います。ゲームでは 2 人が交互に 1 枚ずつカードを取っていきます。Alice が先にカードを取ります。
2 人がすべてのカードを取ったときゲームは終了し、取ったカードの数の合計がその人の得点になります。2 人とも自分の得点を最大化するように最適戦略をとったとき、Alice は Bob より何点多くの得点を獲得できるかを求めてください。

**【制約】**

+ :math:`N` は :math:`1` 以上 :math:`100` 以下の整数

.. code-block:: go

    func main() {
        var n int
        fmt.Scan(&n)
        a := make([]int, n)
        for i := 0; i < n; i++ {
            fmt.Scan(&a[i])
        }
        sort.Sort(sort.Reverse(sort.IntSlice(a)))
        alice, bob := 0, 0
        for i := 0; i < n; i++ {
            if i%2 == 0 {
                alice += a[i]
            } else {
                bob += a[i]
            }
        }
        fmt.Println(alice - bob)
    }

7. ABC085B - Kagami Mochi
-----------------------------------

**【問題概要】**
`N` 個の整数 :math:`d[0], d[1], \dots, d[N-1]` が与えられます。
この中に何種類の異なる値があるでしょうか？

**【制約】**

+ :math:`1 \le N \le 100`
+ :math:`1 \le d[i] \le 100`
+ 入力値はすべて整数

.. code-block:: go

    func main() {
        var n int
        fmt.Scan(&n)
        d := make([]int, n)
        m := make(map[int]bool)
        for i := 0; i < n; i++ {
            fmt.Scan(&d[i])
            m[d[i]] = true
        }
        fmt.Println(len(m))
    }

8. ABC085C - Otoshidama
-----------------------------------

**【問題概要】**
10000 円札と、5000 円札と、1000 円札が合計で :math:`N` 枚あって、合計金額が :math:`Y` 円であったという。このような条件を満たす各金額の札の枚数の組を 1 つ求めなさい。そのような状況が存在し得ない場合には -1 -1 -1 と出力しなさい。

**【制約】**

+ :math:`1 \le N \le 2000`
+ :math:`1000 \le Y \le 2*10^7`
+ :math:`N` は整数
+ :math:`Y` は :math:`1000` の倍数

.. code-block:: go

    func main() {
        var n, y int
        fmt.Scan(&n, &y)

        for i := 0; i <= 2000; i++ {
            for j := 0; j <= 2000; j++ {
                k := n - i - j
                if k >= 0 {
                    if 10000*i+5000*j+1000*k == y {
                        fmt.Printf("%d %d %d\n", i, j, k)
                        return
                    }
                }
            }
        }
        fmt.Println("-1 -1 -1")
    }

9. ABC049C - 白昼夢 / Daydream
-----------------------------------

【問題概要】
英小文字からなる文字列 :math:`S` が与えられます。
`T` が空文字列である状態から始めて、以下の操作を好きな回数繰り返すことで :math:`S = T` とすることができるか判定してください。

+ :math:`T` の末尾に "dream", "dreamer", "erase", "eraser" のいずれかを追加する。

【制約】

+ :math:`1 \le |S| \le 10^5`
+ :math:`S` は英小文字からなる

.. code-block:: go

    func main() {
        s := ""
        fmt.Scan(&s)
        ts := []string{"dream", "dreamer", "erase", "eraser"}
        i := len(s)
        for i > 0 {
            c := false
            for _, t := range ts {
                if i-len(t) >= 0 && s[i-len(t):i] == t {
                    i -= len(t)
                    c = true
                    break
                }
            }
            if i > 0 && !c {
                fmt.Println("NO")
                return
            }
        }
        fmt.Println("YES")
    }

10. ABC086C - Traveling
-----------------------------------

【問題概要】

シカの AtCoDeer くんは二次元平面上で旅行をしようとしています。AtCoDeer くんの旅行プランでは、時刻 :math:`0` に 点 :math:`(0, 0)` を出発し、:math:`1` 以上 :math:`N` 以下の各 :math:`i` に対し、時刻 :math:`t_i` に 点 :math:`(x_i, y_i)` を訪れる予定です。

AtCoDeer くんが時刻 :math:`t` に 点 :math:`(x, y)` にいる時、 時刻 :math:`t+1` には 点 :math:`(x+1,y), (x−1,y), (x,y+1), (x,y−1)` のうちいずれかに存在することができます。その場にとどまることは出来ないことに注意してください。AtCoDeer くんの旅行プランが実行可能かどうか判定してください。

【制約】

+ :math:`1 \le N \le 10^5`
+ :math:`0 \le x_i, y_i \le 10^5`
+ :math:`1 \le t_i \le t_{i+1} \le 10^5`
+ 入力はすべて整数

.. code-block:: go

    func main() {
        var n int
        fmt.Scan(&n)
        t, x, y := make([]int, n+1), make([]int, n+1), make([]int, n+1)
        for i := 1; i < n+1; i++ {
            fmt.Scan(&t[i], &x[i], &y[i])
        }

        for i := 1; i < n+1; i++ {
            dist := abs(x[i]-x[i-1]) + abs(y[i]-y[i-1])
            time := t[i] - t[i-1]
            if dist > time || (time-dist)%2 == 1 {
                fmt.Println("No")
                return
            }
        }

        fmt.Println("Yes")
    }

    func abs(x int) int {
        if x < 0 {
            return -x
        } else {
            return x
        }
    }
