はじめに
===========================

---------------------------
Go言語とは
---------------------------

Go言語は2009年にGoogleにいたRobert Griesemer、Rob Pike、Ken Thompsonによって生み出されたプログラミング言語です。Go言語は以下のような特徴を持ちます。

- C言語、Pascal、CSPを起源とした言語
- 静的型付けのコンパイル言語
- 自動メモリ管理で、GCの機構を持つ
- CSPスタイルの並行性
- シンプルな言語仕様
- 継承がない

---------------------------
セットアップ
---------------------------

---------------------------
環境変数
---------------------------

Go言語で設定されている環境変数を確認します。以下の go env コマンドで確認することができます。

.. code-block:: none

    $ go env
    set GOARCH=amd64
    set GOBIN=
    set GOCACHE=C:\Users\Dai\AppData\Local\go-build
    set GOEXE=.exe
    set GOHOSTARCH=amd64
    set GOHOSTOS=windows
    set GOOS=windows
    set GOPATH=C:\Users\Dai\go
    set GORACE=
    set GOROOT=C:\Go
    set GOTMPDIR=
    set GOTOOLDIR=C:\Go\pkg\tool\windows_amd64
    set GCCGO=gccgo
    set CC=gcc
    set CXX=g++
    set CGO_ENABLED=1
    set CGO_CFLAGS=-g -O2
    set CGO_CPPFLAGS=
    set CGO_CXXFLAGS=-g -O2
    set CGO_FFLAGS=-g -O2
    set CGO_LDFLAGS=-g -O2
    set PKG_CONFIG=pkg-config
    set GOGCCFLAGS=-m64 -mthreads -fmessage-length=0 -fdebug-prefix-map=C:\Users\Dai\AppData\Local\Temp\go-build095523442=/tmp/go-build -gno-record-gcc-switches

重要な環境変数は以下の2つです。

- GOROOT
- GOPATH

GOROOTは、Goがインストールされているディレクトリです。GOPATHは、外部のパッケージなどのソースを取りまとめておくディレクトリを指定するものになります。$HOME/go や $HOME/.go にするのが一般的でしょう。

---------------------------
コンパイル／実行
---------------------------

まずは Hello world を出力するプログラムを書いてみます。

.. code-block:: go
    :caption: sample.go
    
    package main

    import "fmt"

    func main() {
        fmt.Println("Hello world.")
    }

main パッケージはライブラリなしで動作する実行可能なプログラムを定義します。main パッケージの main 関数からプログラムが実行されます。まずはこのプログラムを動かしてみます。

.. code-block:: none

    $ go run sample.go

Hello world. がコンソールに出力されたことがわかります。このプログラムは import としてGo言語に内包されている fmt パッケージを用いて標準出力しています。go run した場合はコンパイラがコンパイルしたプログラムが実行されますが、実行ファイルは生成されません。

Go言語のビルドは以下のように実行できます。

.. code-block:: none

    $ go build sample.go

ビルドすると sample.exe という実行可能ファイルが生成されることがわかります。ビルドすると go run せずとも実行可能ファイルを実行することでプログラムを実行できます。

.. code-block:: none

    $ sample.exe

---------------------------
パッケージのインストール
---------------------------

外部パッケージを利用する場合は、go get コマンドを用います。たとえば以下のように実行すると $GOPATH/src 配下に golang/lint パッケージがインストールされることがわかります。

.. code-block:: none

    $ go get -v github.com/golang/lint

