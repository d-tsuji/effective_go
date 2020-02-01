flag
============================================

コマンドラインのフラグを解析するパッケージです。

https://golang.org/pkg/flag/

簡単なサンプルを試してみます。

.. code-block:: go

    func main() {

        var (
            concurrency int
            environment string
            debug       bool
        )

        flag.StringVar(&environment, "e", "local", "environment")
        flag.BoolVar(&debug, "x", false, "debug mode")
        flag.IntVar(&concurrency, "n", 32, "concurrent count")
        flag.Parse()

        fmt.Printf("environment : %v\n", environment)
        fmt.Printf("debug : %v\n", debug)
        fmt.Printf("concurrency : %v\n", concurrency)
    }

環境別になんやかんやしたい...!という場合に実行時の引数にするのはよくあるパターンかと思います。上記の場合、何もしないと local 環境で並行数 3 で実行するプログラムを起動するイメージです。

.. code-block:: none

    > main.exe
    environment : local
    debug : false
    concurrency : 3

オプションを指定しないと、デフォルト値が設定されていることがわかります。

次にオプションを指定してみます。

.. code-block:: none

    > main.exe -e stg -n 20 -x true
    environment : stg
    debug : true
    concurrency : 20

このように指定したオプションの値が設定されていることがわかります。

ヘルプコマンドはデフォルトで実装されていて、 -h を指定すると各オプションの内容が表示されます。

.. code-block:: none

    > main.exe -h
    Usage of main.exe:
    -e string
            environment (default "local")
    -n int
            concurrent count (default 3)
    -x    debug mode

間違ったオプションの値が設定された場合(例えば int 型が指定されるオプションに文字列型の値を指定した場合など)はエラーになります。

.. code-block:: none

    > main.exe -n miss
    invalid value "miss" for flag -n: parse error
    Usage of main.exe:
    -e string
            environment (default "local")
    -n int
            concurrent count (default 3)
    -x    debug mode

