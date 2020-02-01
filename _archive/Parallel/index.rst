並行処理
=================

-----------------
goroutine
-----------------

goroutine (ゴルーチン)は、Goのランタイムに管理される軽量なスレッドです。

go 関数 で goroutine として動作します。

並行して処理されていることがわかります。

.. code-block:: go

    func f() {
        for i := 0; i < 5; i++ {
            time.Sleep(1 * time.Second)
            fmt.Printf("%d ", i)
        }
    }

    func main() {
        go f()
        f()
    }
    // 0 0 1 1 2 2 3 3 4 4 

なお以下のようにすると main 関数の処理が終了してしまい、goroutine が動作中に関わらず処理が終了します。

.. code-block:: go

    func f() {
        for i := 0; i < 5; i++ {
            time.Sleep(1 * time.Second)
            fmt.Printf("%d ", i)
        }
    }

    func main() {
        go f()
        go f()
    }

ゴルーチンからゴルーチンを呼び出すことも可能です。

.. code-block::

    func main() {

        fmt.Printf("[%v] main() start.\n", time.Now())

        go Do2()
        time.Sleep(5 * time.Second)

        fmt.Printf("[%v] main() stopped.\n", time.Now())

    }

    func Do2() {
        fmt.Printf("[%v] Do2() start.\n", time.Now())
        func() {
            go heavyProcess()
        }()
        fmt.Printf("[%v] Do2() completed.\n", time.Now())
    }

    func heavyProcess() {
        fmt.Printf("[%v] heavyProcess() start.\n", time.Now())
        time.Sleep(3 * time.Second)
        fmt.Printf("[%v] heavyProcess() completed.\n", time.Now())
    }
    // [2019-07-01 07:53:19.1271209 +0900 JST m=+0.002000001] main() start.
    // [2019-07-01 07:53:19.1631137 +0900 JST m=+0.037992801] Do2() start.
    // [2019-07-01 07:53:19.1631137 +0900 JST m=+0.037992801] Do2() completed.
    // [2019-07-01 07:53:19.1631137 +0900 JST m=+0.037992801] heavyProcess() start.
    // [2019-07-01 07:53:22.1634087 +0900 JST m=+3.038287801] heavyProcess() completed.
    // [2019-07-01 07:53:24.1636904 +0900 JST m=+5.038569501] main() stopped.

-----------------
Channel
-----------------

チャネル( Channel )型は、チャネルオペレータの <- を用いて値の送受信ができる通り道です。同一プロセスのゴルーチン間での、通信・同期・値の共用、に使用します。GoのチャネルはFIFOキューに並行処理をしても正しく処理できることを保証する機能を組み合わせたものです。

Goならわかるシステムプログラミング [#]_ のよると、チャネルには以下の3つの性質があります。

    | チャネルは、データを順序よく受け渡すためのデータ構造である
    | チャネルは、並行処理されても正しくデータを受け渡す同期機構である
    | チャネルは、読み込み・書き込みの準備ができるまでブロックする機能である

チャネル型は chan です。

チャネルの送受信の書式は以下のようになります。

.. code-block:: go

    chan 要素型
    chan <- 送信する値 (送信専用チャネル)
    <- chan (受信専用チャネル)

チャネルの生成は以下のように宣言します。

.. code-block:: go

    make(chan 要素型)
    make(chan 要素型, キャパシティ)

チャネルを利用した送受信は以下のようになります。

.. code-block:: go

    チャネル <- 送信する値 // 送信
    <- チャネル // 受信


以下はchar <-string 型のチャネルを用いてメッセージをやりとりするサンプルです。

.. code-block:: go

    func main() {
        message := make(chan string, 10)

        go func(m chan<- string) {
            for i := 0; i < 5; i++ {
                if i%2 == 0 {
                    m <- "Ping "
                } else {
                    m <- "Pong "
                }
            }
            close(m)
            fmt.Println("func() finished.")
        }(message)

        for {
            time.Sleep(1 * time.Second)
            msg, ok := <-message
            if !ok {
                break
            }
            fmt.Print(msg)
        }
    }
    // func() finished.
    // Ping Pong Ping Pong Ping 

チャネルは、キャパシティの有無によって動作が変わってきます。バッファつきのチャネルの場合、送信側はバッファがある限りすぐに送信を完了して、次の処理を実行できます。一方、バッファなしのチャネルの場合、送信後、受信されないとそれまで処理がブロックされます。

先程の例でチャネル生成時に以下のようにバッファありのチャネルを生成していました。

.. code-block:: go

    message := make(chan string, 10)

これを以下のようにバッファなしのチャネルに変更してみます。

.. code-block:: go

    message := make(chan string)

送信側は受信側でチャネルから受信されるまでブロッキングされるので、出力される順序が変わることがわかります。

.. code-block:: go

    func main() {
        message := make(chan string)

        go func(m chan<- string) {
            for i := 0; i < 5; i++ {
                if i%2 == 0 {
                    m <- "Ping "
                } else {
                    m <- "Pong "
                }
            }
            close(m)
            fmt.Println("func() finished.")
        }(message)

        for {
            time.Sleep(1 * time.Second)
            msg, ok := <-message
            if !ok {
                break
            }
            fmt.Print(msg)
        }
    }
    // Ping Pong Ping Pong Ping func() finished.

バッファチャネルを使った別の例を見てます。次の例は同時実行数を制限するようなチャネルの使い方です。いわゆるセマフォです。

.. code-block:: go

    const concurrency = 3
    const total = 10

    func main() {

        semaphore := make(chan int, concurrency)

        go consume(semaphore)

        for i := 0; i < total; i++ {
            semaphore <- i
            fmt.Printf("[%v] Add Semaphore: num -> %d\n", time.Now(), i)
        }
    }

    func consume(semaphore chan int) {
        time.Sleep(3 * time.Second)
        for i := 0; i < total; i++ {
            _ = <-semaphore
            time.Sleep(500 * time.Millisecond)
        }
    }

結果は以下のように最初にチャネルのバッファ上限である3つまで追加され、その後は0.5秒ごとに処理するゴルーチンの結果を待って逐次処理されます。ゴルーチンは最大3並列で処理されていることがわかります。

.. code-block:: none

    [2019-06-30 22:56:24.1686604 +0900 JST m=+0.002497701] Add Semaphore: num -> 0
    [2019-06-30 22:56:24.2056768 +0900 JST m=+0.039514101] Add Semaphore: num -> 1
    [2019-06-30 22:56:24.2056768 +0900 JST m=+0.039514101] Add Semaphore: num -> 2
    [2019-06-30 22:56:27.1689285 +0900 JST m=+3.002765801] Add Semaphore: num -> 3
    [2019-06-30 22:56:27.6691217 +0900 JST m=+3.502959001] Add Semaphore: num -> 4
    [2019-06-30 22:56:28.1695923 +0900 JST m=+4.003429601] Add Semaphore: num -> 5
    [2019-06-30 22:56:28.6700202 +0900 JST m=+4.503857501] Add Semaphore: num -> 6
    [2019-06-30 22:56:29.1704991 +0900 JST m=+5.004336401] Add Semaphore: num -> 7
    [2019-06-30 22:56:29.6706213 +0900 JST m=+5.504458601] Add Semaphore: num -> 8
    [2019-06-30 22:56:30.1715697 +0900 JST m=+6.005407001] Add Semaphore: num -> 9

-----------------
Select
-----------------

select は複数のチャネルに対して同時に送受信待ちを行うときに使用します。以下の例では、チャネルを通じてデータを送受信する場合に、データ送信用のチャネルとは別に、送受信が終わったことを示すチャネルを用いています。

.. code-block:: go

    func fibonacci(c, quit chan int) {
        x, y := 0, 1
        for {
            select {

            // (c)チャネルに値を送信
            case c <- x:
                x, y = y, x+y

                // (quit)チャネルから値を受信できるようになった場合は関数からreturnする
            case <-quit:
                fmt.Println("quit")
                return
            }
        }
    }

    func main() {
        c := make(chan int)
        quit := make(chan int)

        // 値の送受信をゴルーチンとして非同期処理する
        go func() {
            for i := 0; i < 10; i++ {
                // チャネルから値を受信
                // チャネルが空の場合は、チャネルに値が送信されるまでブロッキング
                fmt.Printf("%v ", <-c)
                time.Sleep(500 * time.Millisecond)
            }

            // quit チャネルに値を送信することでfibonacci関数からreturnさせる
            quit <- 0
        }()

        fibonacci(c, quit)
    }
    // 0 1 1 2 3 5 8 13 21 34 quit

-----------------
context
-----------------

コンテキストの簡単な例を見てみます。

.. code-block:: go

    func main() {

        fmt.Println("start func()")
        ctx, cancel := context.WithCancel(context.Background())
        go func() {
            for i := 0; i < 5; i++ {
                fmt.Printf("%v second passes\n", i)
                time.Sleep(1 * time.Second)
            }
            fmt.Println("func() is finished")
            cancel()
        }()
        <-ctx.Done()
        fmt.Println("all tasks are finished")
    }
    // start func()
    // 0 second passes
    // 1 second passes
    // 2 second passes
    // 3 second passes
    // 4 second passes
    // func() is finished
    // all tasks are finished

.. [#] https://www.lambdanote.com/products/go
