制御文
=======================

-----------------------
条件分岐
-----------------------

if 文は以下のように書けます。(, ) は不要です。

.. code-block:: go

    func main() {
        rand.Seed(time.Now().UnixNano())
        i := rand.Int()
        fmt.Println(i)
        if i % 2 == 1 {
            fmt.Println("odd")
        } else {
            fmt.Println("even")
        }
    }

if 文内のみのスコープの変数と合わせて使うことができます。

.. code-block:: go

	rand.Seed(time.Now().UnixNano())
	if i := rand.Int(); i % 2 == 1 {
		fmt.Println("odd")
	} else {
		fmt.Println("even")
	}

switch文は以下のように書けます。

.. code-block:: go

	rand.Seed(time.Now().UnixNano())
	i := rand.Int()
	switch {
	case i % 15 == 0:
		fmt.Println("FizzBuzz")
	case i % 3 == 0:
		fmt.Println("Fizz")
	case i % 5 == 0:
		fmt.Println("Buzz")
	default: 
		fmt.Println(i)
	}

-----------------------
繰り返し
-----------------------

ベーシックなfor文は以下のように記述します。

.. code-block:: go

	sum := 0
	for i := 0; i <= 10; i++ {
		sum += i
	}

Javaの `while` キーワードはなく、`while` ループはfor文で記述することになります。

.. code-block:: go

	sum, i := 0, 0
	for i <= 10 {
		sum += i
		i++
	}

これは無限ループです。

.. code-block:: go

    for {
    }

for文でループする際に range を用いることができます。スライスやマップをひとつずつ反復処理する場合に用いられます。

.. code-block:: go

    func main() {
        var pow []int
        for i, j := 0, 1; i < 10; i++ {
            pow = append(pow, j)
            j *= 2
        }
        for i, v := range pow {
            fmt.Printf("2**%d = %d\n", i, v)	
        }
    }
    // 2**0 = 1
    // 2**1 = 2
    // 2**2 = 4
    // 2**3 = 8
    // 2**4 = 16
    // 2**5 = 32
    // 2**6 = 64
    // 2**7 = 128
    // 2**8 = 256
    // 2**9 = 512

ループのindexが不要であれば _ で捨てることができます。

.. code-block:: go

    func main() {
        var pow []int
        for i, j := 0, 1; i < 10; i++ {
            pow = append(pow, j)
            j *= 2
        }
        for _, v := range pow {
            fmt.Printf("%d ", v)	
        }
    }
    // 1 2 4 8 16 32 64 128 256 512 

-----------------------
goto
-----------------------

任意の位置に移動する goto 文が Go には定義されています。

.. code-block:: go

    func main() {
        fmt.Println("A")
        goto Jump
        fmt.Println("B")
    Jump:
        fmt.Println("C")
    }
    // A
    // C

B が出力されておらず、スキップされていることがわかります。

-----------------------
例外処理
-----------------------

Goのプログラムは、エラーの状態を error 値で表現します。以下の組み込みのインターフェースがあります。

.. code-block:: go

    type error interface {
        Error() string
    }

エラーハンドインターフェースとも関連しますが、標準関数を用いるときの例外処理は以下のように err の変数が nil であるかの判定をすることが一般的です。

.. code-block:: go

    func main() {
        file, err := os.Open("test.txt")
        if err != nil {
            fmt.Fprint(os.Stderr, err.Error())
            os.Exit(1)
        }
        defer file.Close()
        fmt.Println("ok")
    }
    // open test.txt: The system cannot find the file specified.