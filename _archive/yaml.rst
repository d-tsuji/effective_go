yaml
============================================

--------------------------------------------
yamlファイルを読み込む
--------------------------------------------

簡単に以下の形式の山手線の駅名が記載されたyamlファイルを読み込んでみます。

.. code-block:: yaml
    :caption: test.yaml

    -
    station_id: 1
    station_name: 大崎
    -
    station_id: 2
    station_name: 五反田
    -
    station_id: 3
    station_name: 目黒
    -
    station_id: 4
    station_name: 恵比寿
    -
    station_id: 5
    station_name: 渋谷

``gopkg.in/yaml.v2`` のパッケージが必要になるので、 ``go get -v gopkg.in/yaml.v2`` しておきます。

実装例は以下の通りです。

.. code-block:: go
    :caption: yaml2struct.go

    func ReadYaml() (*[]station, error) {

        buf, err := ioutil.ReadFile("./test.yml")
        if err != nil {
            fmt.Println(err)
        }

        data := make([]station, 1)
        err = yaml.Unmarshal(buf, &data)
        if err != nil {
            fmt.Println(err)
            return nil, err
        }

        return &data, nil
    }

本質的には ``go get`` した ``yaml.go`` の以下の関数を呼び出すことになります。

.. code-block:: go

    func Unmarshal(in []byte, out interface{}) (err error) {
        return unmarshal(in, out, false)
    }

関数の引数であるインターフェース型の ``out`` にアンマーシャリングされた構造体のデータがwriteされます。

.. code-block:: go
    :caption: yaml2struct_test.go

    func TestReadYaml(t *testing.T) {

        data, err := ReadYaml()
        if err != nil {
            fmt.Println(err)
        }

        fmt.Println(*data)
    }

結果

.. code-block:: none

   === RUN   TestReadYaml
    [{1 大崎} {2 五反田} {3 目黒} {4 恵比寿} {5 渋谷}]
    --- PASS: TestReadYaml (0.00s)
    PASS

--------------------------------------------
yamlを書き込む
--------------------------------------------

続いて、構造体のデータからyamlファイルを生成してみます。

.. code-block:: go

    func WriteYaml() error {

        stations := make([]station, 0)
        stations = append(stations, station{
            Id:   1,
            Name: "東京",
        })
        stations = append(stations, station{
            Id:   2,
            Name: "新橋",
        })
        stations = append(stations, station{
            Id:   3,
            Name: "品川",
        })
        stations = append(stations, station{
            Id:   4,
            Name: "横浜",
        })

        dat, err := yaml.Marshal(&stations)
        if err != nil {
            fmt.Println(err)
            return err
        }
        fmt.Println(string(dat))

        return nil
    }

.. code-block:: go
    :caption: yaml2struct_test.go

    func TestWriteYaml(t *testing.T) {

        if err := WriteYaml(); err != nil {
            fmt.Println(err)
        }
    }

結果

yaml 形式でwriteされていることがわかります。

.. code-block:: none

    === RUN   TestWriteYaml
    - station_id: 1
    station_name: 東京
    - station_id: 2
    station_name: 新橋
    - station_id: 3
    station_name: 品川
    - station_id: 4
    station_name: 横浜

    --- PASS: TestWriteYaml (0.00s)
    PASS

--------------------------------------------
参考
--------------------------------------------

- https://godoc.org/gopkg.in/yaml.v2