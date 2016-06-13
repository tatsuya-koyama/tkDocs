---
title: 'PHP 7'
date: '2016-06-13'
description:
categories: []
tags: [anything, Language, PHP]
position: 1
---

# PHP 備忘録（PHP7 対応）

## 他の言語から来た人向け要約

> 【対象読者】普通に C++ / C# / Java / Perl / Python / Ruby / JavaScript とかの類は
> 仕事で使ったりしてきたけどそう言えば PHP ってちゃんと書いたことないな、くらいの温度感の人

### どんな言語

初心者にやさしく、求人が多いイメージの言語。<br/>
他の言語の感覚で書くとたまに罠っぽい挙動をするので注意★

- [PHP: PHPの歴史 - Manual](http://php.net/manual/ja/history.php.php)
- PHP 5 が出たのが 2004 年 7 月
- 比較的大きな変更があった PHP 5.3 が 2009 年
- PHP 6 はスキップされたので **PHP 5 の次は PHP 7** になってる
- PHP 7 は 2015 年 12 月リリース
- PHP 7 は PHP 5 より **2 倍近く速い** らしい
    - 内部的なデータ構造を大幅に変えたそうな

### はじめに押さえておきたいところ

- 行末セミコロンは必須
- 変数の宣言は不要
- 変数は `$hoge` みたいに $ をつける
    - $ つけるので予約語と同じ名前でも大丈夫。やらんけど
- 未定義値は `null` とみなされる
- `++`, `--` はある
    - 前置と後置の概念もある
- 厳密な比較は JavaScript みたいに `===` を使う
    - `==` は型に寛容な比較。PHP は数値文字列とかをよしなに変換しちゃうので注意
- 組み込みのキーワードや、関数名・クラス名は**大文字・小文字を区別しない**
    - 変数名は大文字・小文字を区別する

____

    // コメントは
    /* C の形式に加えて */
    # シャープでも書ける

    // null になるシリーズ
    $var1;
    $var2 = null;
    unset($var3);

    // 定数定義（PHP 5.3 以降）
    const PI = 3.14;

### false とみなすやつ

- 空文字列 `""`, 文字列の `"0"`
- 整数リテラルの `0`
- 浮動小数リテラルの `0.0`
- 要素数 0 の配列
- `null`

### コーディングスタイル

- 変数名や関数名はキャメルケース（camelCase）が多そう
    - スネークケース（snake_case）はあまり使われないっぽい

## PHP 慣れてない人がハマりそうなポイント

- `==` 使ったときの数値と文字列の比較がわりとキモい
- （基本的に `===` を使った方がいいだろう）

        // '0x10' は 0 とみなされる
        var_dump('0x10' == 16);     // -> bool (false)

        // '010' は 10 とみなされる
        var_dump('010' == 10);      // -> bool (true)

        // 文字列の場合、先頭の数値だけが認識される。
        // 数値が無い場合 0 になるのでこれが true になる！
        var_dump('hoge' == 0);      // -> bool (true)

        var_dump('13xyz' == 13);    // -> bool (true)
        var_dump('13xyz' == '13');  // -> bool (false)

____

- 細かいところが知りたくなったら：
    - [PHP: PHP 型の比較表 - Manual](http://php.net/manual/ja/types.comparisons.php)
- 配列どうしの比較も演算子でできたりするけど、わりと特殊
    - [PHP: 配列演算子 - Manual](http://php.net/manual/ja/language.operators.array.php)

____

- **三項演算子 `?:` が左結合** なのはビビる（多くの言語では右結合）
- PHP では三項演算子を重ねる書き方はしないのが得策
- （括弧をつければどうにかできるが読みにくくなる）

        // 例えば以下のような三項演算子を重ねる書き方があるが
        $score = 70;
        $rank =
            ($score >= 80) ? 'A' :
            ($score >= 60) ? 'B' :
            ($score >= 40) ? 'C' : 'D';
        print($rank);
        // 多くの言語では 'B' になるが、PHP だと 'C' になる

        //----------
        // こういう式に対して
        $a = $expr1 ? 'val_1' : $expr2 ? 'val_2' : 'val_3';

        // 右結合だとこう解釈されるが
        $a = $expr1 ? 'val_1' : ($expr2 ? 'val_2' : 'val_3');

        // 左結合だとこう
        $a = ($expr1 ? 'val_1' : $expr2) ? 'val_2' : 'val_3';

____

- switch は `===` ではなく `==` で比較される
- switch 内での continue は break と同様の挙動
    - continue 書いても switch を抜けるだけで外側の for を continue とかしないので注意


## 文字列

- シングルクォートかダブルクォート
- シングルクォートは `\'` と `\\` だけエスケープする
- ダブルクォートは一通りエスケープする
- ダブルクォートは変数展開する

        // 他の言語と同様、変数展開時の変数を明確にするために { } が使える。
        // $ は括弧の中にあっても外にあってもいい
        "This is $var !"
        "This is {$var} !"
        "This is ${var} !"

____

- ヒアドキュメント

        <<<EOD
        ...
        EOD;

        // ヒアドキュメント内は変数展開される。したくない場合は
        <<<'EOD'
        ...
        EOD;

____

- 文字列の連結は `+` ではなく `.`
    - `+` だと文字列を数値に変換して加算するので気をつけろ

## 可変変数と可変関数

- 変数に入れた文字列を変数名として指定したり、関数名として指定したりできる

        $a = 'b';
        $b = 'c';
        $c = 'd';
    
        // 可変変数
        $$a;    // c  ($b と同義)
        ${$a};  // c  (同上)
    
        $$$a;   // d  ($$b すなわち $c と同義)
    
        // 可変関数
        $command = 'printf';
        $command('hoge');  // printf('hoge') と同義

## 参照（リファレンス）

- & を使う
- エイリアスが作られると考えればよい

        $x = 1;
        $x_ref = &$x;
        $x = 2;
        print $x_ref;  // -> 2

        $x_ref = 3;
        print $x;  // -> 3

____

- オブジェクトは勝手に参照渡しになる
    - オブジェクトに & をつけると PHP5 では警告、PHP7 ではエラー

## 配列と連想配列

- PHP 5 までは、内部的にはどちらも連想配列として扱われていた
    - キーが省略されたら 0 から始まる index が自動的に振られる感じ
    - `$array[1]` でも連想配列アクセスされるので他言語に比べると遅かった
    - PHP 7 では高速化のため、配列でよいやつは内部的に配列が作られる
    - （キーが 0 から連続する数字なら配列になる）
- キーには任意のデータ型を指定できるけど、キーに整数 / 文字列以外のものが指定された場合は、
  内部的に整数 / 文字列に変換される
- 配列やオブジェクトはキーにはできない

        // 昔はこう書いてた
        $oldStyleList = array(1, 2, 3);

        // PHP 5.4 以降はこう書ける
        $list = [1, 'a', 2];
        $map  = [
            'hoge' => 123,
            'fuga' => 456,
            789    => 'piyo',
        ];

### 配列の走査

    $arr = ['a', 'b', 'c'];
    foreach ($arr as $value) {
        print("${value}, ");
    }
    // => a, b, c,

    // キーが欲しい場合
    foreach ($arr as $key => $value) {
        print("${key}-${value}, ");
    }
    // => 0-a, 1-b, 2-c,

    //----------
    // 走査中に直接値を変更したいときは & をつけると
    // $value にリファレンスが代入される
    foreach ($arr as &$value) {
        $value *= 2;
    }
    print_r($arr);  // => [2, 4, 6]

### 要素の出し入れ

    $list = [1, 2, 3];
    array_push($list, 4);          // [1, 2, 3, 4]
    array_unshift($list, 0);       // [0, 1, 2, 3, 4]
    $popped  = array_pop($list);   // [0, 1, 2, 3]
    $shifted = array_shift($list); // [1, 2, 3]

## 関数

    function foo($arg) { ... }

    // 参照渡し
    function foo(&$ref) {
        $ref *= 2;
    }

- 関数定義は呼び出しの後ろに書いてあっても大丈夫
- 関数内にも関数は書ける
- 関数内に書いた関数も、その関数が呼び出された後なら外から参照できる
    - そんなことしないだろうけど
- 引数のデフォルト値はある
- 引数の参照渡しもある
    - 引数の定義に & をつける
- 可変長引数は PHP 5.6 から
    - それ以前は `func_get_args()` 関数を使ってた
- `...` 演算子でアンパックできる
    - 引数 2 つある関数を `someFunc(...[1, 2]);` みたいに呼んだりとか
- 複数の戻り値を返したかったら単に配列で返す
    - それを個別の変数に代入したかったら、配列を変数に割り振る `list` 関数を使え
- ジェネレータがある
- いわゆる関数のオーバーロードは無い

## クロージャ

- [PHP: 無名関数 - Manual](http://php.net/manual/ja/functions.anonymous.php)
- クロージャは `use` で明示的にキャプチャする必要がある

        $message = 'hello';
        $func = function() use($message) {
            print($message);
        };

        // 参照渡ししなかった場合、キャプチャした値は関数定義時のもので
        // 関数呼び出し時のものではない
        $message = 'world';
        $func();  // => hello

        //----------
        // キャプチャした変数の変更を追跡したり
        // クロージャ内で値を書き換えたい場合は & をつけて参照渡しする
        $func2 = function() use(&$message) {
            print($message);
            $message = 'goodbye';
        };

        $message = 'piyo';
        $func2();         // => piyo
        print($message);  // => goodbye


## クラス

    class SampleClass extends SomeSuperClass {

        // アクセス修飾子がある
        public    $var1 = 'public';
        protected $var2 = 'protected';
        private   $var3 = 'private';
    
        // コンストラクタとデストラクタ（PHP 5 以降）
        function __construct() {}
        function __destruct() {}

    };

- [PHP: クラスとオブジェクト - Manual](http://php.net/manual/ja/language.oop5.php)
- コンストラクタとデストラクタがある
- メソッドのオーバライドはできる
    - `parent::親メソッド()` でスーパクラスのメソッドが呼べる
    - `final` でオーバライド禁止もできる
- `interface` がある
- `abstract` もある
- `instanceof` 演算子がある
- コード再利用のためのトレイトがある（PHP 5.4.0 以降）
- オブジェクトを foreach にかけられる
- `__toString()` などのマジックメソッドが用意されている
- namespace がある
- オートローダ
    - [PHP: クラスのオートローディング - Manual](http://php.net/manual/ja/language.oop5.autoload.php)

## 小ネタ

### 豆知識

- 三項演算子の省略構文がある
    - `$foo = $bar ?: 'default-value';`
- エラー制御演算子
    - @ を式の先頭につけるとその命令で発生するエラーメッセージを抑制する
    - エラーを抑制すべきではないので使いどころは少ない
- 制御命令に別構文がある
    - [PHP: 制御構造に関する別の構文 - Manual](http://php.net/manual/ja/control-structures.alternative-syntax.php)
    - まあ使いどころは無いと思う
- require_once などで読み込んだものはスコープを継承する

### マジカルインクリメント

    $i = 'Z';
    print ++$i;  // -> AA
    print ++$i;  // -> AB

    $j = 'T8';
    print ++$j;  // -> T9
    print ++$j;  // -> U0

- なお、マジカルデクリメントはない

## PHP 7.0 で変わったこと

- [PHP: 下位互換性のない変更点 - Manual](http://php.net/manual/ja/migration70.incompatible.php)
- 引数・戻り値の型宣言ができる
    - PHP5 ではタイプヒンティングと呼ばれていた
    - でも double や boolean のような **スカラー型のエイリアスは利用できない**
        - （double という名前のクラス / インターフェースであるとみなされる）
- null 合体演算子 : `$foo = $bar ?? 'default-value';`
- foreach ブロック内での要素追加の挙動が違う
- 無名クラスをサポート

## PHP の複数バージョン管理
- phpenv ってのがある
    - [phpenv/phpenv: Simple PHP version management](https://github.com/phpenv/phpenv)
- この辺を参考にしてインストールしよう
    - [phpenvの導入して複数バージョンのPHPを管理する - Qiita](http://qiita.com/uchiko/items/5f1843d3d848de619fdf)
    - [phpenvで複数のPHPのバージョンを管理する - Qiita](http://qiita.com/toshiro3/items/2ca2765c1a5fee78d504)
    - [phpenv+php-build環境によるphpバージョン管理~Mac（Yosemite）編~ - Qiita](http://qiita.com/omega999/items/c5b1c177331f8d342efd)

#### 使い方

    # インストール可能な PHP のバージョンを一覧
    $ phpenv install --list

    # 特定のバージョンをインストール
    $ phpenv install 5.6.22

    # インストール済みのバージョンを一覧
    $ phpenv versions

    # バージョン切り替え
    $ phpenv global 5.6.22  # 全環境に反映
    $ phpenv local  5.6.22  # カレントディレクトリのみ
                            # （.php-version が作成される）

#### 【2016 年頃の Mac でありそうなトラブルシュート】

- `phpenv install` はわりと待たされるが、**わりと BUILD ERROR になる**ので注意
    - 依存パッケージが足りないのが原因。
      あと OpenSSL のリンクまわりでエラーが出たりもする。
    - 以下を参考にするとよい
        - [Mac OS X El Capitan上でphp-buildするメモ - Qiita](http://qiita.com/hnw/items/62380e713d318906f0cd)
        - [MacOSX に PHP 5.4.29 を install したい - あいつの日誌β](http://okamuuu.hatenablog.com/entry/2015/07/08/143411)

____

    # 最終的に Mac (OSX 10.11.1) で PHP 5.6.22 を入れるのには以下が必要だった
    $ brew install re2c
    $ brew install autoconf
    $ brew link openssl --force

    $ PHP_BUILD_CONFIGURE_OPTS="--with-openssl=$(brew --prefix openssl) \
          --with-libxml-dir=$(brew --prefix libxml2)" \
          PHP_BUILD_EXTRA_MAKE_ARGUMENTS=-j4 \
          phpenv install 5.6.22

