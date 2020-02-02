Effective Go
=======================

イントロダクション
---------------------------------

Goは新しい言語です。既存の言語からアイデアを借りていますが、その言語の特徴で書かれたプログラムとは異なる、Goのプログラムを効果的にする興味深い特徴を持っています。C++やJavaで書かれたプログラムをそのままGoに移植しても、満足な結果は得られないでしょう。JavaのプログラムはGoではなく、Javaで書かれます。一方、Goの特徴を用いると、元のプログラムとは全く異なりますが、良いものが生まれるかもしれません。Goを適切に書くのは、その特徴とイディオムを理解することが重要です。そして、他のGoプログラマーが理解しやすいように、命名規則やフォーマット、プログラムの構成といったGoの慣習を知ることも重要です。

このドキュメントは明確で慣用的なGoのコードを書くためのヒントを示します。`言語仕様 </ref/spec>`_ や `Tour of Go <//tour.golang.org/>`_ や `How to Write Go Code </doc/code.html>`_ を補強するもので、最初に読むべきものです。

例
~~~~~~~~~~~~~~~~

Go本体のパッケージのソースはコアライブラリとしてだけではなく、Goをどのように扱うかというサンプルでもあります。さらに、多くのパッケージでは `golang.org <//golang.org>`_ から直接実行できる、動作する自己完結型の実行可能サンプルが含まれています。 `この <//golang.org/pkg/strings/#example_Map>`_ ようなものです。必要に応じて "Example" のボタンを押すと開きます。問題へのアプローチ方法や実装方法について質問がある場合は、ライブラリのドキュメントやコード、サンプルから回答やアイデア、背景を知ることができるでしょう。

フォーマット
---------------------

フォーマッティングは最も議論の多い問題ですが、それほど重要な問題ではありません。開発者はさまざまなフォーマッティングスタイルに適応できますが、同じスタイルを守っている場合は、この話題に費やす時間を短縮できます。問題は、長い規範的なスタイルガイドを用いずにこのユートピアにアプローチする方法です。

Goでは、通常とは異なるアプローチを採用し、ほとんどのフォーマットの問題をマシンに任せます。**gofmt** プログラム（ソースファイルレベルではなくパッケージレベルで動作する **go fmt** としても利用可能）は、Goプログラムを読み取り、標準スタイルのインデントと垂直方向の配置でソースを出力し、コメントを保持し、必要に応じて再フォーマットします。 新しいレイアウトの状況を処理する方法を知りたい場合は、 **gofmt** を実行します。 答えが正しくないと思われる場合は、プログラムを再配置（またはgofmtに関するバグを報告）してください。そのまま使わないでください。

例として、構造体のフィールドにコメントを並べるのに時間を費やす必要はありません。 Gofmtがそれを行います。以下に示します。

.. code-block:: go

   type T struct {
       name string // name of the object
       value int // its value
   }

**gofmt** カラムをフォーマットします:

.. code-block:: go

   type T struct {
       name    string // name of the object
       value   int    // its value
   }

標準パッケージのすべてのGoのコードは **gofmt** でフォーマットされています。

その他の書式設定の詳細が残っています。 簡潔に説明します。

インデント
    インデントにタブを使用し **gofmt** はデフォルトでタブを出力します。必要な場合にのみスペースを使用してください。
行の長さ
    Goには行の長さの制限はありません。パンチされたカードがあふれる心配はありません。行が長すぎると感じる場合は、それを折り返し、追加のタブでインデントします。
括弧
    Goでは、CやJavaよりも括弧が少なくてすみます。制御構造( **if**, **for**, **switch** )の構文に括弧がありません。また、演算子の優先順位の階層は短く明確です。

.. code-block:: go

    x<<8 + y<<16

他の言語とは異なり、スペースが意味することを意味します。

コメント
------------------

Goは、Cスタイルの ``/* */`` のブロックコメントとC++スタイルの ``//`` 行コメントを提供します。行コメントは標準です。ブロックコメントは、ほとんどがパッケージコメントとして用いられますが、式の中や大量のコードを無効にするのに役立ちます。

**godoc** と呼ばれるプログラム(およびWebサーバー)は、Goソースファイルを解析して、パッケージの内容に関するドキュメントを抽出します。 トップレベルの宣言の前に表示され、改行を挿入しないコメントは、宣言とともにその項目の説明文となります。 これらのコメントの性質とスタイルは **godoc** が作成するドキュメントの質を決定します。

すべてのパッケージには、パッケージコメント、パッケージ句の前のブロックコメントが必要です。 複数ファイルで構成されるパッケージの場合、パッケージコメントは1つのファイルにあれば十分です。パッケージコメントは、パッケージを紹介し、パッケージ全体に関連する情報を提供する必要があります。 godocページの最初に表示され、詳細なドキュメントに続くように設定する必要があります。

.. code-block:: go

   /*
   Package regexp implements a simple library for regular expressions.

   The syntax of the regular expressions accepted is:

       regexp:
           concatenation { '|' concatenation }
       concatenation:
           { closure }
       closure:
           term [ '*' | '+' | '?' ]
       term:
           '^'
           '$'
           '.'
           character
           '[' [ '^' ] character-ranges ']'
           '(' regexp ')'
   */
   package regexp

パッケージが単純な場合、パッケージのコメントは簡潔にすることができます。

.. code-block:: go

   // Package path implements utility routines for
   // manipulating slash-separated filename paths.

コメントには、アスタリスクのバナーなどの追加の書式設定は必要ありません。生成された出力は固定幅のフォントで表示されないかもしれないので、配置の間隔に依存しないでください。 **godoc** は **gofmt** のように面倒を見てくれます。コメントはインタプリタに解釈されないプレーンテキストであるため、HTMLやその他の注釈(_this_など)はそのまま表示されるため、使用しないでください。 **godoc** が行う調整の1つは、プログラムスニペットに適した固定幅フォントでインデントされたテキストを表示することです。 `fmt package <>`_ のパッケージコメントは、これを有効に使用しています。

コンテキストによっては **godoc** はコメントを再フォーマットすることすらできない場合があるため、正しいスペル、句読点、文構造を使用する、長い行を折り畳むなど、コメントがまっすぐに見えるようにしてください。

パッケージ内では、最上位の宣言の直前のコメントは、その宣言のドキュメントコメントとして機能します。プログラム内のエクスポートされた(大文字の)名前にはすべて、ドキュメンテーションコメントが必要です。

ドキュメントコメントは完全な文として最適に機能し、さまざまな自動プレゼンテーションを可能にします。最初の文は、宣言される名前で始まる1行の要約でなければなりません。

.. code-block:: go

   // Compile parses a regular expression and returns, if successful,
   // a Regexp that can be used to match against text.
   func Compile(str string) (*Regexp, error) {

すべてのdocコメントが説明する項目の名前で始まる場合、goツールのdocサブコマンドを使用して、grepを介して出力を実行できます。 「Compile」という名前を思い出せなかったが、正規表現の解析関数を探していたので、コマンドを実行したとします。

.. code-block:: go

   $ go doc -all regexp | grep -i parse

パッケージ内のすべてのドキュメントコメントが「This function ...」で始まった場合、grepは名前を検索することには役に立ちません。しかし、パッケージは各docコメントを名前で開始するため、このようなものが表示され、探している単語が思い出されます。

.. code-block:: go

   $ go doc -all regexp | grep -i parse
       Compile parses a regular expression and returns, if successful, a Regexp
       MustCompile is like Compile but panics if the expression cannot be parsed.
       parsed. It simplifies safe initialization of global variables holding
   $

Goの宣言構文では、宣言をグループ化できます。単一のdocコメントで、関連する定数または変数のグループを紹介できます。宣言全体が提示されているため、このようなコメントはしばしばおかしなものになります。

.. code-block:: go

   // Error codes returned by failures to parse an expression.
   var (
       ErrInternal      = errors.New("regexp: internal error")
       ErrUnmatchedLpar = errors.New("regexp: unmatched '('")
       ErrUnmatchedRpar = errors.New("regexp: unmatched ')'")
       ...
   )

グループ化は、変数のセットがミューテックスによって保護されているという事実など、項目の関係を示すこともできます。

.. code-block:: go

   var (
       countLock   sync.Mutex
       inputCount  uint32
       outputCount uint32
       errorCount  uint32
   )

命名
-----

命名は他の言語と同様にGoでも重要です。セマンティックな効果もあります。外部パッケージから参照可視性は、その最小の文字が大文字かどうかで決まります。したがって、Goプログラムの命名規則について少し話をする価値があります。

パッケージ名
~~~~~~~~~~~~~~~~~~~~~

パッケージがインポートされるとき、パッケージ名がコンテンツのアクセッサーになります。

以下のように

.. code-block:: go

   import "bytes"

とパッケージをインポートすると、 **bytes.Buffer** としてパッケージを使うことができます。パッケージを使う人が同じ名前でパッケージのコンテンツを参照すると便利です。これはパッケージ名が適切であることを意味します。短く完結で分かりやすくあるべきです。慣例としてパッケージ名は小文字の単一の単語名にします。アンダースコアやmixedCapsである必要はありません。多くの人がパッケージ名を打ち込むことを考えて、簡潔すぎるほど簡潔にしてしまう場合があります。その場合でも衝突を心配する必要はありません。パッケージ名はインポートするときのデフォルトでしかないからです。ソースコード全体で唯一である必要はありません。衝突するようなまれな場合、インポートするパッケージ名に異なる名前をつけることができます。どのような場合でも、インポート機能においてファイル名がどのパッケージで使用されるかを決めるので、混乱することはまれです。別の慣例として、パッケージ名はソースディレクトリの名前であるこということです。 **src/encoding/base64** にあるパッケージは **"encoding/base64"** としてインポートされます。名前は **base64** であって、 **encoding_base64** でも **encodingBase64** でもありません。

The importer of a package will use the name to refer to its contents, so
exported names in the package can use that fact to avoid stutter. (Don't
use the **import .** notation, which can simplify tests that must run
outside the package they are testing, but should otherwise be avoided.)
For instance, the buffered reader type in the **bufio** package is
called **Reader**, not **BufReader**, because users see it as
**bufio.Reader**, which is a clear, concise name. Moreover, because
imported entities are always addressed with their package name,
**bufio.Reader** does not conflict with **io.Reader**. Similarly, the
function to make new instances of **ring.Ring**—which is the definition
of a *constructor* in Go—would normally be called **NewRing**, but since
**Ring** is the only type exported by the package, and since the package
is called **ring**, it's called just **New**, which clients of the
package see as **ring.New**. Use the package structure to help you
choose good names.

Another short example is **once.Do**; **once.Do(setup)** reads well and
would not be improved by writing **once.DoOrWaitUntilDone(setup)**. Long
names don't automatically make things more readable. A helpful doc
comment can often be more valuable than an extra long name.

.. _Getters:

ゲッター
~~~~~~~~~~~~~~~~~~

Go doesn't provide automatic support for getters and setters. There's
nothing wrong with providing getters and setters yourself, and it's
often appropriate to do so, but it's neither idiomatic nor necessary to
put **Get** into the getter's name. If you have a field called **owner**
(lower case, unexported), the getter method should be called **Owner**
(upper case, exported), not **GetOwner**. The use of upper-case names
for export provides the hook to discriminate the field from the method.
A setter function, if needed, will likely be called **SetOwner**. Both
names read well in practice:

.. code-block:: go

   owner := obj.Owner()
   if owner != user {
       obj.SetOwner(user)
   }

インターフェース名
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

By convention, one-method interfaces are named by the method name plus
an -er suffix or similar modification to construct an agent noun:
**Reader**, **Writer**, **Formatter**, **CloseNotifier** etc.

There are a number of such names and it's productive to honor them and
the function names they capture. **Read**, **Write**, **Close**,
**Flush**, **String** and so on have canonical signatures and meanings.
To avoid confusion, don't give your method one of those names unless it
has the same signature and meaning. Conversely, if your type implements
a method with the same meaning as a method on a well-known type, give it
the same name and signature; call your string-converter method
**String** not **ToString**.

.. _mixed-caps:

MixedCaps
~~~~~~~~~~~~~~~~~

Finally, the convention in Go is to use **MixedCaps** or **mixedCaps**
rather than underscores to write multiword names.

セミコロン
------------------

Like C, Go's formal grammar uses semicolons to terminate statements, but
unlike in C, those semicolons do not appear in the source. Instead the
lexer uses a simple rule to insert semicolons automatically as it scans,
so the input text is mostly free of them.

The rule is this. If the last token before a newline is an identifier
(which includes words like **int** and **float64**), a basic literal
such as a number or string constant, or one of the tokens

.. code-block:: go

   break continue fallthrough return ++ -- ) }

the lexer always inserts a semicolon after the token. This could be
summarized as, “if the newline comes after a token that could end a
statement, insert a semicolon”.

A semicolon can also be omitted immediately before a closing brace, so a
statement such as

.. code-block:: go

       go func() { for { dst <- <-src } }()

needs no semicolons. Idiomatic Go programs have semicolons only in
places such as **for** loop clauses, to separate the initializer,
condition, and continuation elements. They are also necessary to
separate multiple statements on a line, should you write code that way.

One consequence of the semicolon insertion rules is that you cannot put
the opening brace of a control structure (**if**, **for**, **switch**,
or **select**) on the next line. If you do, a semicolon will be inserted
before the brace, which could cause unwanted effects. Write them like
this

.. code-block:: go

   if i < f() {
       g()
   }

not like this

.. code-block:: go

   if i < f()  // wrong!
   {           // wrong!
       g()
   }

制御構造(Control structures)
--------------------------------------------------------------------

The control structures of Go are related to those of C but differ in
important ways. There is no **do** or **while** loop, only a slightly
generalized **for**; **switch** is more flexible; **if** and **switch**
accept an optional initialization statement like that of **for**;
**break** and **continue** statements take an optional label to identify
what to break or continue; and there are new control structures
including a type switch and a multiway communications multiplexer,
**select**. The syntax is also slightly different: there are no
parentheses and the bodies must always be brace-delimited.

If
~~

In Go a simple **if** looks like this:

.. code-block:: go

   if x > 0 {
       return y
   }

Mandatory braces encourage writing simple **if** statements on multiple
lines. It's good style to do so anyway, especially when the body
contains a control statement such as a **return** or **break**.

Since **if** and **switch** accept an initialization statement, it's
common to see one used to set up a local variable.

.. code-block:: go

   if err := file.Chmod(0664); err != nil {
       log.Print(err)
       return err
   }

In the Go libraries, you'll find that when an **if** statement doesn't
flow into the next statement—that is, the body ends in **break**,
**continue**, **goto**, or **return**—the unnecessary **else** is
omitted.

.. code-block:: go

   f, err := os.Open(name)
   if err != nil {
       return err
   }
   codeUsing(f)

This is an example of a common situation where code must guard against a
sequence of error conditions. The code reads well if the successful flow
of control runs down the page, eliminating error cases as they arise.
Since error cases tend to end in **return** statements, the resulting
code needs no **else** statements.

.. code-block:: go

   f, err := os.Open(name)
   if err != nil {
       return err
   }
   d, err := f.Stat()
   if err != nil {
       f.Close()
       return err
   }
   codeUsing(f, d)

.. _redeclaration:

Redeclaration and reassignment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

An aside: The last example in the previous section demonstrates a detail
of how the **:=** short declaration form works. The declaration that
calls **os.Open** reads,

.. code-block:: go

   f, err := os.Open(name)

This statement declares two variables, **f** and **err**. A few lines
later, the call to **f.Stat** reads,

.. code-block:: go

   d, err := f.Stat()

which looks as if it declares **d** and **err**. Notice, though, that
**err** appears in both statements. This duplication is legal: **err**
is declared by the first statement, but only *re-assigned* in the
second. This means that the call to **f.Stat** uses the existing **err**
variable declared above, and just gives it a new value.

In a **:=** declaration a variable **v** may appear even if it has
already been declared, provided:

-  this declaration is in the same scope as the existing declaration of
   **v** (if **v** is already declared in an outer scope, the
   declaration will create a new variable §),
-  the corresponding value in the initialization is assignable to **v**,
   and
-  there is at least one other variable that is created by the
   declaration.

This unusual property is pure pragmatism, making it easy to use a single
**err** value, for example, in a long **if-else** chain. You'll see it
used often.

§ It's worth noting here that in Go the scope of function parameters and
return values is the same as the function body, even though they appear
lexically outside the braces that enclose the body.

For
~~~

The Go **for** loop is similar to—but not the same as—C's. It unifies
**for** and **while** and there is no **do-while**. There are three
forms, only one of which has semicolons.

.. code-block:: go

   // Like a C for
   for init; condition; post { }

   // Like a C while
   for condition { }

   // Like a C for(;;)
   for { }

Short declarations make it easy to declare the index variable right in
the loop.

.. code-block:: go

   sum := 0
   for i := 0; i < 10; i++ {
       sum += i
   }

If you're looping over an array, slice, string, or map, or reading from
a channel, a **range** clause can manage the loop.

.. code-block:: go

   for key, value := range oldMap {
       newMap[key] = value
   }

If you only need the first item in the range (the key or index), drop
the second:

.. code-block:: go

   for key := range m {
       if key.expired() {
           delete(m, key)
       }
   }

If you only need the second item in the range (the value), use the
*blank identifier*, an underscore, to discard the first:

.. code-block:: go

   sum := 0
   for _, value := range array {
       sum += value
   }

The blank identifier has many uses, as described in `a later
section <#blank>`__.

For strings, the **range** does more work for you, breaking out
individual Unicode code points by parsing the UTF-8. Erroneous encodings
consume one byte and produce the replacement rune U+FFFD. (The name
(with associated builtin type) **rune** is Go terminology for a single
Unicode code point. See `the language
specification </ref/spec#Rune_literals>`__ for details.) The loop

.. code-block:: go

   for pos, char := range "日本\x80語" { // \x80 is an illegal UTF-8 encoding
       fmt.Printf("character %#U starts at byte position %d\n", char, pos)
   }

prints

.. code-block:: go

   character U+65E5 '日' starts at byte position 0
   character U+672C '本' starts at byte position 3
   character U+FFFD '�' starts at byte position 6
   character U+8A9E '語' starts at byte position 7

Finally, Go has no comma operator and **++** and **--** are statements
not expressions. Thus if you want to run multiple variables in a **for**
you should use parallel assignment (although that precludes **++** and
**--**).

.. code-block:: go

   // Reverse a
   for i, j := 0, len(a)-1; i < j; i, j = i+1, j-1 {
       a[i], a[j] = a[j], a[i]
   }

Switch
~~~~~~

Go's **switch** is more general than C's. The expressions need not be
constants or even integers, the cases are evaluated top to bottom until
a match is found, and if the **switch** has no expression it switches on
**true**. It's therefore possible—and idiomatic—to write an
**if**-**else**-**if**-**else** chain as a **switch**.

.. code-block:: go

   func unhex(c byte) byte {
       switch {
       case '0' <= c && c <= '9':
           return c - '0'
       case 'a' <= c && c <= 'f':
           return c - 'a' + 10
       case 'A' <= c && c <= 'F':
           return c - 'A' + 10
       }
       return 0
   }

There is no automatic fall through, but cases can be presented in
comma-separated lists.

.. code-block:: go

   func shouldEscape(c byte) bool {
       switch c {
       case ' ', '?', '&', '=', '#', '+', '%':
           return true
       }
       return false
   }

Although they are not nearly as common in Go as some other C-like
languages, **break** statements can be used to terminate a **switch**
early. Sometimes, though, it's necessary to break out of a surrounding
loop, not the switch, and in Go that can be accomplished by putting a
label on the loop and "breaking" to that label. This example shows both
uses.

.. code-block:: go

   Loop:
       for n := 0; n < len(src); n += size {
           switch {
           case src[n] < sizeOne:
               if validateOnly {
                   break
               }
               size = 1
               update(src[n])

           case src[n] < sizeTwo:
               if n+1 >= len(src) {
                   err = errShortInput
                   break Loop
               }
               if validateOnly {
                   break
               }
               size = 2
               update(src[n] + src[n+1]<<shift)
           }
       }

Of course, the **continue** statement also accepts an optional label but
it applies only to loops.

To close this section, here's a comparison routine for byte slices that
uses two **switch** statements:

.. code-block:: go

   // Compare returns an integer comparing the two byte slices,
   // lexicographically.
   // The result will be 0 if a == b, -1 if a < b, and +1 if a > b
   func Compare(a, b []byte) int {
       for i := 0; i < len(a) && i < len(b); i++ {
           switch {
           case a[i] > b[i]:
               return 1
           case a[i] < b[i]:
               return -1
           }
       }
       switch {
       case len(a) > len(b):
           return 1
       case len(a) < len(b):
           return -1
       }
       return 0
   }

.. _type_switch:

Type switch
~~~~~~~~~~~~~~~~~~~

A switch can also be used to discover the dynamic type of an interface
variable. Such a *type switch* uses the syntax of a type assertion with
the keyword **type** inside the parentheses. If the switch declares a
variable in the expression, the variable will have the corresponding
type in each clause. It's also idiomatic to reuse the name in such
cases, in effect declaring a new variable with the same name but a
different type in each case.

.. code-block:: go

   var t interface{}
   t = functionOfSomeType()
   switch t := t.(type) {
   default:
       fmt.Printf("unexpected type %T\n", t)     // %T prints whatever type t has
   case bool:
       fmt.Printf("boolean %t\n", t)             // t has type bool
   case int:
       fmt.Printf("integer %d\n", t)             // t has type int
   case *bool:
       fmt.Printf("pointer to boolean %t\n", *t) // t has type *bool
   case *int:
       fmt.Printf("pointer to integer %d\n", *t) // t has type *int
   }

関数
----------------------------------

.. _multiple-returns:

複数の戻り値
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Goの珍しい機能の1つは、関数とメソッドが複数の値を返すことができることです。 この形式は、Cプログラムのいくつかの不格好なイディオムを改善するために使用できます。EOFに対して-1などの in-band エラーが返され、アドレスによって渡された引数を変更するといったものです。

Cでは、書き込みエラーは、負の数によって通知され、エラーコードは揮発性の場所に隠されてしまいます。Goでは Write はカウント数とエラーを同時に戻すことができます。エラーは「デバイスが一杯になったため、一部のバイト数は書き込めたが、全てを書き込むことはできませんでした」といったものです。os パッケージの **Write** メソッドのシグネチャは以下のものです。

.. code-block:: go

   func (file *File) Write(b []byte) (n int, err error)

そして、ドキュメントのように、``n！= len(b)`` の場合、書き込まれたバイト数と非nilエラーを返します。 これは一般的なスタイルです。 その他の例については、エラー処理のセクションを参照してください。

同様のアプローチにより、参照パラメーターをシミュレートするためにポインターを戻り値に渡す必要がなくなります。 バイトスライスの位置から数値を取得し、その数値と次の位置を返す単純な関数を次に示します。

.. code-block:: go

   func nextInt(b []byte, i int) (int, int) {
       for ; i < len(b) && !isDigit(b[i]); i++ {
       }
       x := 0
       for ; i < len(b) && isDigit(b[i]); i++ {
           x = x*10 + int(b[i]) - '0'
       }
       return x, i
   }

これを使用して、次のように入力スライス ``b`` の数値をスキャンできます。

.. code-block:: go

       for i := 0; i < len(b); {
           x, i = nextInt(b, i)
           fmt.Println(x)
       }

名前付けされた戻り値
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Goの関数の戻り値は、入力パラメーターと同様に、名前を付けて通常の変数として使用できます。名前が付けられると、関数の開始時にそれらの型のゼロ値で初期化されます。 関数が引数なしでreturnステートメントを実行する場合、結果パラメーターの現在の値が戻り値として使用されます。

名前は必須ではありませんが、コードをより短く明確にすることができます。それらはドキュメントです。nextIntの返り値に名前を付けると、返されたintがどれであるかが明らかになります。

.. code-block:: go

   func nextInt(b []byte, pos int) (value, nextPos int) {

名前付きの戻り値は初期化され、return ステートメントの戻り値に紐付いているため、単純化および明確化できます。これらをうまく使用するio.ReadFullのバージョンは次のとおりです。

.. code-block:: go

   func ReadFull(r Reader, buf []byte) (n int, err error) {
       for len(buf) > 0 && err == nil {
           var nr int
           nr, err = r.Read(buf)
           n += nr
           buf = buf[nr:]
       }
       return
   }

Defer
~~~~~

Goの **defer** ステートメントは、deferを実行する関数が戻る直前に実行される関数呼び出し(遅延関数)をスケジュールします。 これは、関数がどのパスを返すかに関係なく解放する必要があるリソースなどの状況に対処するための、珍しい方法ですが、効果的な方法です。 標準的な例は、ミューテックスのロック解除またはファイルのクローズです。

.. code-block:: go

   // Contents returns the file's contents as a string.
   func Contents(filename string) (string, error) {
       f, err := os.Open(filename)
       if err != nil {
           return "", err
       }
       defer f.Close()  // f.Close will run when we're finished.

       var result []byte
       buf := make([]byte, 100)
       for {
           n, err := f.Read(buf[0:])
           result = append(result, buf[0:n]...) // append is discussed later.
           if err != nil {
               if err == io.EOF {
                   break
               }
               return "", err  // f will be closed if we return here.
           }
       }
       return string(result), nil // f will be closed if we return here.
   }

Closeなどの関数の呼び出しを遅延することには、2つの利点があります。 まず、ファイルを閉じることを決して忘れないことを保証します。これは、後で関数を編集して新しい戻りパスを追加する場合によくある間違いです。 2つ目にClose関数がOpen関数の近くにあることを意味します。これは、関数の最後に配置するよりもずっと明確です。

遅延関数(関数がメソッドの場合はレシーバーを含む)の引数は、関数呼び出しの実行時ではなく ``defer`` の実行時に評価されます。関数の実行時に変数が値を変更する心配を防ぎます。また、これは、単一の遅延呼び出しの場所で複数の関数の実行を遅延できることを意味します。これは簡単な例です。

.. code-block:: go

   for i := 0; i < 5; i++ {
       defer fmt.Printf("%d ", i)
   }

遅延関数はLIFOの順序で実行されるため、このコードにより、関数が戻るときに **4 3 2 1 0** が出力されます。 より妥当な例は、プログラムを通して関数の実行をトレースする簡単な方法です。 次のような簡単なトレースルーチンをいくつか作成できます。

.. code-block:: go

   func trace(s string)   { fmt.Println("entering:", s) }
   func untrace(s string) { fmt.Println("leaving:", s) }

   // Use them like this:
   func a() {
       trace("a")
       defer untrace("a")
       // do something....
   }

遅延された関数の引数が ``defer`` の実行時に評価されるという事実を活用することで、より良い結果を得ることができます。トレースルーチンは、トレース解除ルーチンへの引数を設定できます。以下のような例です。

We can do better by exploiting the fact that arguments to deferred
functions are evaluated when the **defer** executes. The tracing routine
can set up the argument to the untracing routine. This example:

.. code-block:: go

   func trace(s string) string {
       fmt.Println("entering:", s)
       return s
   }

   func un(s string) {
       fmt.Println("leaving:", s)
   }

   func a() {
       defer un(trace("a"))
       fmt.Println("in a")
   }

   func b() {
       defer un(trace("b"))
       fmt.Println("in b")
       a()
   }

   func main() {
       b()
   }

以下のように表示します。

.. code-block:: go

   entering: b
   in b
   entering: a
   in a
   leaving: a
   leaving: b

他の言語のブロックレベルのリソース管理に慣れているプログラマーにとって **defer** は独特のように思えるかもしれません。しかし、その最も興味深く、強力なアプリケーションは、ブロックベースではなく機能ベースであるという事実からきています。 パニックと回復のセクションでは、別の例を見るでしょう。

データ
--------------------

**new** によるアロケーション
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Goは2つのメモリアロケーションのプリミティブを持っています。組み込み関数である **new** と **make** です。それらは異なることを行い、異なる型に適用するため困惑するかもしれません。しかしルールはシンプルです。まず **new** について説明しましょう。これはメモリをアロケーションする組み込み関数ですが、他のいくつかの言語の同じ関数名のそれとは異なり、メモリを **初期化** せず、ゼロにするだけです。つまり **new(T)** は、型Tの新しい要素にゼロ化されたメモリを割り当て、型*Tの値であるアドレスを返します。 Goの用語では、型Tとして新しく割り当てられたゼロ値へのポインターを返します。

**new** によって返されるメモリはゼロ化されます。これはデータ構造を設計する際に、各タイプのゼロ値をさらに初期化せずに使用できるように設計すると役立ちます。 データ構造を用いる開発者が **new** で変数を作成し、適切に動作できることを意味します。 たとえば、 **bytes.Buffer** のドキュメントには、「Bufferのゼロ値はすぐに使用できる空のバッファーです」と記載されています。 同様に **sync.Mutex** には明示的なコンストラクターまたは **Init** メソッドがありません。 代わりに **sync.Mutex** のゼロ値は非ロック状態のミューテックスとして定義されます。

ゼロ値の性質は推移的に機能します。以下の型宣言について考えてください。

.. code-block:: go

   type SyncedBuffer struct {
       lock    sync.Mutex
       buffer  bytes.Buffer
   }

型 **SyncedBuffer** の値も **new** によるメモリアロケーションや変数の宣言だけですぐに使用できます。次のスニペットでは **p** と **v** の両方が、追加のメソッドなどを用いることなく正しく機能します。

.. code-block:: go

   p := new(SyncedBuffer)  // type *SyncedBuffer
   var v SyncedBuffer      // type  SyncedBuffer

コンストラクタと複合リテラル
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

パッケージ **os** から派生したこの例のように、ゼロ値では不十分な場合があり、初期化コンストラクターが必要になる場合があります。

.. code-block:: go

   func NewFile(fd int, name string) *File {
       if fd < 0 {
           return nil
       }
       f := new(File)
       f.fd = fd
       f.name = name
       f.dirinfo = nil
       f.nepipe = 0
       return f
   }

上記はたくさんのボイラープレートがあり冗長です。複合リテラルを使用して単純化できます。複合リテラルは、評価されるたびに新しいインスタンスを作成する式です。

.. code-block:: go

   func NewFile(fd int, name string) *File {
       if fd < 0 {
           return nil
       }
       f := File{fd, name, nil, 0}
       return &f
   }

Cとは異なり、ローカル変数のアドレスを返すことはまったく問題ありません。 変数に関連付けられたアドレスは、関数がreturnされた後も生き残ります。 実際、複合リテラルのアドレスを取得すると、評価されるたびに新しいインスタンスが割り当てられるため、これらの最後の2行を結合できます。

.. code-block:: go

       return &File{fd, name, nil, 0}

複合リテラルのフィールドは順番に配置され、すべて存在する必要があります。 ただし、要素に **field：value** のペアとして明示的にラベルを付けることができます。その場合、フィールドは任意の順序で表示でき、指定されていないフィールドはゼロ値で初期化されます。 したがって、上記の例は以下のように書きかえることができます。

.. code-block:: go

       return &File{fd: fd, name: name}

稀なケースとして、複合リテラルにフィールドがまったく含まれていない場合、その型のゼロ値が作成されます。式 **new(File)**と **&File{}** は同等です。

複合リテラルは配列、スライス、マップも作成できます。フィールドラベルは、必要に応じてインデックスまたはマップのキーになります。 以下の例では、初期化は ``Eonee``, ``Eio`` および ``Einval`` が相異なっていれば、値に関係なく機能します。

.. code-block:: go

   a := [...]string   {Enone: "no error", Eio: "Eio", Einval: "invalid argument"}
   s := []string      {Enone: "no error", Eio: "Eio", Einval: "invalid argument"}
   m := map[int]string{Enone: "no error", Eio: "Eio", Einval: "invalid argument"}

訳注: https://play.golang.org/p/2DaYxFnjE6X

**make** によるアロケーション
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

メモリのアロケーションの話題に戻ります。 組み込み関数 **make(T, args)** は、**new(T)** とは異なる目的で用います。 スライス、マップ、およびチャンネルのみを作成し、型 **T** (\*T ではなく）で初期化された（ゼロではない）値を返します。**new(T)** と区別している理由は、これらの3つの型が、使用前に初期化する必要があるデータ構造への参照を内部的に表しているためです。 たとえば、スライスは、データ（配列内）へのポインター、長さ、および容量の3つの項目を持っています。これらの項目が初期化されるまで、スライスはnilです。 スライス、マップ、およびチャネルの場合 **make** は内部データ構造を初期化し、使用する値を準備します。 例えば、

.. code-block:: go

   make([]int, 10, 100)

100個のintの配列を割り当て、長さ10、配列の最初の10要素を指す容量100のスライス構造を作成します。 （スライスを作成するとき、容量は省略できます。詳細については、スライスに関するセクションを参照してください。）一方 ``new([]int)`` は、新しく割り当てられたゼロ化されたスライスへのポインター、つまり **nil** スライスのポインターを返します。

以下のサンプルは、 **new** と **make** の違いを示しています。

.. code-block:: go

   var p *[]int = new([]int)       // allocates slice structure; *p == nil; rarely useful
   var v  []int = make([]int, 100) // the slice v now refers to a new array of 100 ints

   // Unnecessarily complex:
   var p *[]int = new([]int)
   *p = make([]int, 100, 100)

   // Idiomatic:
   v := make([]int, 100)

**make** はマップ、スライス、およびチャンネルにのみ適用され、ポインターを返さないことに注意してください。明示的なポインタを取得するには、newで割り当てるか、変数のアドレスを明示的に取得します。

配列
~~~~~~

配列は、メモリレイアウトの詳細がわかっているときに役立ち、割り当てを回避するのに役立つ場合があります。しかし、主に次のセクションの主題であるスライスの素材として使われます。 そのスライスの基礎を築くために、配列に関するいくつかの言葉を以下に示します。

GoとCで配列が機能する方法には大きな違いがあります。Goでは

- 配列は値です。ある配列を別の配列に割り当てると、すべての要素がコピーされます。
- 特に、関数に配列を渡すと、配列へのポインターではなく配列のコピーを受け取ります。
- 配列のサイズはその型の一部です。型 **[10]int** と **[20]int** は区別されます。

配列が値である性質は便利ですが、高コストでもあります。 Cのような動作と効率が必要な場合は、配列のポインターを渡すことができます。

.. code-block:: go

   func Sum(a *[3]float64) (sum float64) {
       for _, v := range *a {
           sum += v
       }
       return
   }

   array := [...]float64{7.0, 8.5, 9.1}
   x := Sum(&array)  // Note the explicit address-of operator

しかしこの書き方はGoらしくありません。代わりにスライスを使います。

スライス
~~~~~~~~~~~~~~~~

スライスは配列をラップして、連続データへのより一般的で強力かつ便利なインターフェイスを提供します。変換行列などの明示的な次元を持つ項目を除き、Goのほとんどの配列プログラミングは、単純な配列ではなくスライスを使用して行われます。

スライスは、基礎となる配列への参照を保持します。あるスライスを別のスライスに割り当てると、両方とも同じ配列を参照します。 関数がスライスを引数を取る場合、スライスの要素に加えられた変更は呼び出し元に表示されます。これは、基礎となる配列へのポインターの受け渡しに似ています。 したがって ``Read`` 関数の引数には、ポインターと要素数の値ではなくスライスを受け入れることができます。 スライス内の長さは、読み取るデータ量の上限を設定します。 パッケージ ``os`` の型 ``File`` の ``Read`` メソッドのシグネチャは次のとおりです。

.. code-block:: go

   func (f *File) Read(buf []byte) (n int, err error)

このメソッドは、読み取られたバイト数とエラー値（存在する場合）を返します。大きなバッファー ``buf`` の最初の32バイトに読み込むには、バッファーを小さくスライスします。

.. code-block:: go

       n, err := f.Read(buf[0:32])

このようなスライスは一般的で効率的です。実際、効率性を無視すれば、次のスニペットはバッファーの最初の32バイトを読み取ります。

.. code-block:: go

       var n int
       var err error
       for i := 0; i < 32; i++ {
           nbytes, e := f.Read(buf[i:i+1])  // Read one byte.
           n += nbytes
           if nbytes == 0 || e != nil {
               err = e
               break
           }
       }

スライスの長さは、もとになる配列の制限内に収まる限り変更できます。 それを自分自身のスライスに割り当てるだけです。 組み込み関数 **cap** でアクセス可能なスライスの容量は、スライスが想定できる最大長を報告します。 以下の **append** はスライスにデータを追加する関数です。 データが容量を超える場合、再割り当てされたスライスが返されます。 この関数は **nil** スライスに適用されるときに **len** と **cap** が有効であることを使用し、0を返します。

.. code-block:: go

   func Append(slice, data []byte) []byte {
       l := len(slice)
       if l + len(data) > cap(slice) {  // reallocate
           // Allocate double what's needed, for future growth.
           newSlice := make([]byte, (l+len(data))*2)
           // The copy function is predeclared and works for any slice type.
           copy(newSlice, slice)
           slice = newSlice
       }
       slice = slice[0:l+len(data)]
       copy(slice[l:], data)
       return slice
   }

Appendはスライスの要素を変更できますが、スライス自体（ポインター、長さ、および容量を保持する実行時のデータ構造）は値によって渡されるため、あとからスライスを返すべきです。

スライスに追加するという考え方は非常に便利で、組み込みの **append** 関数によって実現できます。 ただし、その関数の設計を理解するには、もう少し情報が必要なので、後で説明します。

二次元スライス
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Goの配列とスライスは1次元です。 二次元配列またはスライスに相当するものを作成するには、次のように配列の配列またはスライスのスライスを定義する必要があります。

.. code-block:: go

   type Transform [3][3]float64  // A 3x3 array, really an array of arrays.
   type LinesOfText [][]byte     // A slice of byte slices.

スライスは可変長であるため、スライスの中にあるスライスを異なる長さにすることができます。 ``LinesOfText`` の例のように、これは一般的な状況です。各行には独立した長さがあります。

.. code-block:: go

   text := LinesOfText{
       []byte("Now is the time"),
       []byte("for all good gophers"),
       []byte("to bring some fun to the party."),
   }

場合によっては、二次元スライスを割り当てる必要があります。これは、たとえば、ピクセル行をスキャンするときに発生する可能性がある状況です。 これを達成するには2つの方法があります。 1つは、各スライスを個別に割り当てることです。 もう1つは、単一の配列を割り当て、個々のスライスをその配列に向けることです。 どちらを使用するかは、アプリケーションによって異なります。 スライスが拡大または縮小する可能性がある場合は、次の行を上書きしないように、個別に割り当てる必要があります。 そうでない場合は、単一の割り当てでオブジェクトを構築する方が効率的です。 参考のために、2つの方法の概要を以下に示します。 まず、1行ずつことなる長さを割り当てる場合です。

.. code-block:: go

   // Allocate the top-level slice.
   picture := make([][]uint8, YSize) // One row per unit of y.
   // Loop over the rows, allocating the slice for each row.
   for i := range picture {
       picture[i] = make([]uint8, XSize)
   }

次に、1つのスライスに行を割り当てる方法です。

.. code-block:: go

   // Allocate the top-level slice, the same as before.
   picture := make([][]uint8, YSize) // One row per unit of y.
   // Allocate one large slice to hold all the pixels.
   pixels := make([]uint8, XSize*YSize) // Has type []uint8 even though picture is [][]uint8.
   // Loop over the rows, slicing each row from the front of the remaining pixels slice.
   for i := range picture {
       picture[i], pixels = pixels[:XSize], pixels[XSize:]
   }

マップ
~~~~~~

マップは、ある型（キー）の値を別の型（要素または値）の値に関連付ける便利で強力な組み込みのデータ構造です。 キーは、整数、浮動小数点および複素数、文字列、ポインター、インターフェイス（動的な型が等価をサポートしている限り）、構造体、配列など、等号演算子が定義されている任意の型にすることができます。 スライスは等価が定義されていないため、マップのキーとして使用できません。 スライスと同様に、マップは背後にあるデータ構造への参照を保持します。 マップの内容を変更する関数にマップを渡すと、変更は呼び出し元に表示されます。

マップは、コロンで区切られたキーと値のペアを使用した通常の複合リテラル構文を使用して構築できるため、簡単に初期化することができます。

.. code-block:: go

   var timeZone = map[string]int{
       "UTC":  0*60*60,
       "EST": -5*60*60,
       "CST": -6*60*60,
       "MST": -7*60*60,
       "PST": -8*60*60,
   }

マップへの値の割り当てと取得は、キーが整数でなくてもよいことを除いて、配列とスライスの場合と同じような構文に見えます。

.. code-block:: go

   offset := timeZone["EST"]

マップに存在しないキーを使用してマップから値を取得しようとすると、マップ内のエントリの型のゼロ値が返されます。 たとえば、マップの値として整数が含まれている場合、存在しないキーを検索すると0が返されます。Setのデータ構造は、boolを値として保持するマップとして実装できます。 マップエントリをtrueに設定して値をセットに入れてから、単純なインデックス作成によってテストします。

.. code-block:: go

   attended := map[string]bool{
       "Ann": true,
       "Joe": true,
       ...
   }

   if attended[person] { // will be false if person is not in the map
       fmt.Println(person, "was at the meeting")
   }

存在しないエントリをゼロ値と区別する必要がある場合があります。 「UTC」のエントリはあるか、マップに存在せずゼロ値になるかのどちらかです。 多値を同時に割り当てる形式で区別できます。

.. code-block:: go

   var seconds int
   var ok bool
   seconds, ok = timeZone[tz]

自明な理由により、上記は「コンマOK」イディオムと呼ばれます。 この例では、tzのエントリが存在する場合、秒が適切に設定され、okがtrueになります。 そうでない場合、秒はゼロに設定され、okはfalseになります。 以下は、素晴らしいエラーメッセージと一緒に機能する関数です。

.. code-block:: go

   func offset(tz string) int {
       if seconds, ok := timeZone[tz]; ok {
           return seconds
       }
       log.Println("unknown time zone:", tz)
       return 0
   }

実際の値を気にせずにマップ内の存在をテストするには、値の変数として通常の変数の代わりに `空白の識別子 <#blank>`_ を使用できます。

.. code-block:: go

   _, present := timeZone[tz]

マップエントリを削除するには組み込み関数である **delete** を使用します。この組み込み関数の引数は、マップと削除するキーです。キーがマップに既に存在しない場合でも、これを行うのは安全です。

.. code-block:: go

   delete(timeZone, "PDT")  // Now on Standard Time

プリント
~~~~~~~~~~~~~~~~

Goの書式付きプリントでは、Cのprintfファミリーに似たスタイルが使用されますが、より機能的で一般的です。 関数は **fmt** パッケージに存在し、大文字の名前が付いています。``fmt.Printf`` , ``fmt.Fprintf`` , ``fmt.Sprintf`` などです。文字列関数( ``Sprintf``など) は、提供されたバッファを埋めるのではなく、文字列を返します。

書式文字列を提供する必要はありません。``Printf`` , ``Fprintf`` , ``Sprintf`` のそれぞれについて、別のペアの関数、たとえば ``Print`` と ``Println`` があります。 これらの関数はフォーマット文字列を取りませんが、代わりに各引数のデフォルトフォーマットを生成します。また ``Println`` 版は引数の間に空白を挿入し、出力に改行を追加します。しかし ``Print`` 版は隣り合うどちらの側のオペランドも ``string`` でない場合にのみ空白を追加します。 この例では、各行は同じ出力を生成します。

.. code-block:: go

   fmt.Printf("Hello %d\n", 23)
   fmt.Fprint(os.Stdout, "Hello ", 23, "\n")
   fmt.Println("Hello", 23)
   fmt.Println(fmt.Sprint("Hello ", 23))

フォーマットされたプリント関数 **fmt.Fprint** と類似する関数は **io.Writer** インターフェイスを実装するオブジェクトを最初の引数として受け取ります。変数 **os.Stdout** と **os.Stderr** はよく知られたインスタンスです。

ここからCと異なります。最初に **%d** などの数値形式は、符号付きまたは大きさのフラグを取りません。 代わりに、プリントルーチンは引数の型を使用してこれらのプロパティを決定します。

.. code-block:: go

   var x uint64 = 1<<64 - 1
   fmt.Printf("%d %x; %d %x\n", x, x, int64(x), int64(x))

上記は以下のように表示されます。

.. code-block:: go

   18446744073709551615 ffffffffffffffff; -1 -1

整数の小数など、デフォルトの変換だけが必要な場合は、すべてで用いることのできる形式 **%v** を使用できます。 結果はPrintとPrintlnが生成するものとまったく同じです。 さらに、その形式では、配列、スライス、構造体、マップなど、任意の値を出力できます。 これは、前のセクションで定義したタイムゾーンマップのprintステートメントです。

.. code-block:: go

   fmt.Printf("%v\n", timeZone)  // or just fmt.Println(timeZone)

以下のように表示されます。

.. code-block:: go

   map[CST:-21600 EST:-18000 MST:-25200 PST:-28800 UTC:0]

マップの場合、 **Printf** や周辺の関数は、キーの辞書順でソートして表示します。

構造体をプリントする場合、拡張された形式 **%+v** は構造体のフィールドに名前を付けて注釈を付けます。値があれば代替の形式 **%#v** は値を完全なGo構文でプリントします。

When printing a struct, the modified format **%+v** annotates the fields
of the structure with their names, and for any value the alternate
format **%#v** prints the value in full Go syntax.

.. code-block:: go

   type T struct {
       a int
       b float64
       c string
   }
   t := &T{ 7, -2.35, "abc\tdef" }
   fmt.Printf("%v\n", t)
   fmt.Printf("%+v\n", t)
   fmt.Printf("%#v\n", t)
   fmt.Printf("%#v\n", timeZone)

以下のように表示されます。

.. code-block:: go

   &{7 -2.35 abc   def}
   &{a:7 b:-2.35 c:abc     def}
   &main.T{a:7, b:-2.35, c:"abc\tdef"}
   map[string]int{"CST":-21600, "EST":-18000, "MST":-25200, "PST":-28800, "UTC":0}

（アンパサンド ``&`` に注意してください。）この引用符付き文字列形式は **string** 型または **[]byte** 型の値に適用される場合 **%q** でも使用できます。 別の書式 **%#q** は、可能であれば代わりにバッククォートを使用します。 ( **%q** 形式は、整数とルーンにも適用され、単一引用符で囲まれたルーン定数を生成します。）また **%x** は、文字列、バイト配列、バイトスライス、および整数で機能し、長い16進数文字列を生成し、スペースを使用します フォーマット( **%x** )では、バイト間にスペースを入れます。

もう1つの便利な形式は **%T** です。これは、値の型を出力します。

.. code-block:: go

   fmt.Printf("%T\n", timeZone)

以下のように表示されます。

.. code-block:: go

   map[string]int

デフォルトの書式を拡張したい場合 **String() string** のシグネチャを持つメソッドを型に定義する必要があります。以下のシンプルな型Tは以下のようになります。

.. code-block:: go

   func (t *T) String() string {
       return fmt.Sprintf("%d/%g/%q", t.a, t.b, t.c)
   }
   fmt.Printf("%v\n", t)

フォーマットの出力をします。

.. code-block:: go

   7/-2.35/"abc\tdef"

（T型と*T型でプリントする必要がある場合、Stringのレシーバーは値型でなければなりません。この例では、構造体型の方が効率的で慣用的であるため、ポインターを使用しました。 詳細については `ポインター vs 値のレシーバ <#pointers_vs_values>`_ をご覧ください。）

String() メソッドは、プリントルーチンが完全にリエントラントであり、このようにラップできるため、Sprintfを呼び出すことができます。 ただし、このアプローチについて理解する必要がある重要な詳細が1つあります。Sprintfを呼び出してStringメソッドを無期限に再帰する方法で実装しないでください。 これは、Sprintfの呼び出しがレシーバーを文字列として直接プリントしようとした場合に発生する可能性があり、その結果、メソッドが再度呼び出されます。 この例が示すように、これはよくある間違いです。

.. code-block:: go

   type MyString string

   func (m MyString) String() string {
       return fmt.Sprintf("MyString=%s", m) // Error: will recur forever.
   }

.. todo:: 詳細を示す

修正も簡単です。引数をメソッドを持たない基本的なstring型に変換します。

.. code-block:: go

   type MyString string
   func (m MyString) String() string {
       return fmt.Sprintf("MyString=%s", string(m)) // OK: note conversion.
   }

初期化セクションでは、この再帰を回避する別の手法を紹介します。

別のプリントするテクニックは、プリントルーチンの引数を別のルーチンに直接渡すことです。 Printfのシグネチャは、最後の引数に型 **...interface{}** を使用して、フォーマットの後に任意の数のパラメーター（任意の型）を表示できることを指定します。

.. code-block:: go

   func Printf(format string, v ...interface{}) (n int, err error) {

Printf関数内では v は **[]interface{}** 型の変数のように機能しますが、別の可変長引数を持つ関数に渡されると、通常の引数リストのように機能します。 上記で使用した ``log.Println`` 関数の実装を次に示します。 実際の書式設定のために、引数をfmt.Sprintlnに直接渡します。

.. code-block:: go

   // Println prints to the standard logger in the manner of fmt.Println.
   func Println(v ...interface{}) {
       std.Output(2, fmt.Sprintln(v...))  // Output takes parameters (int, string)
   }

Sprintlnへのネストされた呼び出しでvの後に **...** を記述して、vを引数のリストとして扱うようコンパイラーに指示します。それ以外の場合は、vを単一のスライス引数として渡します。

ここで説明した以外にも、プリントにはさらに多くの機能があります。詳細については、パッケージfmtのgodocドキュメントを参照してください。

ちなみに **...** パラメータは型として指定することができます。たとえば、整数のリストの最小のものを選択するmin関数の場合、パラメータの引数の型は **...int** です。

.. code-block:: go

   func Min(a ...int) int {
       min := int(^uint(0) >> 1)  // largest int
       for _, i := range a {
           if i < min {
               min = i
           }
       }
       return min
   }

Append
~~~~~~

これで **append** 組み込み関数の設計を説明するために必要な準備が揃いました。appendのシグネチャは、上記で説明したカスタムAppend関数とは異なります。概略的には、次のようなものです。

.. code-block:: go

   func append(slice []T, elements ...T) []T

ここで **T** は任意の型のプレースホルダーです。 Goでは、呼び出し側によって型Tが決定される関数を実際に書くことはできません。それがappendが組み込まれている理由です：コンパイラからのサポートが必要です。

**append** が実施するのは、要素をスライスの最後に追加して、結果のスライスを返すことです。カスタムのAppend関数と同様に、もとになる配列が変更される可能性があるため、結果を返す必要があります。この簡単な例を示します。

.. code-block:: go

   x := []int{1,2,3}
   x = append(x, 4, 5, 6)
   fmt.Println(x)

[1 2 3 4 5 6]をプリントします。したがって、appendはPrintfのように機能し、任意の数の引数を受け取ります。

しかしカスタムのAppendが行うことを行い、スライスにスライスを追加する場合はどうでしょうか。答えは簡単です。：上記のOutputの呼び出しで行ったように、呼び出す側で **...** を使用します。このスニペットは、上記のものと同じ出力を生成します。

.. code-block:: go

   x := []int{1,2,3}
   y := []int{4,5,6}
   x = append(x, y...)
   fmt.Println(x)

**...** の識別子がなければ、型が間違っているためコンパイルできません。 yは **int** 型ではありません。

初期化(Initialization)
--------------------------------------------------

見た目はCやC++の初期化と大きく異なりませんが、Goの初期化はより強力です。 初期化中に複雑な構造を構築でき、異なるパッケージ間であっても、初期化されたオブジェクト間の順序の問題は正しく処理されます。

定数
~~~~~~~~~~~~~~~~~

Constants in Go are just that—constant. They are created at compile
time, even when defined as locals in functions, and can only be numbers,
characters (runes), strings or booleans. Because of the compile-time
restriction, the expressions that define them must be constant
expressions, evaluatable by the compiler. For instance, **1<<3** is a
constant expression, while **math.Sin(math.Pi/4)** is not because the
function call to **math.Sin** needs to happen at run time.

In Go, enumerated constants are created using the **iota** enumerator.
Since **iota** can be part of an expression and expressions can be
implicitly repeated, it is easy to build intricate sets of values.

{{code "/doc/progs/eff_bytesize.go" \`/^type ByteSize/\` \`/^\)/`}}

The ability to attach a method such as **String** to any user-defined
type makes it possible for arbitrary values to format themselves
automatically for printing. Although you'll see it most often applied to
structs, this technique is also useful for scalar types such as
floating-point types like **ByteSize**.

{{code "/doc/progs/eff_bytesize.go" \`/^func.*ByteSize.*String/\`
\`/^}/`}}

The expression **YB** prints as **1.00YB**, while **ByteSize(1e13)**
prints as **9.09TB**.

The use here of **Sprintf** to implement **ByteSize**'s **String**
method is safe (avoids recurring indefinitely) not because of a
conversion but because it calls **Sprintf** with **%f**, which is not a
string format: **Sprintf** will only call the **String** method when it
wants a string, and **%f** wants a floating-point value.

変数
~~~~~~~~~~~~~~~~~

Variables can be initialized just like constants but the initializer can
be a general expression computed at run time.

.. code-block:: go

   var (
       home   = os.Getenv("HOME")
       user   = os.Getenv("USER")
       gopath = os.Getenv("GOPATH")
   )

.. _init:

init関数
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Finally, each source file can define its own niladic **init** function
to set up whatever state is required. (Actually each file can have
multiple **init** functions.) And finally means finally: **init** is
called after all the variable declarations in the package have evaluated
their initializers, and those are evaluated only after all the imported
packages have been initialized.

Besides initializations that cannot be expressed as declarations, a
common use of **init** functions is to verify or repair correctness of
the program state before real execution begins.

.. code-block:: go

   func init() {
       if user == "" {
           log.Fatal("$USER not set")
       }
       if home == "" {
           home = "/home/" + user
       }
       if gopath == "" {
           gopath = home + "/go"
       }
       // gopath may be overridden by --gopath flag on command line.
       flag.StringVar(&gopath, "gopath", gopath, "override default GOPATH")
   }

メソッド
----------------

.. _pointers_vs_values:

ポインター vs 値
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

As we saw with **ByteSize**, methods can be defined for any named type
(except a pointer or an interface); the receiver does not have to be a
struct.

In the discussion of slices above, we wrote an **Append** function. We
can define it as a method on slices instead. To do this, we first
declare a named type to which we can bind the method, and then make the
receiver for the method a value of that type.

.. code-block:: go

   type ByteSlice []byte

   func (slice ByteSlice) Append(data []byte) []byte {
       // Body exactly the same as the Append function defined above.
   }

This still requires the method to return the updated slice. We can
eliminate that clumsiness by redefining the method to take a *pointer*
to a **ByteSlice** as its receiver, so the method can overwrite the
caller's slice.

.. code-block:: go

   func (p *ByteSlice) Append(data []byte) {
       slice := *p
       // Body as above, without the return.
       *p = slice
   }

In fact, we can do even better. If we modify our function so it looks
like a standard **Write** method, like this,

.. code-block:: go

   func (p *ByteSlice) Write(data []byte) (n int, err error) {
       slice := *p
       // Again as above.
       *p = slice
       return len(data), nil
   }

then the type ***ByteSlice** satisfies the standard interface
**io.Writer**, which is handy. For instance, we can print into one.

.. code-block:: go

       var b ByteSlice
       fmt.Fprintf(&b, "This hour has %d days\n", 7)

We pass the address of a **ByteSlice** because only ***ByteSlice**
satisfies **io.Writer**. The rule about pointers vs. values for
receivers is that value methods can be invoked on pointers and values,
but pointer methods can only be invoked on pointers.

This rule arises because pointer methods can modify the receiver;
invoking them on a value would cause the method to receive a copy of the
value, so any modifications would be discarded. The language therefore
disallows this mistake. There is a handy exception, though. When the
value is addressable, the language takes care of the common case of
invoking a pointer method on a value by inserting the address operator
automatically. In our example, the variable **b** is addressable, so we
can call its **Write** method with just **b.Write**. The compiler will
rewrite that to **(&b).Write** for us.

By the way, the idea of using **Write** on a slice of bytes is central
to the implementation of **bytes.Buffer**.

.. _interfaces_and_types:

インターフェースとその他の型
--------------------------------------------------

インターフェース
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Interfaces in Go provide a way to specify the behavior of an object: if
something can do *this*, then it can be used *here*. We've seen a couple
of simple examples already; custom printers can be implemented by a
**String** method while **Fprintf** can generate output to anything with
a **Write** method. Interfaces with only one or two methods are common
in Go code, and are usually given a name derived from the method, such
as **io.Writer** for something that implements **Write**.

A type can implement multiple interfaces. For instance, a collection can
be sorted by the routines in package **sort** if it implements
**sort.Interface**, which contains **Len()**, **Less(i, j int) bool**,
and **Swap(i, j int)**, and it could also have a custom formatter. In
this contrived example **Sequence** satisfies both.

{{code "/doc/progs/eff_sequence.go" \`/^type/\` "$"}}

Conversions
~~~~~~~~~~~~~~~~~~~

The **String** method of **Sequence** is recreating the work that
**Sprint** already does for slices. (It also has complexity O(N²), which
is poor.) We can share the effort (and also speed it up) if we convert
the **Sequence** to a plain **[]int** before calling **Sprint**.

.. code-block:: go

   func (s Sequence) String() string {
       s = s.Copy()
       sort.Sort(s)
       return fmt.Sprint([]int(s))
   }

This method is another example of the conversion technique for calling
**Sprintf** safely from a **String** method. Because the two types
(**Sequence** and **[]int**) are the same if we ignore the type name,
it's legal to convert between them. The conversion doesn't create a new
value, it just temporarily acts as though the existing value has a new
type. (There are other legal conversions, such as from integer to
floating point, that do create a new value.)

It's an idiom in Go programs to convert the type of an expression to
access a different set of methods. As an example, we could use the
existing type **sort.IntSlice** to reduce the entire example to this:

.. code-block:: go

   type Sequence []int

   // Method for printing - sorts the elements before printing
   func (s Sequence) String() string {
       s = s.Copy()
       sort.IntSlice(s).Sort()
       return fmt.Sprint([]int(s))
   }

Now, instead of having **Sequence** implement multiple interfaces
(sorting and printing), we're using the ability of a data item to be
converted to multiple types (**Sequence**, **sort.IntSlice** and
**[]int**), each of which does some part of the job. That's more unusual
in practice but can be effective.

.. _interface_conversions:

Interface conversions and type assertions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Type switches <#type_switch>`__ are a form of conversion: they take an
interface and, for each case in the switch, in a sense convert it to the
type of that case. Here's a simplified version of how the code under
**fmt.Printf** turns a value into a string using a type switch. If it's
already a string, we want the actual string value held by the interface,
while if it has a **String** method we want the result of calling the
method.

.. code-block:: go

   type Stringer interface {
       String() string
   }

   var value interface{} // Value provided by caller.
   switch str := value.(type) {
   case string:
       return str
   case Stringer:
       return str.String()
   }

The first case finds a concrete value; the second converts the interface
into another interface. It's perfectly fine to mix types this way.

What if there's only one type we care about? If we know the value holds
a **string** and we just want to extract it? A one-case type switch
would do, but so would a *type assertion*. A type assertion takes an
interface value and extracts from it a value of the specified explicit
type. The syntax borrows from the clause opening a type switch, but with
an explicit type rather than the **type** keyword:

.. code-block:: go

   value.(typeName)

and the result is a new value with the static type **typeName**. That
type must either be the concrete type held by the interface, or a second
interface type that the value can be converted to. To extract the string
we know is in the value, we could write:

.. code-block:: go

   str := value.(string)

But if it turns out that the value does not contain a string, the
program will crash with a run-time error. To guard against that, use the
"comma, ok" idiom to test, safely, whether the value is a string:

.. code-block:: go

   str, ok := value.(string)
   if ok {
       fmt.Printf("string value is: %q\n", str)
   } else {
       fmt.Printf("value is not a string\n")
   }

If the type assertion fails, **str** will still exist and be of type
string, but it will have the zero value, an empty string.

As an illustration of the capability, here's an **if**-**else**
statement that's equivalent to the type switch that opened this section.

.. code-block:: go

   if str, ok := value.(string); ok {
       return str
   } else if str, ok := value.(Stringer); ok {
       return str.String()
   }

Generality
~~~~~~~~~~~~~~~~~~

If a type exists only to implement an interface and will never have
exported methods beyond that interface, there is no need to export the
type itself. Exporting just the interface makes it clear the value has
no interesting behavior beyond what is described in the interface. It
also avoids the need to repeat the documentation on every instance of a
common method.

In such cases, the constructor should return an interface value rather
than the implementing type. As an example, in the hash libraries both
**crc32.NewIEEE** and **adler32.New** return the interface type
**hash.Hash32**. Substituting the CRC-32 algorithm for Adler-32 in a Go
program requires only changing the constructor call; the rest of the
code is unaffected by the change of algorithm.

A similar approach allows the streaming cipher algorithms in the various
**crypto** packages to be separated from the block ciphers they chain
together. The **Block** interface in the **crypto/cipher** package
specifies the behavior of a block cipher, which provides encryption of a
single block of data. Then, by analogy with the **bufio** package,
cipher packages that implement this interface can be used to construct
streaming ciphers, represented by the **Stream** interface, without
knowing the details of the block encryption.

The **crypto/cipher** interfaces look like this:

.. code-block:: go

   type Block interface {
       BlockSize() int
       Encrypt(dst, src []byte)
       Decrypt(dst, src []byte)
   }

   type Stream interface {
       XORKeyStream(dst, src []byte)
   }

Here's the definition of the counter mode (CTR) stream, which turns a
block cipher into a streaming cipher; notice that the block cipher's
details are abstracted away:

.. code-block:: go

   // NewCTR returns a Stream that encrypts/decrypts using the given Block in
   // counter mode. The length of iv must be the same as the Block's block size.
   func NewCTR(block Block, iv []byte) Stream

**NewCTR** applies not just to one specific encryption algorithm and
data source but to any implementation of the **Block** interface and any
**Stream**. Because they return interface values, replacing CTR
encryption with other encryption modes is a localized change. The
constructor calls must be edited, but because the surrounding code must
treat the result only as a **Stream**, it won't notice the difference.

.. _interface_methods:

インターフェースとメソッド
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Since almost anything can have methods attached, almost anything can
satisfy an interface. One illustrative example is in the **http**
package, which defines the **Handler** interface. Any object that
implements **Handler** can serve HTTP requests.

.. code-block:: go

   type Handler interface {
       ServeHTTP(ResponseWriter, *Request)
   }

**ResponseWriter** is itself an interface that provides access to the
methods needed to return the response to the client. Those methods
include the standard **Write** method, so an **http.ResponseWriter** can
be used wherever an **io.Writer** can be used. **Request** is a struct
containing a parsed representation of the request from the client.

For brevity, let's ignore POSTs and assume HTTP requests are always
GETs; that simplification does not affect the way the handlers are set
up. Here's a trivial but complete implementation of a handler to count
the number of times the page is visited.

.. code-block:: go

   // Simple counter server.
   type Counter struct {
       n int
   }

   func (ctr *Counter) ServeHTTP(w http.ResponseWriter, req *http.Request) {
       ctr.n++
       fmt.Fprintf(w, "counter = %d\n", ctr.n)
   }

(Keeping with our theme, note how **Fprintf** can print to an
**http.ResponseWriter**.) For reference, here's how to attach such a
server to a node on the URL tree.

.. code-block:: go

   import "net/http"
   ...
   ctr := new(Counter)
   http.Handle("/counter", ctr)

But why make **Counter** a struct? An integer is all that's needed. (The
receiver needs to be a pointer so the increment is visible to the
caller.)

.. code-block:: go

   // Simpler counter server.
   type Counter int

   func (ctr *Counter) ServeHTTP(w http.ResponseWriter, req *http.Request) {
       *ctr++
       fmt.Fprintf(w, "counter = %d\n", *ctr)
   }

What if your program has some internal state that needs to be notified
that a page has been visited? Tie a channel to the web page.

.. code-block:: go

   // A channel that sends a notification on each visit.
   // (Probably want the channel to be buffered.)
   type Chan chan *http.Request

   func (ch Chan) ServeHTTP(w http.ResponseWriter, req *http.Request) {
       ch <- req
       fmt.Fprint(w, "notification sent")
   }

Finally, let's say we wanted to present on **/args** the arguments used
when invoking the server binary. It's easy to write a function to print
the arguments.

.. code-block:: go

   func ArgServer() {
       fmt.Println(os.Args)
   }

How do we turn that into an HTTP server? We could make **ArgServer** a
method of some type whose value we ignore, but there's a cleaner way.
Since we can define a method for any type except pointers and
interfaces, we can write a method for a function. The **http** package
contains this code:

.. code-block:: go

   // The HandlerFunc type is an adapter to allow the use of
   // ordinary functions as HTTP handlers.  If f is a function
   // with the appropriate signature, HandlerFunc(f) is a
   // Handler object that calls f.
   type HandlerFunc func(ResponseWriter, *Request)

   // ServeHTTP calls f(w, req).
   func (f HandlerFunc) ServeHTTP(w ResponseWriter, req *Request) {
       f(w, req)
   }

**HandlerFunc** is a type with a method, **ServeHTTP**, so values of
that type can serve HTTP requests. Look at the implementation of the
method: the receiver is a function, **f**, and the method calls **f**.
That may seem odd but it's not that different from, say, the receiver
being a channel and the method sending on the channel.

To make **ArgServer** into an HTTP server, we first modify it to have
the right signature.

.. code-block:: go

   // Argument server.
   func ArgServer(w http.ResponseWriter, req *http.Request) {
       fmt.Fprintln(w, os.Args)
   }

**ArgServer** now has same signature as **HandlerFunc**, so it can be
converted to that type to access its methods, just as we converted
**Sequence** to **IntSlice** to access **IntSlice.Sort**. The code to
set it up is concise:

.. code-block:: go

   http.Handle("/args", http.HandlerFunc(ArgServer))

When someone visits the page **/args**, the handler installed at that
page has value **ArgServer** and type **HandlerFunc**. The HTTP server
will invoke the method **ServeHTTP** of that type, with **ArgServer** as
the receiver, which will in turn call **ArgServer** (via the invocation
**f(w, req)** inside **HandlerFunc.ServeHTTP**). The arguments will then
be displayed.

In this section we have made an HTTP server from a struct, an integer, a
channel, and a function, all because interfaces are just sets of
methods, which can be defined for (almost) any type.

.. _blank:

空白の識別子
------------------------------------

We've mentioned the blank identifier a couple of times now, in the
context of **`for** **range** loops <#for>`__ and `maps <#maps>`__. The
blank identifier can be assigned or declared with any value of any type,
with the value discarded harmlessly. It's a bit like writing to the Unix
**/dev/null** file: it represents a write-only value to be used as a
place-holder where a variable is needed but the actual value is
irrelevant. It has uses beyond those we've seen already.

.. _blank_assign:

The blank identifier in multiple assignment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The use of a blank identifier in a **for** **range** loop is a special
case of a general situation: multiple assignment.

If an assignment requires multiple values on the left side, but one of
the values will not be used by the program, a blank identifier on the
left-hand-side of the assignment avoids the need to create a dummy
variable and makes it clear that the value is to be discarded. For
instance, when calling a function that returns a value and an error, but
only the error is important, use the blank identifier to discard the
irrelevant value.

.. code-block:: go

   if _, err := os.Stat(path); os.IsNotExist(err) {
       fmt.Printf("%s does not exist\n", path)
   }

Occasionally you'll see code that discards the error value in order to
ignore the error; this is terrible practice. Always check error returns;
they're provided for a reason.

.. code-block:: go

   // Bad! This code will crash if path does not exist.
   fi, _ := os.Stat(path)
   if fi.IsDir() {
       fmt.Printf("%s is a directory\n", path)
   }

.. _blank_unused:

Unused imports and variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

It is an error to import a package or to declare a variable without
using it. Unused imports bloat the program and slow compilation, while a
variable that is initialized but not used is at least a wasted
computation and perhaps indicative of a larger bug. When a program is
under active development, however, unused imports and variables often
arise and it can be annoying to delete them just to have the compilation
proceed, only to have them be needed again later. The blank identifier
provides a workaround.

This half-written program has two unused imports (**fmt** and **io**)
and an unused variable (**fd**), so it will not compile, but it would be
nice to see if the code so far is correct.

{{code "/doc/progs/eff_unused1.go" \`/package/\` \`$`}}

To silence complaints about the unused imports, use a blank identifier
to refer to a symbol from the imported package. Similarly, assigning the
unused variable **fd** to the blank identifier will silence the unused
variable error. This version of the program does compile.

{{code "/doc/progs/eff_unused2.go" \`/package/\` \`$`}}

By convention, the global declarations to silence import errors should
come right after the imports and be commented, both to make them easy to
find and as a reminder to clean things up later.

.. _blank_import:

Import for side effect
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

An unused import like **fmt** or **io** in the previous example should
eventually be used or removed: blank assignments identify code as a work
in progress. But sometimes it is useful to import a package only for its
side effects, without any explicit use. For example, during its **init**
function, the **net/http/pprof** package registers HTTP handlers that
provide debugging information. It has an exported API, but most clients
need only the handler registration and access the data through a web
page. To import the package only for its side effects, rename the
package to the blank identifier:

.. code-block:: go

   import _ "net/http/pprof"

This form of import makes clear that the package is being imported for
its side effects, because there is no other possible use of the package:
in this file, it doesn't have a name. (If it did, and we didn't use that
name, the compiler would reject the program.)

.. _blank_implements:

Interface checks
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

As we saw in the discussion of `interfaces <#interfaces_and_types>`__
above, a type need not declare explicitly that it implements an
interface. Instead, a type implements the interface just by implementing
the interface's methods. In practice, most interface conversions are
static and therefore checked at compile time. For example, passing an
***os.File** to a function expecting an **io.Reader** will not compile
unless ***os.File** implements the **io.Reader** interface.

Some interface checks do happen at run-time, though. One instance is in
the **encoding/json** package, which defines a **Marshaler** interface.
When the JSON encoder receives a value that implements that interface,
the encoder invokes the value's marshaling method to convert it to JSON
instead of doing the standard conversion. The encoder checks this
property at run time with a `type assertion <#interface_conversions>`__
like:

.. code-block:: go

   m, ok := val.(json.Marshaler)

If it's necessary only to ask whether a type implements an interface,
without actually using the interface itself, perhaps as part of an error
check, use the blank identifier to ignore the type-asserted value:

.. code-block:: go

   if _, ok := val.(json.Marshaler); ok {
       fmt.Printf("value %v of type %T implements json.Marshaler\n", val, val)
   }

One place this situation arises is when it is necessary to guarantee
within the package implementing the type that it actually satisfies the
interface. If a type—for example, **json.RawMessage**—needs a custom
JSON representation, it should implement **json.Marshaler**, but there
are no static conversions that would cause the compiler to verify this
automatically. If the type inadvertently fails to satisfy the interface,
the JSON encoder will still work, but will not use the custom
implementation. To guarantee that the implementation is correct, a
global declaration using the blank identifier can be used in the
package:

.. code-block:: go

   var _ json.Marshaler = (*RawMessage)(nil)

In this declaration, the assignment involving a conversion of a
***RawMessage** to a **Marshaler** requires that ***RawMessage**
implements **Marshaler**, and that property will be checked at compile
time. Should the **json.Marshaler** interface change, this package will
no longer compile and we will be on notice that it needs to be updated.

The appearance of the blank identifier in this construct indicates that
the declaration exists only for the type checking, not to create a
variable. Don't do this for every type that satisfies an interface,
though. By convention, such declarations are only used when there are no
static conversions already present in the code, which is a rare event.

埋め込み
-----------------

Go does not provide the typical, type-driven notion of subclassing, but
it does have the ability to “borrow” pieces of an implementation by
*embedding* types within a struct or interface.

Interface embedding is very simple. We've mentioned the **io.Reader**
and **io.Writer** interfaces before; here are their definitions.

.. code-block:: go

   type Reader interface {
       Read(p []byte) (n int, err error)
   }

   type Writer interface {
       Write(p []byte) (n int, err error)
   }

The **io** package also exports several other interfaces that specify
objects that can implement several such methods. For instance, there is
**io.ReadWriter**, an interface containing both **Read** and **Write**.
We could specify **io.ReadWriter** by listing the two methods
explicitly, but it's easier and more evocative to embed the two
interfaces to form the new one, like this:

.. code-block:: go

   // ReadWriter is the interface that combines the Reader and Writer interfaces.
   type ReadWriter interface {
       Reader
       Writer
   }

This says just what it looks like: A **ReadWriter** can do what a
**Reader** does *and* what a **Writer** does; it is a union of the
embedded interfaces (which must be disjoint sets of methods). Only
interfaces can be embedded within interfaces.

The same basic idea applies to structs, but with more far-reaching
implications. The **bufio** package has two struct types,
**bufio.Reader** and **bufio.Writer**, each of which of course
implements the analogous interfaces from package **io**. And **bufio**
also implements a buffered reader/writer, which it does by combining a
reader and a writer into one struct using embedding: it lists the types
within the struct but does not give them field names.

.. code-block:: go

   // ReadWriter stores pointers to a Reader and a Writer.
   // It implements io.ReadWriter.
   type ReadWriter struct {
       *Reader  // *bufio.Reader
       *Writer  // *bufio.Writer
   }

The embedded elements are pointers to structs and of course must be
initialized to point to valid structs before they can be used. The
**ReadWriter** struct could be written as

.. code-block:: go

   type ReadWriter struct {
       reader *Reader
       writer *Writer
   }

but then to promote the methods of the fields and to satisfy the **io**
interfaces, we would also need to provide forwarding methods, like this:

.. code-block:: go

   func (rw *ReadWriter) Read(p []byte) (n int, err error) {
       return rw.reader.Read(p)
   }

By embedding the structs directly, we avoid this bookkeeping. The
methods of embedded types come along for free, which means that
**bufio.ReadWriter** not only has the methods of **bufio.Reader** and
**bufio.Writer**, it also satisfies all three interfaces: **io.Reader**,
**io.Writer**, and **io.ReadWriter**.

There's an important way in which embedding differs from subclassing.
When we embed a type, the methods of that type become methods of the
outer type, but when they are invoked the receiver of the method is the
inner type, not the outer one. In our example, when the **Read** method
of a **bufio.ReadWriter** is invoked, it has exactly the same effect as
the forwarding method written out above; the receiver is the **reader**
field of the **ReadWriter**, not the **ReadWriter** itself.

Embedding can also be a simple convenience. This example shows an
embedded field alongside a regular, named field.

.. code-block:: go

   type Job struct {
       Command string
       *log.Logger
   }

The **Job** type now has the **Print**, **Printf**, **Println** and
other methods of ***log.Logger**. We could have given the **Logger** a
field name, of course, but it's not necessary to do so. And now, once
initialized, we can log to the **Job**:

.. code-block:: go

   job.Println("starting now...")

The **Logger** is a regular field of the **Job** struct, so we can
initialize it in the usual way inside the constructor for **Job**, like
this,

.. code-block:: go

   func NewJob(command string, logger *log.Logger) *Job {
       return &Job{command, logger}
   }

or with a composite literal,

.. code-block:: go

   job := &Job{command, log.New(os.Stderr, "Job: ", log.Ldate)}

If we need to refer to an embedded field directly, the type name of the
field, ignoring the package qualifier, serves as a field name, as it did
in the **Read** method of our **ReadWriter** struct. Here, if we needed
to access the ***log.Logger** of a **Job** variable **job**, we would
write **job.Logger**, which would be useful if we wanted to refine the
methods of **Logger**.

.. code-block:: go

   func (job *Job) Printf(format string, args ...interface{}) {
       job.Logger.Printf("%q: %s", job.Command, fmt.Sprintf(format, args...))
   }

Embedding types introduces the problem of name conflicts but the rules
to resolve them are simple. First, a field or method **X** hides any
other item **X** in a more deeply nested part of the type. If
**log.Logger** contained a field or method called **Command**, the
**Command** field of **Job** would dominate it.

Second, if the same name appears at the same nesting level, it is
usually an error; it would be erroneous to embed **log.Logger** if the
**Job** struct contained another field or method called **Logger**.
However, if the duplicate name is never mentioned in the program outside
the type definition, it is OK. This qualification provides some
protection against changes made to types embedded from outside; there is
no problem if a field is added that conflicts with another field in
another subtype if neither field is ever used.

並行処理
-------------------

.. _sharing:

通信による共有
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Concurrent programming is a large topic and there is space only for some
Go-specific highlights here.

Concurrent programming in many environments is made difficult by the
subtleties required to implement correct access to shared variables. Go
encourages a different approach in which shared values are passed around
on channels and, in fact, never actively shared by separate threads of
execution. Only one goroutine has access to the value at any given time.
Data races cannot occur, by design. To encourage this way of thinking we
have reduced it to a slogan:

   Do not communicate by sharing memory; instead, share memory by
   communicating.

This approach can be taken too far. Reference counts may be best done by
putting a mutex around an integer variable, for instance. But as a
high-level approach, using channels to control access makes it easier to
write clear, correct programs.

One way to think about this model is to consider a typical
single-threaded program running on one CPU. It has no need for
synchronization primitives. Now run another such instance; it too needs
no synchronization. Now let those two communicate; if the communication
is the synchronizer, there's still no need for other synchronization.
Unix pipelines, for example, fit this model perfectly. Although Go's
approach to concurrency originates in Hoare's Communicating Sequential
Processes (CSP), it can also be seen as a type-safe generalization of
Unix pipes.

ゴルーチン
~~~~~~~~~~~~~~~~~~

They're called *goroutines* because the existing terms—threads,
coroutines, processes, and so on—convey inaccurate connotations. A
goroutine has a simple model: it is a function executing concurrently
with other goroutines in the same address space. It is lightweight,
costing little more than the allocation of stack space. And the stacks
start small, so they are cheap, and grow by allocating (and freeing)
heap storage as required.

Goroutines are multiplexed onto multiple OS threads so if one should
block, such as while waiting for I/O, others continue to run. Their
design hides many of the complexities of thread creation and management.

Prefix a function or method call with the **go** keyword to run the call
in a new goroutine. When the call completes, the goroutine exits,
silently. (The effect is similar to the Unix shell's **&** notation for
running a command in the background.)

.. code-block:: go

   go list.Sort()  // run list.Sort concurrently; don't wait for it.

A function literal can be handy in a goroutine invocation.

.. code-block:: go

   func Announce(message string, delay time.Duration) {
       go func() {
           time.Sleep(delay)
           fmt.Println(message)
       }()  // Note the parentheses - must call the function.
   }

In Go, function literals are closures: the implementation makes sure the
variables referred to by the function survive as long as they are
active.

These examples aren't too practical because the functions have no way of
signaling completion. For that, we need channels.

チャンネル
~~~~~~~~~~~~~~~~~~

Like maps, channels are allocated with **make**, and the resulting value
acts as a reference to an underlying data structure. If an optional
integer parameter is provided, it sets the buffer size for the channel.
The default is zero, for an unbuffered or synchronous channel.

.. code-block:: go

   ci := make(chan int)            // unbuffered channel of integers
   cj := make(chan int, 0)         // unbuffered channel of integers
   cs := make(chan *os.File, 100)  // buffered channel of pointers to Files

Unbuffered channels combine communication—the exchange of a value—with
synchronization—guaranteeing that two calculations (goroutines) are in a
known state.

There are lots of nice idioms using channels. Here's one to get us
started. In the previous section we launched a sort in the background. A
channel can allow the launching goroutine to wait for the sort to
complete.

.. code-block:: go

   c := make(chan int)  // Allocate a channel.
   // Start the sort in a goroutine; when it completes, signal on the channel.
   go func() {
       list.Sort()
       c <- 1  // Send a signal; value does not matter.
   }()
   doSomethingForAWhile()
   <-c   // Wait for sort to finish; discard sent value.

Receivers always block until there is data to receive. If the channel is
unbuffered, the sender blocks until the receiver has received the value.
If the channel has a buffer, the sender blocks only until the value has
been copied to the buffer; if the buffer is full, this means waiting
until some receiver has retrieved a value.

A buffered channel can be used like a semaphore, for instance to limit
throughput. In this example, incoming requests are passed to **handle**,
which sends a value into the channel, processes the request, and then
receives a value from the channel to ready the “semaphore” for the next
consumer. The capacity of the channel buffer limits the number of
simultaneous calls to **process**.

.. code-block:: go

   var sem = make(chan int, MaxOutstanding)

   func handle(r *Request) {
       sem <- 1    // Wait for active queue to drain.
       process(r)  // May take a long time.
       <-sem       // Done; enable next request to run.
   }

   func Serve(queue chan *Request) {
       for {
           req := <-queue
           go handle(req)  // Don't wait for handle to finish.
       }
   }

Once **MaxOutstanding** handlers are executing **process**, any more
will block trying to send into the filled channel buffer, until one of
the existing handlers finishes and receives from the buffer.

This design has a problem, though: **Serve** creates a new goroutine for
every incoming request, even though only **MaxOutstanding** of them can
run at any moment. As a result, the program can consume unlimited
resources if the requests come in too fast. We can address that
deficiency by changing **Serve** to gate the creation of the goroutines.
Here's an obvious solution, but beware it has a bug we'll fix
subsequently:

.. code-block:: go

   func Serve(queue chan *Request) {
       for req := range queue {
           sem <- 1
           go func() {
               process(req) // Buggy; see explanation below.
               <-sem
           }()
       }
   }

The bug is that in a Go **for** loop, the loop variable is reused for
each iteration, so the **req** variable is shared across all goroutines.
That's not what we want. We need to make sure that **req** is unique for
each goroutine. Here's one way to do that, passing the value of **req**
as an argument to the closure in the goroutine:

.. code-block:: go

   func Serve(queue chan *Request) {
       for req := range queue {
           sem <- 1
           go func(req *Request) {
               process(req)
               <-sem
           }(req)
       }
   }

Compare this version with the previous to see the difference in how the
closure is declared and run. Another solution is just to create a new
variable with the same name, as in this example:

.. code-block:: go

   func Serve(queue chan *Request) {
       for req := range queue {
           req := req // Create new instance of req for the goroutine.
           sem <- 1
           go func() {
               process(req)
               <-sem
           }()
       }
   }

It may seem odd to write

.. code-block:: go

   req := req

but it's legal and idiomatic in Go to do this. You get a fresh version
of the variable with the same name, deliberately shadowing the loop
variable locally but unique to each goroutine.

Going back to the general problem of writing the server, another
approach that manages resources well is to start a fixed number of
**handle** goroutines all reading from the request channel. The number
of goroutines limits the number of simultaneous calls to **process**.
This **Serve** function also accepts a channel on which it will be told
to exit; after launching the goroutines it blocks receiving from that
channel.

.. code-block:: go

   func handle(queue chan *Request) {
       for r := range queue {
           process(r)
       }
   }

   func Serve(clientRequests chan *Request, quit chan bool) {
       // Start handlers
       for i := 0; i < MaxOutstanding; i++ {
           go handle(clientRequests)
       }
       <-quit  // Wait to be told to exit.
   }

.. _chan_of_chan:

Channels of channels
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

One of the most important properties of Go is that a channel is a
first-class value that can be allocated and passed around like any
other. A common use of this property is to implement safe, parallel
demultiplexing.

In the example in the previous section, **handle** was an idealized
handler for a request but we didn't define the type it was handling. If
that type includes a channel on which to reply, each client can provide
its own path for the answer. Here's a schematic definition of type
**Request**.

.. code-block:: go

   type Request struct {
       args        []int
       f           func([]int) int
       resultChan  chan int
   }

The client provides a function and its arguments, as well as a channel
inside the request object on which to receive the answer.

.. code-block:: go

   func sum(a []int) (s int) {
       for _, v := range a {
           s += v
       }
       return
   }

   request := &Request{[]int{3, 4, 5}, sum, make(chan int)}
   // Send request
   clientRequests <- request
   // Wait for response.
   fmt.Printf("answer: %d\n", <-request.resultChan)

On the server side, the handler function is the only thing that changes.

.. code-block:: go

   func handle(queue chan *Request) {
       for req := range queue {
           req.resultChan <- req.f(req.args)
       }
   }

There's clearly a lot more to do to make it realistic, but this code is
a framework for a rate-limited, parallel, non-blocking RPC system, and
there's not a mutex in sight.

.. _parallel:

Parallelization
~~~~~~~~~~~~~~~~~~~~~~~

Another application of these ideas is to parallelize a calculation
across multiple CPU cores. If the calculation can be broken into
separate pieces that can execute independently, it can be parallelized,
with a channel to signal when each piece completes.

Let's say we have an expensive operation to perform on a vector of
items, and that the value of the operation on each item is independent,
as in this idealized example.

.. code-block:: go

   type Vector []float64

   // Apply the operation to v[i], v[i+1] ... up to v[n-1].
   func (v Vector) DoSome(i, n int, u Vector, c chan int) {
       for ; i < n; i++ {
           v[i] += u.Op(v[i])
       }
       c <- 1    // signal that this piece is done
   }

We launch the pieces independently in a loop, one per CPU. They can
complete in any order but it doesn't matter; we just count the
completion signals by draining the channel after launching all the
goroutines.

.. code-block:: go

   const numCPU = 4 // number of CPU cores

   func (v Vector) DoAll(u Vector) {
       c := make(chan int, numCPU)  // Buffering optional but sensible.
       for i := 0; i < numCPU; i++ {
           go v.DoSome(i*len(v)/numCPU, (i+1)*len(v)/numCPU, u, c)
       }
       // Drain the channel.
       for i := 0; i < numCPU; i++ {
           <-c    // wait for one task to complete
       }
       // All done.
   }

Rather than create a constant value for numCPU, we can ask the runtime
what value is appropriate. The function **runtime.NumCPU** returns the
number of hardware CPU cores in the machine, so we could write

.. code-block:: go

   var numCPU = runtime.NumCPU()

There is also a function **runtime.GOMAXPROCS**, which reports (or sets)
the user-specified number of cores that a Go program can have running
simultaneously. It defaults to the value of **runtime.NumCPU** but can
be overridden by setting the similarly named shell environment variable
or by calling the function with a positive number. Calling it with zero
just queries the value. Therefore if we want to honor the user's
resource request, we should write

.. code-block:: go

   var numCPU = runtime.GOMAXPROCS(0)

Be sure not to confuse the ideas of concurrency—structuring a program as
independently executing components—and parallelism—executing
calculations in parallel for efficiency on multiple CPUs. Although the
concurrency features of Go can make some problems easy to structure as
parallel computations, Go is a concurrent language, not a parallel one,
and not all parallelization problems fit Go's model. For a discussion of
the distinction, see the talk cited in `this blog
post <//blog.golang.org/2013/01/concurrency-is-not-parallelism.html>`__.

.. _leaky_buffer:

A leaky buffer
~~~~~~~~~~~~~~~~~~~~~~

The tools of concurrent programming can even make non-concurrent ideas
easier to express. Here's an example abstracted from an RPC package. The
client goroutine loops receiving data from some source, perhaps a
network. To avoid allocating and freeing buffers, it keeps a free list,
and uses a buffered channel to represent it. If the channel is empty, a
new buffer gets allocated. Once the message buffer is ready, it's sent
to the server on **serverChan**.

.. code-block:: go

   var freeList = make(chan *Buffer, 100)
   var serverChan = make(chan *Buffer)

   func client() {
       for {
           var b *Buffer
           // Grab a buffer if available; allocate if not.
           select {
           case b = <-freeList:
               // Got one; nothing more to do.
           default:
               // None free, so allocate a new one.
               b = new(Buffer)
           }
           load(b)              // Read next message from the net.
           serverChan <- b      // Send to server.
       }
   }

The server loop receives each message from the client, processes it, and
returns the buffer to the free list.

.. code-block:: go

   func server() {
       for {
           b := <-serverChan    // Wait for work.
           process(b)
           // Reuse buffer if there's room.
           select {
           case freeList <- b:
               // Buffer on free list; nothing more to do.
           default:
               // Free list full, just carry on.
           }
       }
   }

The client attempts to retrieve a buffer from **freeList**; if none is
available, it allocates a fresh one. The server's send to **freeList**
puts **b** back on the free list unless the list is full, in which case
the buffer is dropped on the floor to be reclaimed by the garbage
collector. (The **default** clauses in the **select** statements execute
when no other case is ready, meaning that the **selects** never block.)
This implementation builds a leaky bucket free list in just a few lines,
relying on the buffered channel and the garbage collector for
bookkeeping.

エラー
------

Library routines must often return some sort of error indication to the
caller. As mentioned earlier, Go's multivalue return makes it easy to
return a detailed error description alongside the normal return value.
It is good style to use this feature to provide detailed error
information. For example, as we'll see, **os.Open** doesn't just return
a **nil** pointer on failure, it also returns an error value that
describes what went wrong.

By convention, errors have type **error**, a simple built-in interface.

.. code-block:: go

   type error interface {
       Error() string
   }

A library writer is free to implement this interface with a richer model
under the covers, making it possible not only to see the error but also
to provide some context. As mentioned, alongside the usual ***os.File**
return value, **os.Open** also returns an error value. If the file is
opened successfully, the error will be **nil**, but when there is a
problem, it will hold an **os.PathError**:

.. code-block:: go

   // PathError records an error and the operation and
   // file path that caused it.
   type PathError struct {
       Op string    // "open", "unlink", etc.
       Path string  // The associated file.
       Err error    // Returned by the system call.
   }

   func (e *PathError) Error() string {
       return e.Op + " " + e.Path + ": " + e.Err.Error()
   }

**PathError**'s **Error** generates a string like this:

.. code-block:: go

   open /etc/passwx: no such file or directory

Such an error, which includes the problematic file name, the operation,
and the operating system error it triggered, is useful even if printed
far from the call that caused it; it is much more informative than the
plain "no such file or directory".

When feasible, error strings should identify their origin, such as by
having a prefix naming the operation or package that generated the
error. For example, in package **image**, the string representation for
a decoding error due to an unknown format is "image: unknown format".

Callers that care about the precise error details can use a type switch
or a type assertion to look for specific errors and extract details. For
**PathErrors** this might include examining the internal **Err** field
for recoverable failures.

.. code-block:: go

   for try := 0; try < 2; try++ {
       file, err = os.Create(filename)
       if err == nil {
           return
       }
       if e, ok := err.(*os.PathError); ok && e.Err == syscall.ENOSPC {
           deleteTempFiles()  // Recover some space.
           continue
       }
       return
   }

The second **if** statement here is another `type
assertion <#interface_conversions>`__. If it fails, **ok** will be
false, and **e** will be **nil**. If it succeeds, **ok** will be true,
which means the error was of type ***os.PathError**, and then so is
**e**, which we can examine for more information about the error.

Panic
~~~~~

The usual way to report an error to a caller is to return an **error**
as an extra return value. The canonical **Read** method is a well-known
instance; it returns a byte count and an **error**. But what if the
error is unrecoverable? Sometimes the program simply cannot continue.

For this purpose, there is a built-in function **panic** that in effect
creates a run-time error that will stop the program (but see the next
section). The function takes a single argument of arbitrary type—often a
string—to be printed as the program dies. It's also a way to indicate
that something impossible has happened, such as exiting an infinite
loop.

.. code-block:: go

   // A toy implementation of cube root using Newton's method.
   func CubeRoot(x float64) float64 {
       z := x/3   // Arbitrary initial value
       for i := 0; i < 1e6; i++ {
           prevz := z
           z -= (z*z*z-x) / (3*z*z)
           if veryClose(z, prevz) {
               return z
           }
       }
       // A million iterations has not converged; something is wrong.
       panic(fmt.Sprintf("CubeRoot(%g) did not converge", x))
   }

This is only an example but real library functions should avoid
**panic**. If the problem can be masked or worked around, it's always
better to let things continue to run rather than taking down the whole
program. One possible counterexample is during initialization: if the
library truly cannot set itself up, it might be reasonable to panic, so
to speak.

.. code-block:: go

   var user = os.Getenv("USER")

   func init() {
       if user == "" {
           panic("no value for $USER")
       }
   }

Recover
~~~~~~~

When **panic** is called, including implicitly for run-time errors such
as indexing a slice out of bounds or failing a type assertion, it
immediately stops execution of the current function and begins unwinding
the stack of the goroutine, running any deferred functions along the
way. If that unwinding reaches the top of the goroutine's stack, the
program dies. However, it is possible to use the built-in function
**recover** to regain control of the goroutine and resume normal
execution.

A call to **recover** stops the unwinding and returns the argument
passed to **panic**. Because the only code that runs while unwinding is
inside deferred functions, **recover** is only useful inside deferred
functions.

One application of **recover** is to shut down a failing goroutine
inside a server without killing the other executing goroutines.

.. code-block:: go

   func server(workChan <-chan *Work) {
       for work := range workChan {
           go safelyDo(work)
       }
   }

   func safelyDo(work *Work) {
       defer func() {
           if err := recover(); err != nil {
               log.Println("work failed:", err)
           }
       }()
       do(work)
   }

In this example, if **do(work)** panics, the result will be logged and
the goroutine will exit cleanly without disturbing the others. There's
no need to do anything else in the deferred closure; calling **recover**
handles the condition completely.

Because **recover** always returns **nil** unless called directly from a
deferred function, deferred code can call library routines that
themselves use **panic** and **recover** without failing. As an example,
the deferred function in **safelyDo** might call a logging function
before calling **recover**, and that logging code would run unaffected
by the panicking state.

With our recovery pattern in place, the **do** function (and anything it
calls) can get out of any bad situation cleanly by calling **panic**. We
can use that idea to simplify error handling in complex software. Let's
look at an idealized version of a **regexp** package, which reports
parsing errors by calling **panic** with a local error type. Here's the
definition of **Error**, an **error** method, and the **Compile**
function.

.. code-block:: go

   // Error is the type of a parse error; it satisfies the error interface.
   type Error string
   func (e Error) Error() string {
       return string(e)
   }

   // error is a method of *Regexp that reports parsing errors by
   // panicking with an Error.
   func (regexp *Regexp) error(err string) {
       panic(Error(err))
   }

   // Compile returns a parsed representation of the regular expression.
   func Compile(str string) (regexp *Regexp, err error) {
       regexp = new(Regexp)
       // doParse will panic if there is a parse error.
       defer func() {
           if e := recover(); e != nil {
               regexp = nil    // Clear return value.
               err = e.(Error) // Will re-panic if not a parse error.
           }
       }()
       return regexp.doParse(str), nil
   }

If **doParse** panics, the recovery block will set the return value to
**nil**—deferred functions can modify named return values. It will then
check, in the assignment to **err**, that the problem was a parse error
by asserting that it has the local type **Error**. If it does not, the
type assertion will fail, causing a run-time error that continues the
stack unwinding as though nothing had interrupted it. This check means
that if something unexpected happens, such as an index out of bounds,
the code will fail even though we are using **panic** and **recover** to
handle parse errors.

With error handling in place, the **error** method (because it's a
method bound to a type, it's fine, even natural, for it to have the same
name as the builtin **error** type) makes it easy to report parse errors
without worrying about unwinding the parse stack by hand:

.. code-block:: go

   if pos == 0 {
       re.error("'*' illegal at start of expression")
   }

Useful though this pattern is, it should be used only within a package.
**Parse** turns its internal **panic** calls into **error** values; it
does not expose **panics** to its client. That is a good rule to follow.

By the way, this re-panic idiom changes the panic value if an actual
error occurs. However, both the original and new failures will be
presented in the crash report, so the root cause of the problem will
still be visible. Thus this simple re-panic approach is usually
sufficient—it's a crash after all—but if you want to display only the
original value, you can write a little more code to filter unexpected
problems and re-panic with the original error. That's left as an
exercise for the reader.

.. _web_server:

Webサーバー
--------------------

完全なGoのプログラムであるWebサーバを仕上げて終わりにしましょう。これは実際には一種の中継サーバです。Googleは **chart.apis.google.com** としてデータをチャートおよびグラフに自動的にフォーマットするサービスを提供しています。ただし、データをクエリとしてURLに送信する必要があるため、インタラクティブに使用することは困難です。ここでのプログラムはデータの1形式へのよりよいインターフェースを提供します。短いテキストを与えると、チャートサーバを呼び出し、テキストをエンコードする二次元のQRコードを生成します。その画像を携帯電話のカメラで取得して、たとえばURLとして解釈し、携帯電話の小さなキーボードにURLを入力する手間を省くことができます。

ここに完全なプログラムがあります。以下に従って説明します。

.. literalinclude:: progs/eff_qr.go
    :language: go

mainまでの部分は簡単に理解できるはずです。 1つのフラグは、サーバーのデフォルトHTTPポートを設定します。 テンプレート変数templは、面白いことが起こる場所です。 ページを表示するためにサーバーによって実行されるHTMLテンプレートを作成します。 それについてはすぐに説明します。

メイン関数はフラグを解析し、上で説明したメカニズムを使用して、関数 **QR** をサーバーのルートパスにバインドします。 次に、サーバーを起動するために **http.ListenAndServe** が呼び出されます。 サーバーの実行中はブロックされます。

**QR** はフォームデータを含むリクエストを受信し、 **s** という名前のフォーム値のデータに対してテンプレートを実行します。

テンプレートパッケージ **html/template** は強力です。 このプログラムは、その機能に触れています。 本質的に、 **templ.Execute** に渡されるデータ項目（この場合はフォーム値）から派生した要素を置き換えることにより、HTMLテキストを即座に書き換えます。 テンプレートテキスト（templateStr）内で、二重括弧で区切られた部分はテンプレートアクションを示します。 **{{if .}}** から **{{end}}** の部分は、**.** と呼ばれる現在のデータ項目が空でない場合のみ実行されます。つまり、文字列が空の場合、テンプレートのこの部分は抑制されます。

2つのスニペット **{{.}}** は、テンプレートに提示されたデータ（クエリ文字列）をWebページに表示することを示しています。 HTMLテンプレートパッケージは、適切なエスケープを自動的に提供するため、テキストを安全に表示できます。

テンプレート文字列の残りの部分は、ページが読み込まれたときに表示するHTMLです。 説明が速すぎる場合は、テンプレートパッケージの `ドキュメント </pkg/html/template/>`_で詳細を確認してください。

数行のコードといくつかのデータ駆動型HTMLテキストの便利なWebサーバーをあなたは持っています。 Goは、数行で多くのことを実行できるほど強力です。
