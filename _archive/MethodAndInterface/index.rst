メソッドとインターフェース
==================================

----------------------------------
メソッド
----------------------------------

Goは型にメソッドを定義することができます。メソッドはレシーバを引数にとる関数となります。

Absメソッドは Vertex 型のレシーバを持つことを意味しています。

.. code-block:: go

    type Vertex struct {
        X, Y float64
    }

    func (v Vertex) Abs() float64 {
        return math.Sqrt(v.X*v.X + v.Y*v.Y)
    }

    func main() {
        v := Vertex{X: 3, Y: 4}
        fmt.Println(v.Abs())
    }
    // 5

メソッドはレシーバを伴う関数ですので、メソッドでない関数として記述することも可能です。

.. code-block:: go

    type Vertex struct {
        X, Y float64
    }

    func AbsFunc(v Vertex) float64 {
        return math.Sqrt(v.X*v.X + v.Y*v.Y)
    }

    func main() {
        v := Vertex{X: 3, Y: 4}
        fmt.Println(AbsFunc(v))
    }
    // 5

ポイントレシーバでメソッドを宣言することができます。レシーバの変数を更新する必要がある場合はポイントレシーバにする必要があります。

.. code-block:: go

    type Vertex struct {
        X, Y float64
    }

    func (v Vertex) Abs() float64 {
        return math.Sqrt(v.X*v.X + v.Y*v.Y)
    }

    func (v *Vertex) Scale(f float64) {
        v.X = v.X * f
        v.Y = v.Y * f
    }

    func main() {
        v := Vertex{3, 4}
        v.Scale(10)
        fmt.Println(v.Abs())
    }

可視性
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
----------------------------------
インターフェース
----------------------------------

インターフェース型を定義できます。インターフェースはメソッドのシグネチャの集まりで定義します。構造体などの具象型が満たすべき仕様といえます。Javaでは implement が必要でしたが、Goでは具象型が明示的にインターフェースを実装することを示す必要がありません。

以下は A Tour of Go の例です。T 型の関数 M がインターフェース型 I の関数 M を実装していることになります。

.. code-block:: go

    type I interface {
        M()
    }

    type T struct {
        S string
    }

    func (t T) M() {
        fmt.Println(t.S)
    }

    func main() {
        var i I = T{"hello"}
        i.M()
    }

インターフェースに定義されている関数をメソッドとして実装している型は自動的にそのインターフェースを実装していることになります。

インターフェースにある具体的な値が nil の場合はメソッドは nil レシーバーとして呼び出されます。Go では nil をレシーバーとして呼び出されても適切に処理するメソッドを記述するのが一般的です。以下は A Tour of Go の例です。(なお以下の例で nil の処理をしない場合はパニックが発生します。)

.. code-block:: go

    type I interface {
        M()
    }

    type T struct {
        S string
    }

    func (t *T) M() {
        if t == nil {
            fmt.Println("<nil>")
            return
        }
        fmt.Println(t.S)
    }

    func main() {
        var i I

        var t *T
        i = t
        describe(i)
        i.M()

        i = &T{"hello"}
        describe(i)
        i.M()
    }

    func describe(i I) {
        fmt.Printf("(%v, %T)\n", i, i)
    }
    // (<nil>, *main.T)
    // <nil>
    // (&{hello}, *main.T)
    // hello

nil インターフェースの値は nil です。以下は A Tour of Go の例です。

.. code-block:: go

    type I interface {
        M()
    }

    func main() {
        var i I
        describe(i)
        i.M()
    }

    func describe(i I) {
        fmt.Printf("(%v, %T)\n", i, i)
    }
    // (<nil>, <nil>)
    // panic: runtime error: invalid memory address or nil pointer dereference
    // [signal 0xc0000005 code=0x0 addr=0x0 pc=0x48cd4d]

    // goroutine 1 [running]:
    // main.main()
    // 	C:/Users/testUser/go/src/sample/sample.go:12 +0x3d

Javaでいうところのポリモフィズムのような実装も可能です。

.. code-block:: go

    type Vehicle interface {
        run()
    }

    type Car struct {
        name string
    }

    func (c Car) run() {
        fmt.Println("Booom")
    }

    type Plane struct {
    }

    func (p Plane) run() {
        fmt.Println("Booooooooooom")
    }

    func main() {
        var vehicle Vehicle
        vehicle = &Car{}
        vehicle.run()
        vehicle = &Plane{}
        vehicle.run()
    }
    // Booom!
    // Booooooooooom!

エラーインタフェース
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

エラー型を error 値で表現します。 error 型はGo言語に組み込まれているインターフェースです。

.. code-block:: go

    type error interface {
        Error() string
    }

error型を使うことでGo言語として一貫した例外処理を記述することができます。errorを実装した関数を記述した一例を紹介します。

.. code-block:: go

    type MyError struct {
        message string
    }

    func (err MyError) Error() string {
        return err.message
    }

    func throwError() (val string, err error) {
        return "hoge", MyError{"illegal statement"}
    }

    func main() {
        val, err := throwError()
        if err != nil {
            fmt.Fprint(os.Stderr, "error occured! val: " + val)
        }
    }
    // error occured! val: hoge
