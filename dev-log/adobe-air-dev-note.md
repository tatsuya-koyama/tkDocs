---
title: 'Adobe AIR ゲーム開発メモ'
date: '2013-12-16'
description:
categories: []
tags: [anything, Game-Development, Adobe-AIR]
position: 10
---

# Adobe AIR ゲーム開発メモ

## リンク集

- ゲームエンジン / フレームワーク
    - [Citrus Engine: Creating Level using Tiled Map Editor](http://pzuh.blogspot.jp/2013/05/citrus-engine-creating-level-using.html)
    - [Ash entity framework](http://www.ashframework.org/)

___

- Starling 関連
    - [Showcase](http://wiki.starling-framework.org/games/start)
    - [Extension](http://wiki.starling-framework.org/extensions/start)
      の下の方にある関連記事のリンク集とかおもしろい

___

- Starling 描画系
    - [[AS3] 2D lighting with normal map, take 2](http://www.yopsolo.fr/wp/2014/02/15/as3-2d-lighting-with-normal-map-take-2/)
    - [onebyoneblog](http://blog.onebyonedesign.com/)
        - [Filters in Starling](http://blog.onebyonedesign.com/actionscript/filters-in-starling/)
            - ピクレセートとかポスタリゼーションっぽいの
        - [Starling Filter Collection](http://blog.onebyonedesign.com/actionscript/starling-filter-collection/)
            - 色々使えそうなフィルタがたくさん
    - [KrechaBlog](http://blog.krecha-games.com/)
        - ミミズみたいなぐにゃぐにゃとか
    - [Deferred shading extension for Starling..](http://nekobit.puslapiai.lt/deferred-shading-extension-for-starling/)
        - 法線マップのアレ
    - [Displacement maps and Metaballs](http://www.andysaia.com/radicalpropositions/displacement-maps-and-metaballs/)
    - [Forum - Light rings using BlendMode](http://forum.starling-framework.org/topic/light-rings-using-blendmode)
        - ライティングっぽいのどうやればいい？ スレッド
    - [Forum - Where to learn how to write simple shaders?](http://forum.starling-framework.org/topic/where-to-learn-how-to-write-simple-shaders)
        - AGAL とか学び始める時のよいリソースのリンクがある
    - [Forum - work in progress: Starling extension for lighting and dynamic shadows](http://forum.starling-framework.org/topic/work-in-progress-starling-extension-for-lighting-and-dynamic-shadows)
        - 2D の shadow casting の demo と extension のソースがある
    - [Digging more into the Molehill APIs](http://www.bytearray.org/?p=2555)
        - AGAL の記事

___

- AS3 とか Flash とか Starling とか読み物とか
    - [akihiro kamijo さんのブログ](http://cuaoar.jp/)
        - Adobe の中の人
    - [(blog) Pierre Chamberlain](http://pierrechamberlain.ca/blog/)
        - CRT ディスプレイな shader が素敵
    - [Adobe Flash Platform](http://www.scoop.it/t/adobe-flash-platform)
        - AS3 / AIR / Stage3D まわりの情報
    - [TypedArray.org](http://typedarray.org/)
        - サイトデザインがおしゃれ



## Flash CrossBridge ってなに

- [公式](http://adobe-flash.github.io/crossbridge/)
- C / C++ で書いたコードを Flash 向けにコンパイルできるよってやる

### 歴史

- かつて前身となるプロジェクトで [Adobe Alchemy](http://labs.adobe.com/technologies/alchemy/)
  ってのがあった
    - Box2D とか C++ のやつをこれでポーティングした Box2D Alchemy とかあった
    - まあ 2011 年くらいで開発止まってるっぽいけどね
- それが FlasCC （Flash C++ Compiler）というものになった
- Adobe CrossBridge はそれのオープンソース版（2013 年 6 月くらいの発表？）


## ActionScript 3.0 一般

### AS3 Tips

#### null と undefined

- JS のノリで undefined とか null とか使うと事故るよ
    - AS3 は型ごとにデフォルト値決まってる
    - Boolean は false, int/uint は 0, Number は NaN, 後は大体 null
    - 未宣言とか * で型指定ない場合が undefined
    - **Boolean, int/uint, Number は null 入れられない**
        - null 入れるとデフォルト値に変換されるので注意
        - Number に null 入れて if (num == null) とかダメ
        - そういうときは Number に NaN 入れて if (isNaN(num)) ってやる


> - [Adobe AS3 - デフォルト値](http://help.adobe.com/ja_JP/ActionScript/3.0_ProgrammingAS3/WS5b3ccc516d4fbf351e63e3d118a9b90204-7f9d.html#WS5b3ccc516d4fbf351e63e3d118a9b90204-7f8b)
> - [Adobe AS3 - 型変換](http://help.adobe.com/ja_JP/ActionScript/3.0_ProgrammingAS3/WS5b3ccc516d4fbf351e63e3d118a9b90204-7f87.html)

### ASC2.0 をコマンドラインから使うとコンパイル時間長くね？

- 参考リンク
    - [FCSH with new AIR / ASC2.0 compiler (faster compilation iterations)](http://forum.starling-framework.org/topic/fcsh-with-new-air-asc20-compiler-faster-compilation-iterations)
    - [http://jcward.com/FCSH+for+ASC+2.0+Compiler](http://jcward.com/FCSH+for+ASC+2.0+Compiler)
    - 試してみたけど俺の環境だと ascshd の立ち上げに 7 秒くらいかかって差し引きゼロだった……

### 配列の走査のパフォーマンス

すごく適当に実験してみた。

`[0, 1, 2, 3, ... 999999]` の要素数 100 万の配列 `list` があったとして、
色んな書き方で走査して終了までの時間を flash.utils.getTimer() で計測する。
当然実行するたびに値揺れるけど、傾向を見るのにやってみた。

- 昔ながらのやり方で書く
- 233 ms くらい

        for (var i:int = 0;  i < list.length;  ++i) {
            tmp = list[i];
        }

____

- length を外に出す
- 133 ms くらいで、確かに速くはなる

        var len:int = list.length;
        for (var i:int = 0;  i < len;  ++i) {
            tmp = list[i];
        }

____

- 現代人がよく書くやつ
- 156 ms くらい。概ねこれで問題ない

        for each (var val:int in tester) {
            tmp = val;
        }

____

- Array クラスの forEach
- （引数面倒だし使うことはないだろう。 JS と違って最初から for each あるし）
- 318 ms くらい。関数コールのオーバヘッドはこんなもん

        list.forEach(function(val:*, index:int, array:Array):void {
            tmp = val;
        });

____

- オブジェクトのキーの走査に使うやつを配列で
- 5522 ms もかかったのでダメだ。 i がほしい時は昔ながらので書くべし

        for (var i:String in list) {
            tmp = list[i];
        }


## 物理エンジンの Nape どうなの

- [Nape Physics Engine](http://napephys.com/index.html)

### いいところ

- ためしてみたけどいい感じ。ヌルヌル動く。
- Box2D よりパフォーマンスいいよってのを謳ってる
- API やコードもすっきりしてていい感じ
    - ただしコードはマクロ満載の haxe だが

### つらいところ

- 使い終わったメモリがどうにも GC 対象になってくれなくて困ってる
    - 実機で動かし続けてたらメモリ消費 150 MB とかいった
    - 破棄したり参照消したりしてもシーン遷移時に回収されない
    - Vec2 のオブジェクトプールの仕様かと思ったが Vec2 使わない Circle とかでもなる
    - ここが解決しないと使えんな

___

- メモリもうちょっと踏み込んで調べてみた
    - どうやらオブジェクト生成・即座に破棄を繰り返すだけだとそんなにリークしない
    - （デバッグで System.gc() 呼べば割と回収される）
    - どちらかというと生成・破棄ではなく物理計算の過程で消費されるメモリが回収しにくいっぽい
    - 400 個とか生成して放り込んでそのまま見てると、それだけでみるみるメモリ消費増えてく
    - ある程度回収されたりもするが、回収しきれず蓄積してく感じ
    - Box2D は Nape より処理重いけど、メモリに関してこういうことはない

___

- Box2D よりマイナーなのが最大の弱点
    - Box2D は C の世界のやつをポーティングしたやつだからね
    - ドキュメントもコミュニティも Nape より強い
- コードが haxe （の独自プリプロセッサ？の caxe とかいうやつ）
    - 汎用言語 haxe から AS3 向けに出力する系なので、深追いするなら結構見たことないコード読まないといけない
    - メモリまわりの解読も結局この辺がネックで諦めた…

## AS3 の Box2D どうなの

- [Demo](http://box2dflash.sourceforge.net/)
- [ドキュメント](http://www.box2dflash.org/docs/2.0.2/manual#Creating_a_World)
- [Box2d Flash Alchemy Port + World Construction Kit](http://www.sideroller.com/wck/)

___

参考リンク
- [Box2D 2.1a Tutorial – Part 1](http://blog.allanbishop.com/box2d-2-1a-tutorial-part-1/)

___

- 個人的にはクラス名とか大文字小文字、細かいレベルでは Nape の方が綺麗で好き
    - ここはさすがに Nape の方が API の切り方とかも AS3 っぽくてよい
    - Nape は単位がメートルじゃなくてピクセルと割り切ってるのも使いやすくてよい
    - Box2D だと毎回表示単位のスケーリングの計算必要になる
- ドキュメンテーションは C++ の本家もあるし、Box2D の方がしっかりしてる感じある

___

- Nape の方が圧倒的にパフォーマンスはよい
    - Box2D だと負荷めっちゃ大きくなったときにガッタガタになってプルプルした動きになる
    - ひどい場合だと静止オブジェクト突き抜ける
    - Nape は重くなってもこのへんの整合性保ってる

### パフォーマンスや挙動

- パフォーマンスは確実に Nape の方が速い。負荷上がったときのガタガタ感も Nape の方が少ない
- Box2D はデバッグビルドだとすぐ重くなるので注意
    - Nape は debug=true でも速かった
- だがメモリ消費は Box2D の方が小さい
    - というか Nape が GC 対象にならず延々とメモリを食い続けてしまう問題がある
    - Box2D ではそんなことはなかった

### ハマったところ

- 以下みたいに type 指定しないと静止オブジェクトのままだった

        bodyDef.type = b2Body.b2_dynamicBody;

- HelloWorld のソース見ても書いてなかったし 2.0.2 のマニュアルにも見当たらなかったので分からんかった
    - って 2.1 で変わったところリストのページがあった。そこ見たら書いてあった

## Feathers どうなの

- [Feathers UI](http://feathersui.com/)

- [Good]
    - 一通り揃ってる感ある。Starling 用と割り切ってるのもいい

___

- [Not so good?]
    - theme が若干取り込みにくい。 ファイルが embed なのもなぁ。というかデフォルトスキンないのか
        - まあ自分で作れって話なんだろう。でも面倒だな
        - wiki に思想が書いてあった
            - [Why don't the Feathers components have default skins?](http://wiki.starling-framework.org/feathers/faq?&#why_don_t_the_feathers_components_have_default_skins)
        - テーマ使わず自前で作ろうとすると割としんどい
            - （いつかできるけど色々調べたり時間かかる。必要なコード量も結構ある）
            - ってかプロパティ多すぎて wiki と API Reference 探しまわる必要あり
            - theme のクラス見ればいいんだけど、これも結構ごっつい
    <br/><br/>
    - ボタンとかのアンカーの指定ってないのかなー

### ハマりポイント

- とりあえず FAQ は読んでおく
    - http://wiki.starling-framework.org/feathers/faq

___

- addChild するフレームで width とか height とるには validate 呼ぶ必要ある
    - まあそれは何となく想像つく
    - validate は addChild 後に呼ぶ必要あるので注意

### 悩みポイント

- 見た目整えようとするとなんだかんだコード量多くなる
    - 大規模開発で使うならこのへんの設定ファイル吐き出す Builder みたいなものが
      結局ほしくなっちゃうと思う

___

- フォント使うリストだと結構 Draw Call の数くっちゃうよね
    - [リストここで試してるよ](/krew-framework/laboratory)
    - 20 くらいいっちゃうのはさすがに見過ごせない
    - 画面外のアイテムとかは Draw Call 食ってないのでそこはまあ大丈夫

___

- リストアイテムで各セルごとにテクスチャ変えるとかは無理？
    - Accessory とか使うのでいけるっぽい？
    - 自分で ItemRenderer 書くみたいなこと頑張るとイケたけど大変すぎる

### 自前テーマ

- わりと自分でどうにかしろ系
    - button.defaultSkin とか downSkin とかに Image 指定してく感じ
        - 個別に指定できるので、まあゲーム開発ならそれでいいか
        - デフォルトだと透明の UI を作ってる感じだ
            - せめてなんか見た目的にわかるもの出してほしかったけどなー
        - Feathers 紹介記事
            - http://cuaoar.jp/2012/11/starling-stage3d-ui-feat.html
    - テーマ初期化用のクラス見れば雰囲気わかる
        - システム系で横断的に使う UI だなーとかなったらこっちにまとめるくらいでいいんじゃね
        - やるなら Embed 使わず、起動シーンでグローバルにアセット読み込んでから getTexture 的なことする

### 便利パーツ

- feathers.display に scale9Image あるね（たぶん 9patch な画像）
    - scale3 もある
    - UI じゃなくても使いどころありそう


## 立ち上げ時の背景色 2〜3 秒出るの気になるよね問題

- [Feathers のサンプルコード](https://github.com/joshtynjala/feathers/blob/master/examples/HelloWorld/source/HelloWorld.as)
  の showLaunchImage() が参考になる
      - Starling の初期化前に Flash の DisplayObject で画像 addChild してる感じかな

## 画像の解像度って

- できるだけ 1 枚にまとめたいけど、どれくらいのサイズまで安定して使えるんだっけ？
    - 要は端末の OpenGL のスペックによりけりだろうけど
    - Android がどれくらい 2048 x 2048 を許容できるか、がキモかな
    - 1024 x 1024 なら大抵大丈夫だからそれで頑張るか
        - その場合 960 x 640 の背景画像はそれだけで 1 枚みたいになっちゃうけど、まあ背景ならいいか

## Starling 使って思ったこと

### パフォーマンス

- シンプルさ（Flash の API っぽさ）を重視してて、そこまでパフォーマンスにこだわっていない感じ
    - 空間分割とかそういうのは無いっぽい。でかい DisplayTree は普通に重くなる（全部走査してる）
    - 走査中に alpha = 0 とか visible = false だったら行列計算の処理飛ばすくらいはやってる
    - width とか height の getter で重い行列計算が走る罠があるので注意

### タッチイベント

- DisplayObject のサイズとかで一思いにやっちゃってるのは初心者フレンドリーだけど扱い辛い
    - あと指でさわるとツリー上の全 DisplayObject なめるみたいで処理負荷大きかったのがイケてない
    - だから krewFramework では Actor はデフォルト touchable = false にした
- 関連した議論がここでされてる
    - http://forum.starling-framework.org/topic/rendering-performance-will-many-children

## Starling でタイルマップ効率よく描画するには

- 2 レイヤーくらいで合計 100 タイルくらいだったら各レイヤー QuadBatch すれば問題なさそう
- 当然だけど reset & addImage する頻度減らすほど効率よくなる
- とすると、ちっちゃいタイルを数百タイル表示したいような場合は？
    - 画面の数分の 1 くらいの領域のタイルごとに QuadBatch にまとめる
    - スクロールで入ってくる新しい領域ぶんだけ新しく QuadBatch を構成（他はスクロールだけ）

## Starling の TextField

- 中で QuadBatch 使ってる関係で、デフォルトでは TextField の数だけ Draw Call 増えてしまう
    - Text いっぱい並ぶ UI 画面とか普通に作ると（文字の描画だけが連続するようにしても）Draw Call めっちゃ増える
- **TextField.batchable を true にする** と、QuadBatch を使うのを避けられる。
    - 長い文字列を 1 回表示する場合は false のまま、
      短い文字列をたくさん表示する場合は true にすると処理効率がよい

> - 【参考】[Starling Forum](http://forum.starling-framework.org/topic/performance-bitmap-fonts-draw-count)
> - 【参考】[API Doc - TextField](http://doc.starling-framework.org/core/index.html?starling/text/BitmapFont.html&starling/text/class-list.html)

## Starling Topics

### たくさんスプライト出したい系

- [ImageBatch](https://github.com/elsassph/starling-imagebatch)
    - 公式にのってない Extension
    - こまかいパーティクル描画に使える
    - このデモたしかにパフォーマンスすごい

___

- [QuadtreeSprite](http://wiki.starling-framework.org/extensions/quadtreesprite)
    - 四分木で見えてるとこだけ DisplayList にのっけるようなスプライト
    - 広大なタイルマップ描画とかに使える

### Draw Call 減らしたい系

- [Dynamic Texture Atlas](https://github.com/emibap/Dynamic-Texture-Atlas-Generator)
    - 場合によってはシーン初期化時にテクスチャを動的生成するアプローチも考えられる
    - ランタイムコスト増えるが、アセットの開発フローが楽になる

## FlexUnit どうなの

- なんかバージョン色々あったり、1 年前にダウンロードした場所がなくなってたり、
  最新版っぽいのがドキュメントの URL 切れてたりで色々と切ない

### 参考リンク

- 最小構成で動かしたいときに以下が参考になった。
  古めの記事だけど新しいやつなんかうまく動かないし…
    - [FlexUnit4が使いたくなった。 (2009-6)](http://prepro.wordpress.com/2009/06/10/flexunit4%E3%81%8C%E4%BD%BF%E3%81%84%E3%81%9F%E3%81%8F%E3%81%AA%E3%81%A3%E3%81%9F%E3%80%82/)


## メモリのマネジメント

### GC

- Scout とか Starling のモニター見てたりする感じだと、律儀に null 入れてやったりするのは効果ありそう
    - System.gc() 呼んだときに解放されないものでも、時間が経つと解放されたりするので gc() 信用してはダメ
    - 循環参照してても、基本的に ROOT から辿れないものは GC 対象になるっぽいが、
      あまりに複雑に循環してる固まりが ROOT から浮いた状態になってると、GC は「諦める」らしい
    - お互い参照してるところ（何かを登録する系だとよくある）ではインスタンス破棄時に null 入れてあげよう

#### 参考リンク

- [Understanding Garbage Collection in AS3](http://flashvideotrainingsource.com/featured_post/hints-and-tips/understanding-garbage-collection-in-as3)

### インスタンスの消費メモリ

- flash.sampler.getSize(obj) で obj のメモリサイズ（Byte）がとれるよ！


## mp3 ってライセンス的にどうなんすかね

- 正式なところまだわかってない
    - フォーラムにも書き込みあるけど回答ない
- でも Flash / AIR って基本読み込めるの mp3 だしね…

___

- 商用利用じゃなければ関係ない
- ライセンス払うならゲームごとに 3750 ドル

___

- 参考リンク
    - [Ogg Vorbis Encoder + Decoder for Flash](http://labs.byhook.com/2011/02/22/ogg-vorbis-encoder-decoder-for-flash/)
    - [Even more about audio licenses on the web](https://www.scirra.com/blog/65/even-more-about-audio-licenses-on-the-web)
    - [Flashで外部swfに埋め込んだサウンドをBGMにする](http://itouhiro.hatenablog.com/entry/20130326/flash)

### mp3 どうしても避けたいなら

- .fla にライブラリで wav 読み込んで、書き出しの設定を mp3 じゃなく raw にする
    - swc に書き出して、ゲームではそこから音源を読み込む
    - ファイルサイズの比較
        - mp3 44 kHz / Stereo / 128 kbps で swc にすると 1 分 0.8 MB くらい
        - wav 22 kHz / Stereo で swf にすると 1 分 5.0 MB 弱くらい
    - wave でやると周波数半分で 6 倍くらいファイルサイズ大きい。
      単純に非圧縮か。これは使えないな…

___

- もしくは ANE 書く
    - 誰もそんなことやりたがらないけど


## zip のダウンロードとかアップロード

- 参考リンク
    - [ActionScript 3.0 でZIPの圧縮と解凍](http://un-q.net/2009/06/actionscript_30_zip_as3.html)
    - [AS3でデータ圧縮するならZipのライブラリよりByteArray.compress](http://un-q.net/2009/07/as3_zip_bytearray_compress.html)
    - [Quick Tip: Use FZip to Open Zip Files Within AS3](http://code.tutsplus.com/tutorials/quick-tip-use-fzip-to-open-zip-files-within-as3--active-10660)


## 実機でのファイルの保存先ってどうするのが正しいの

### iOS の参考リンク

- [(kamijo さんの blog) iOS データ保管ガイドラインの変更と Adobe AIR への影響](http://cuaoar.jp/2011/11/ios-air.html)

> 1. ユーザが生成した情報、またはアプリだけでは生成できない情報のみ /Documents ディレクトリ以下に保存し、自動的に iCloud にバックアップされる
> 1. 再ダウンロード、あるいは再生可能なデータは **/Library/Caches** ディレクトリ以下に保管する
> 1. 一時的な利用のためのデータは /tmp ディレクトリ以下に保存する。これらのファイルは iCloud にはバックアップされないが、余分な記憶領域を使用しないよう、不要になったら削除する

- 2 はこうとれるけどマジか

        var path:String = File.applicationDirectory.nativePath + "/\.\./Library/Caches";
        cacheDir = new File(path);


### Android の参考リンク

- [(Adobe 公式) Android の設定 - インストールの場所](http://help.adobe.com/ja_JP/air/build/WSfffb011ac560372f-5d0f4f25128cc9cd0cb-7ffc.html#WS901d38e593cd1bac-476b1d7312aca7bcda1-8000)

> 外部メモリにインストールした場合でも、アプリケーション記憶域ディレクトリの内容、共有オブジェクト、
> 一時ファイルなどのアプリケーションキャッシュおよびユーザーデータは、内部メモリに保存されます。
> 内部メモリを使用し過ぎないように、アプリケーション記憶域ディレクトリに保存するデータは慎重に選択してください。
> **大量のデータは File.userDirectory または File.documentsDirectory の場所を使用して、**
> SD カードに保存してください（これらの場所は両方とも Android の SD カードのルートにマッピングされます）。

### app-storage: ってあれどこに保存されるの

- [(Adobe 公式) アプリケーション記憶領域ディレクトリの参照](http://help.adobe.com/ja_JP/as3/dev/WS5b3ccc516d4fbf351e63e3d118666ade46-7fe4.html#WS5b3ccc516d4fbf351e63e3d118676a4c56-7fc6)
    - Mac, Win, Linux, Android の説明がある
    - **Android は内部ストレージを食うことに注意**

### とはいえ結局

- 世の中のアプリは Android の内部ストレージに保存してる
- 2011 年頃に内部ストレージなさすぎのイケてない端末（acro とか）あったけど、もう時効かな
- 長期でプレイして累計 200 MB くらいまでなら保存してもよいかな
- iOS で iCloud 対象になっちゃうところが気になるくらい

## フォントの埋め込みとかってどうやるの

- Embed ってしたくないんだけど
- swf に埋め込んで動的に読み込む
    - [AS3 で埋め込みフォントを使うテクニック](http://tech.nitoyon.com/ja/blog/2008/07/23/as3-embed-font/)

## Adobe Scout

- かなりイケてるプロファイラ
    - これ使えるってだけで AIR 使いたくなるレベル
    - 単独アプリで立ち上げとくだけでいいってのも使いやすい
        - adl でも web 上で動かしてるやつでもいける
    - Stage3D の描画命令も送ってるので、全フレームのその時点での画面も追える（これがすごい）
    - メモリの内訳や関数ごとの処理時間の内訳もかなり見やすい

___

- 実機プロファイリングには使えるのか？
    - ある程度は使える。重い画面が続くと telemetry を送るための
      CPU・メモリ負荷の方が大きくなりすぎて実用に耐えないので注意
    - 見たいところをピンポイントで見るとかならまあ。あとは FPS を下げとくとか？

___

- 実機プロファイリングのやり方
    - Android / iOS 実機と Mac を同じネットワークにつなぐ
    - Mac の Scout を立ち上げておく
    - 実機に Scout のコンパニオンアプリをインストールしておく
    - コンパニオンアプリ起動して Enable すると自分の Mac が出てくるので選択
    - AIR アプリを起動



