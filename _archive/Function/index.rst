関数
=====================

---------------------
関数定義
---------------------

Goの関数のシグネチャは最初に変数でその後に型となります。以下のようになります。

.. code-block:: go

    func add(x int, y int) int {
        return x + y;
    }

型が同じ場合は、型を省略することができます。

.. code-block:: go

    func add(x, y int) int {
        return x + y;
    }

関数の戻り値として複数の値を返すことができます。

.. code-block:: go

    func swap(s, t string) (string, string) {
        return t, s
    }

---------------------
関数型
---------------------

関数も変数です。よって変数のように関数を渡すことができます。

.. code-block:: go

    func add(fn func(int, int) int) int {
        return fn(3, 4)
    }

    func main() {
        vFunc := func(x, y int) int {
            return x*x + y*y
        }
        fmt.Println(vFunc(2, 3))
        fmt.Println(add(vFunc))
    }

---------------------
クロージャ
---------------------

Goの関数はクロージャ [#]_ として定義することができます。

.. code-block:: go

    func adder() func(int) int {
        // main関数で呼ばれた関数はadder()関数内のsumを参照している
        sum := 0
        return func(x int) int {
            sum += x
            return sum
        }
    }

    func main() {
        pos, neg := adder(), adder()
        for i := 1; i <= 10; i++ {
            fmt.Printf("%d %d\n", pos(i), neg(-2*i))
        }
    }


Exercise: Fibonacci closure の実装の一例は以下のようになります。

.. code-block:: go

    // fibonacci is a function that returns
    // a function that returns an int.
    func fibonacci() func() int {
        a1, a2 := 0, 1
        return func() int {
            ret := a1
            a1 = a2
            a2 += ret
            return ret
        }
    }

    func main() {
        f := fibonacci()
        for i := 0; i < 10; i++ {
            fmt.Println(f())
        }
    }

---------------------
defer文
---------------------

defer文は呼び出し元の関数がreturnするまで処理を遅延させることができます。defefは通常さまざまなクリーンアップ処理を実行する機能を単純化するために用いられます。

.. code-block:: go

    func helloworld() {
        defer fmt.Println("world")
        fmt.Print("hello ")
    }

    func main() {
        helloworld()
    }
    // hello world

defer文はstackです。

.. code-block:: go

    func main() {
        for i := 1; i < 10; i++ {
            defer fmt.Print(i)
        }
    }
    // 987654321

注意しないといけない点として、 ``os.Exit(1)`` とようにプロセスが終了した場合には ``defer`` の結果を返さずに終了することになります。以下が ``defer`` の結果が得られず終了する例です。

.. code-block:: go

    func main() {
        for i := 1; i < 10; i++ {
            defer fmt.Print(i)
            log.Fatal("Error occured.")
        }
    }

結果

.. code-block:: none

    // 2019/07/06 17:08:09 Error occured.

上記のように ``defer fmt.Print(i)`` の結果がreturnされることはありません。

エラー発生時などは ``defer`` による処理がなされずに終了するので、 ``main`` 関数以外では ``error`` を上位の関数に戻して、一番最後に ``main`` 関数の中で終了することが多いのではないでしょうか。

---------------------
パニック
---------------------

致命的なエラーとして呼び出し元でエラーハンドリングする必要のない、もしくはエラーが起きても本当にリカバリが必要なときだけエラーハンドリングさせたい場合に panic 関数を呼び出してパニックという状態を作ることができます。

Go言語に組み込まれている panic 関数は以下です。

.. code-block:: go

    func panic(interface{})

panic を起こしてみましょう。

.. code-block:: go

    func f() {
        panic("panic occured!")
    }

    func main() {
        f()	
    }
    // panic: panic occured!

    // goroutine 1 [running]:
    // main.f()
    // 	C:/Users/testUser/go/src/sample/sample.go:4 +0x40
    // main.main()
    // 	C:/Users/testUser/go/src/sample/sample.go:8 +0x27


配列外参照のなどの実行時エラーの場合もパニックが発生します。

.. code-block:: go

    func main() {
        array := [...]int{1, 2, 3}
        for i := 0;; i++ {
            fmt.Println(array[i])
        }
    }

パニック発生時でも defer 関数は実行されます。

.. code-block:: go

    func f() {
        panic("panic occured!")
    }

    func main() {
        defer fmt.Println("do something...")
        f()	
    }
    // do something...
    // panic: panic occured!

    // goroutine 1 [running]:
    // main.f()
    // 	C:/Users/testUser/go/src/sample/sample.go:6 +0x40
    // main.main()
    // 	C:/Users/testUser/go/src/sample/sample.go:11 +0xae


recover 関数を呼び出して処理することでパニックを中断させることができます。参考 [#]_ の内容になります。

.. code-block:: go

    func main() {
        f()
        fmt.Println("Returned normally from f.")
    }

    func f() {
        defer func() {
            if r := recover(); r != nil {
                fmt.Println("Recovered in f", r)
            }
        }()
        fmt.Println("Calling g.")
        g(0)
        fmt.Println("Returned normally from g.")
    }

    func g(i int) {
        if i > 3 {
            fmt.Println("Panicking!")
            panic(fmt.Sprintf("%v", i))
        }
        defer fmt.Println("Defer in g", i)
        fmt.Println("Printing in g", i)
        g(i + 1)
    }
    // Calling g.
    // Printing in g 0
    // Printing in g 1
    // Printing in g 2
    // Printing in g 3
    // Panicking!
    // Defer in g 3
    // Defer in g 2
    // Defer in g 1
    // Defer in g 0
    // Recovered in f 4
    // Returned normally from f.


.. [#] https://ja.wikipedia.org/wiki/%E3%82%AF%E3%83%AD%E3%83%BC%E3%82%B8%E3%83%A3
.. [#] https://blog.golang.org/defer-panic-and-recover