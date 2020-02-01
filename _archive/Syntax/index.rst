文法
===================

-------------------
基本型
-------------------

Go言語の基本型は以下です。

- bool
- string
- int (※int 型はbit数や符号なしなどいろいろありますが、基本はintです)
- float64 (,float32)
- complex128 (,complex64)

-------------------
変数宣言
-------------------

変数の定義は var でできます。

.. code-block:: go

    var i int

初期値を与えることができます。

.. code-block:: go

    var i int = 1

初期値を与えずに宣言すると、ゼロ値が与えられます。

.. code-block:: go

    func main() {
        var i int
        var f float64
        var b bool
        var s string
        fmt.Printf("%v %v %v %q\n", i, f, b, s)
    }
    // 0 0 false ""

関数の中では暗黙的な型宣言ができます。変数 i の型が int 型になっていることがわかります。シンプルでかつ柔軟であることからローカル変数の宣言にはこの省略変数宣言によって初期化されることが多いです。

.. code-block:: go

    func main() {
        i := 2
        fmt.Println(i)
        fmt.Println(reflect.TypeOf(i))
    }
    // 2
    // int

定数は Const キーワードを用いて宣言します。

.. code-block:: go

    const Pi = 3.141592

定数を上書きしようとするとコンパイラエラーが発生します。

.. code-block:: go

    const Pi = 3
    const Pi = 3.141592

