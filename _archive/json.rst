json
============================================


--------------------------------------------
JSONを読み込む
--------------------------------------------

.. code-block:: go

    import (
        "encoding/json"
        "fmt"
        "io/ioutil"
        "log"
        "net/http"
    )

    type UserResult struct {
        Status string `json:"status"`
        Result []struct {
            ContestID               int    `json:"contestId"`
            ContestName             string `json:"contestName"`
            Handle                  string `json:"handle"`
            Rank                    int    `json:"rank"`
            RatingUpdateTimeSeconds int    `json:"ratingUpdateTimeSeconds"`
            OldRating               int    `json:"oldRating"`
            NewRating               int    `json:"newRating"`
        } `json:"result"`
    }

    func main() {

        response, err := http.Get("http://codeforces.com/api/user.rating?handle=tutuz")

        if err != nil {
            log.Fatal(err)
        }

        body, err := ioutil.ReadAll(response.Body)

        if err != nil {
            log.Fatal(err)
        }

        var result UserResult
        if json.Unmarshal(body, &result); err != nil {
            log.Fatal(err)
        }

        for _, v := range result.Result {
            fmt.Println(v.ContestName)
        }

    }
    // Educational Codeforces Round 50 (Rated for Div. 2)
    // Codeforces Round #510 (Div. 2)
    // Codeforces Round #512 (Div. 2, based on Technocup 2019 Elimination Round 1)
    // Codeforces Round #516 (Div. 2, by Moscow Team Olympiad)
    // Codeforces Round #517 (Div. 2, based on Technocup 2019 Elimination Round 2)
    // Educational Codeforces Round 54 (Rated for Div. 2)
    // Codeforces Round #521 (Div. 3)
    // Codeforces Round #524 (Div. 2)
    // Codeforces Round #541 (Div. 2)

--------------------------------------------
JSONを書き込む
--------------------------------------------

.. code-block:: go

    import (
        "bytes"
        "encoding/json"
        "fmt"
    )

    type message struct {
        TaskId     string            `json:"taskid"`
        Parameters map[string]string `json:"parameters"`
    }

    func main() {
        m := "getFromToYmd"
        d := map[string]string{
            "executeHostname": "localhost",
            "fromYM":          "201801",
            "toYM":            "201905",
        }
        res := message{
            TaskId:     m,
            Parameters: d,
        }

        jsonBytes, err := json.Marshal(res)
        if err != nil {
            fmt.Println("JSON Marshal error:", err)
            return
        }

        out := new(bytes.Buffer)
        json.Indent(out, jsonBytes, "", "    ")
        fmt.Println(out.String())

    }
    // {
    //     "taskid": "getFromToYmd",
    //     "parameters": {
    //         "executeHostname": "localhost",
    //         "fromYM": "201801",
    //         "toYM": "201905"
    //     }
    // }

--------------------------------------------
参考
--------------------------------------------

- https://golang.org/pkg/encoding/json/
- https://qiita.com/msh5/items/dc524e38073ed8e3831b