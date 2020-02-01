database/sql
============================================

公式ドキュメント https://golang.org/pkg/database/sql/#DB [#]_ を参考にDBを扱う準備をします。今回はDriverとして Postgres (pure Go) [#]_ を用いることにします。

.. code-block:: none

    $ go get "github.com/lib/pq"

init関数を呼び出してimportします。

.. code-block:: go

    _ "github.com/lib/pq"


--------------------------------------------
レコードのSELECT
--------------------------------------------

まずはDB(PostgreSQL)のテーブルをselectしてみます。

.. code-block::

    import (
        "database/sql"
        "fmt"
        "log"

        _ "github.com/lib/pq"
    )

    func main() {
        connStr := "postgres://dev:dev@localhost/dev?sslmode=disable"
        db, err := sql.Open("postgres", connStr)
        if err != nil {
            log.Fatal(err)
        }

        relname := "pg_user"
        rows, err := db.Query("SELECT relname, relnamespace FROM pg_class WHERE relname = $1", relname)

        for rows.Next() {
            var rel string
            var relnamespace int
            if err := rows.Scan(&rel, &relnamespace); err != nil {
                log.Fatal(err)
            }
            fmt.Println(rel, relnamespace)
        }
        defer rows.Close()
    }
    // pg_user 11

想定通りレコードが取得できていることがわかりました。


--------------------------------------------
レコードのINSERT
--------------------------------------------

.. code-block:: go

    import (
        "database/sql"
        "log"

        _ "github.com/lib/pq"
    )

    func main() {
        connStr := "postgres://dev:dev@localhost/dev?sslmode=disable"
        db, err := sql.Open("postgres", connStr)
        if err != nil {
            log.Fatal(err)
        }

        statement := "INSERT INTO item (invoiceid, item, productid, quantity, cost) VALUES ($1, $2, $3, $4, $5)"
        stmt, err := db.Prepare(statement)
        if err != nil {
            log.Fatal(err)
        }

        defer stmt.Close()
        if _, err := stmt.Exec(49, 17, 24, 18, 10.8); err != nil {
            log.Fatal(err)
        }
    }

--------------------------------------------
レコードのUPDATE
--------------------------------------------

レコードのUPDATEはINSERTとほぼ同じです。

.. code-block:: go

    import (
        "database/sql"
        "log"

        _ "github.com/lib/pq"
    )

    func main() {
        connStr := "postgres://dev:dev@localhost/dev?sslmode=disable"
        db, err := sql.Open("postgres", connStr)
        if err != nil {
            log.Fatal(err)
        }

        statement := "UPDATE item SET cost = $1 WHERE invoiceid = $2 AND ITEM = $3"
        stmt, err := db.Prepare(statement)
        if err != nil {
            log.Fatal(err)
        }

        defer stmt.Close()
        if _, err := stmt.Exec(0.1, 49, 17); err != nil {
            log.Fatal(err)
        }
    }

--------------------------------------------
レコードのDELETE
--------------------------------------------

DELETEもINSERT(, UPDATE)とほぼ同様です。

.. code-block:: go

    import (
        "database/sql"
        "log"

        _ "github.com/lib/pq"
    )

    func main() {
        connStr := "postgres://dev:dev@localhost/dev?sslmode=disable"
        db, err := sql.Open("postgres", connStr)
        if err != nil {
            log.Fatal(err)
        }

        statement := "DELETE FROM item WHERE invoiceid = $1 AND ITEM = $2"
        stmt, err := db.Prepare(statement)
        if err != nil {
            log.Fatal(err)
        }

        defer stmt.Close()
        if _, err := stmt.Exec(49, 17); err != nil {
            log.Fatal(err)
        }
    }

--------------------------------------------
トランザクション管理
--------------------------------------------

上の例ではINSERT/UPDATE/DELETEを処理する際に、 \*sql.Stmt を用いていました。今回はトランザクション管理をするために

.. code-block:: none

    func (db *DB) Begin() (*Tx, error)

を用いることにします。実装例としては [#]_ が参考になります。

.. code-block:: go

    import (
        "database/sql"
        "log"

        _ "github.com/lib/pq"
    )

    func main() {
        connStr := "postgres://dev:dev@localhost/dev?sslmode=disable"
        db, err := sql.Open("postgres", connStr)
        if err != nil {
            log.Fatal(err)
        }

        tx, err := db.Begin()
        if err != nil {
            log.Fatal(err)
        }
        defer tx.Rollback()

        statement := "INSERT INTO item (invoiceid, item, productid, quantity, cost) VALUES (49, 17, 24, 18, 10.8)"

        defer func() {
            if err != nil {
                tx.Rollback()
                return
            }
            err = tx.Commit()
        }()
        if _, err := tx.Exec(statement); err != nil {
            log.Fatal(err)
        }
    }

--------------------------------------------
参考
--------------------------------------------

.. [#] https://golang.org/pkg/database/sql/#DB
.. [#] https://godoc.org/github.com/lib/pq
.. [#] https://stackoverflow.com/questions/16184238/database-sql-tx-detecting-commit-or-rollback

--------------------------------------------
あとで読みたい
--------------------------------------------

- http://go-database-sql.org/index.html