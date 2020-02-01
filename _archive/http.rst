net/http
============================================

GoでHTTPサーバ/HTTPクライアントを試してみます。net/http パッケージにまとまっています。

https://golang.org/pkg/net/http/

--------------------------------------------
HTTPサーバ
--------------------------------------------

とてもシンプルにHTTPサーバになることができます。

.. code-block::
    :caption: Hello worldを出力するサーバ

    func main() {

        http.HandleFunc("/hello", func(writer http.ResponseWriter, request *http.Request) {
            fmt.Fprintln(writer, "Hello world!")
        })
        http.ListenAndServe(":8021", nil)

    }

curl でHTTPサーバにリクエストしてみます。

.. code-block:: none

    D:\>curl -v localhost:8021/hello
    *   Trying ::1...
    * TCP_NODELAY set
    * Connected to localhost (::1) port 8021 (#0)
    > GET /hello HTTP/1.1
    > Host: localhost:8021
    > User-Agent: curl/7.55.1
    > Accept: */*
    >
    < HTTP/1.1 200 OK
    < Date: Sun, 30 Jun 2019 11:16:20 GMT
    < Content-Length: 13
    < Content-Type: text/plain; charset=utf-8
    <
    Hello world!
    * Connection #0 to host localhost left intact

Hello world! のレスポンスが返ってくることがわかりました。HTTP/1.1 で通信していることがわかります。HTTPリクエストの中をのぞいてみます。

ブラウザから http://localhost:8021/hello2?foo=hoge&boo=fuga にリクエストしてみます。

.. code-block::

    func main() {

        http.HandleFunc("/hello2", func(writer http.ResponseWriter, request *http.Request) {

            method := request.Method
            fmt.Printf("[Method] %v\n", method)
            for k, v := range request.Header {
                fmt.Printf("[Header] %v: %s\n", k, strings.Join(v, ","))
            }

            // GET
            if method == "GET" {
                request.ParseForm()
                for k, v := range request.Form {
                    fmt.Print("[Param] " + k)
                    fmt.Println(": " + strings.Join(v, ","))
                }
                fmt.Fprintln(writer, "Hello world! Get request recieved.")
            }
        })
        http.ListenAndServe(":8021", nil)

    }
    // [Method] GET
    // [Header] Connection: keep-alive
    // [Header] Cache-Control: max-age=0
    // [Header] Upgrade-Insecure-Requests: 1
    // [Header] User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36
    // [Header] Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3
    // [Header] Accept-Encoding: gzip, deflate, br
    // [Header] Accept-Language: ja,en-US;q=0.9,en;q=0.8
    // [Param] foo: hoge
    // [Param] boo: fuga


次に POST リクエストを扱ってみます。メソッドが POST は Body を解析してサーバ側に出力させることにします。

.. code-block::

    func main() {

        http.HandleFunc("/hello3", func(writer http.ResponseWriter, request *http.Request) {

            method := request.Method
            fmt.Printf("[Method] %v\n", method)
            for k, v := range request.Header {
                fmt.Printf("[Header] %v: %s\n", k, strings.Join(v, ","))
            }

            if method == "POST" {
                defer request.Body.Close()
                body, err := ioutil.ReadAll(request.Body)
                if err != nil {
                    log.Fatal(err)
                }

                fmt.Println("[request body row] " + string(body))
                decoded, error := url.QueryUnescape(string(body))
                if error != nil {
                    log.Fatal(error)
                }
                fmt.Println("[request body decoded] ", decoded)
                fmt.Fprint(writer, "Hello world. Recieved Post(form) request!!")
            }
        })
        http.ListenAndServe(":8021", nil)

    }

curl は以下のようにします。

.. code-block:: none

    curl -v -XPOST -d '%E3%81%93%E3%82%93%E3%81%AB%E3%81%A1%E3%81%AF+%E4%B8%96%E7%95%8C' localhost:8021/hello3

結果(サーバ側)

.. code-block:: none

    [Method] POST
    [Header] Accept: */*
    [Header] Content-Length: 66
    [Header] Content-Type: application/x-www-form-urlencoded
    [Header] User-Agent: curl/7.55.1
    [request body row] '%E3%81%93%E3%82%93%E3%81%AB%E3%81%A1%E3%81%AF+%E4%B8%96%E7%95%8C'
    [request body decoded]  'こんにちは 世界'

結果(クライアント側)

.. code-block:: none

    *   Trying ::1...
    * TCP_NODELAY set
    * Connected to localhost (::1) port 8021 (#0)
    > POST /hello3 HTTP/1.1
    > Host: localhost:8021
    > User-Agent: curl/7.55.1
    > Accept: */*
    > Content-Length: 66
    > Content-Type: application/x-www-form-urlencoded
    >
    * upload completely sent off: 66 out of 66 bytes
    < HTTP/1.1 200 OK
    < Date: Sun, 30 Jun 2019 11:47:21 GMT
    < Content-Length: 42
    < Content-Type: text/plain; charset=utf-8
    <
    Hello world. Recieved Post(form) request!!* Connection #0 to host localhost left intact

想定どおりリクエストBodyが解析されて、表示されていることがわかります。

--------------------------------------------
HTTPクライアント
--------------------------------------------


続いてHTTPクライアントを実装してみます。サーバは上記で作成したサーバを別プロセスで立ち上げておきます。実装方法はいくつかあるようです。 `Go net/httpパッケージの概要とHTTPクライアント実装例 <https://qiita.com/jpshadowapps/items/463b2623209479adcd88>`_ を参考にしました。

GETメソッド
--------------------------------------------

一番単純な http.Get(url)によるGET
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: go

	values := url.Values{}
	values.Add("name", "d-tsuji")

	res, err := http.Get("http://127.0.0.1:8021/hello2?" + values.Encode())
	if err != nil {
		fmt.Println(err)
		return
	}

	defer res.Body.Close()

	body, err := ioutil.ReadAll(res.Body)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(string(body))

結果(サーバ側)

.. code-block:: none

    > goSample.exe
    [Method] GET
    [Header] User-Agent: Go-http-client/1.1
    [Header] Accept-Encoding: gzip
    [Param] age: 999
    [Param] name: d-tsuji

結果(クライアント側)

.. code-block:: none

    Hello world! Get request recieved.

想定通りサーバと通信できていることがわかりました。

Client 型
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Client.Do(Request) メソッド
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


POSTメソッド
--------------------------------------------


--------------------------------------------
その他参考
--------------------------------------------

- http://pppurple.hatenablog.com/entry/2018/04/26/225932