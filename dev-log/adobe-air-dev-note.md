---
title: 'Adobe AIR ゲーム開発メモ'
date: '2013-12-16'
description:
categories: []
tags: [anything, Game-Development, Adobe-AIR]
position: 110
---

# Adobe AIR ゲーム開発メモ

## リンク集

- AIR / Flash ニュース
    - [Android端末をFlashゲームのコントローラーに！Adobe AIR 15の新機能AIRGamepad機能を使ってみよう – ICS LAB](http://ics-web.jp/lab/archives/3947)

___

- ゲームエンジン / フレームワーク
    - [Citrus Engine: Creating Level using Tiled Map Editor](http://pzuh.blogspot.jp/2013/05/citrus-engine-creating-level-using.html)
    - [Ash entity framework](http://www.ashframework.org/)

___

- ツール開発
    - [Starling Forum - Integrated non tile-based map editor](http://forum.starling-framework.org/topic/integrated-non-tile-based-map-editor)
    - [SoundQuest, a journey in the extraordinary world of game development and Stage3D](http://blog.open-design.be/2012/03/25/soundquest-a-journey-in-the-extraordinary-world-of-game-development-and-stage3d/)

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
    - [nekobit.eu](http://www.nekobit.eu/)
        - おもしろい Demo が色々

___

- AS3 とか Starling とか読み物とか
    - [akihiro kamijo さんのブログ](http://cuaoar.jp/)
        - Adobe の中の人
    - [(blog) Pierre Chamberlain](http://pierrechamberlain.ca/blog/)
        - CRT ディスプレイな shader が素敵
    - [Adobe Flash Platform](http://www.scoop.it/t/adobe-flash-platform)
        - AS3 / AIR / Stage3D まわりの情報
    - [TypedArray.org](http://typedarray.org/)
        - サイトデザインがおしゃれ
    - [Quick As A Flash: Optimization Strategies for AS3 and Flash](http://gskinner.com/talks/quick/)
        - AS3 / Flash のパフォーマンスのスライド（ちょっと古い）
    - [Pete Shand | Flash and New Media](http://blog.peteshand.net/)
        - Haxe とか Starling + Away3D とか

___

- Stage3D
    - [EL-EMENT](http://el-ement.com/)


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

### Array から Vector への変換

こんな書き方をする

    var vector:Vector.<String> = new <String>["a", "b", "c"];

またはビルトインの Vector のグローバル関数を使う。
これは Vector から型の違う Vector への変換にも使える。

    var array:Array = ["a", "b", "c"];
    var vector:Vector.<String> = Vector.<String>(array);

> 【参考】[Vector の新しい初期化方法 （Flex 4 & Flash Professional CS5）](http://cuaoar.jp/2010/09/vector-flex-4-flash-professional-cs5.html)


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

## 圧縮テクスチャ

- 各プラットフォーム向けの圧縮テクスチャまとめてくれる ATF (Adobe Texture Format) ってのがある
- [きれいなATF (Adobe Texture Format)ファイル の作り方 - Togetter](http://togetter.com/li/555871)


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


## バッテリー消費

- ある程度エネルギー食いなのは AIR 依存で仕方ないかなー
    - Android とか AIR 上で中間コード実行する感じだしね
    - iOS はネイティブコードに変換されてるのでマシかな
- スリープ時も、実は FPS 4 でスクリプトが動いてる
    - [AIR アプリケーションにおける Android のホーム、メニュー、サーチ、バックキーの処理方法](http://www.adobe.com/jp/devnet/air/articles/air_android_virtualkey.html)


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

___

- いや AIR 3.6 (2013 年 3 月) からこれでいける

        File.cacheDirectory.nativePath;

___

- もしくはファイル単位で iCloud 対象にならないように指定
- AIR 3.6 以降、iOS 5.1 以降で利用可能
- ディレクトリに対して使えばそのディレクトリ以下全て iCloud 対象じゃなくできる

        var foo:File;
        foo = File.applicationStorageDirectory.resolvePath("foo.txt");
        foo.preventBackup = true;


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

### Mac での開発時、SharedObject ってどこに保存されてるの

    /Users/your.name/Library/Application\ Support/com.your.app-id/Local\ Store/

- app-storage: で保存したアセットや sqlite のファイルもここに保存される

## フォントの埋め込みとかってどうやるの

- Embed ってしたくないんだけど
- swf に埋め込んで動的に読み込む
    - [AS3 で埋め込みフォントを使うテクニック](http://tech.nitoyon.com/ja/blog/2008/07/23/as3-embed-font/)

## AIR の WebView

- [モバイルアプリケーションでの HTML コンテンツの表示](http://help.adobe.com/ja_JP/as3/dev/WS901d38e593cd1bac3ef1d28412ac57b094b-8000.html)
- [StageWebView differences between platforms](http://helpx.adobe.com/air/kb/stagewebview-differences-platforms-air-sdk.html)

### BASIC 認証

- どうやら StageWebView だと BASIC 認証通せないっぽい？
    - `http://user:pass@...` みたいに埋め込んでみてもダメだった
- URLRequest は普通に Request Header に渡してやれば通るけど


## iPad の Retina ってそこまで対応しなくね

- config の xml に以下を足すと、「新しい iPad」において
  2048 x 1536 ではなく 1024 x 768 ターゲットで描画を行う

___

    <requestedDisplayResolution excludeDevices="iPad3">high</requestedDisplayResolution>

___

- 当然こちらの方が描画パフォーマンスは上がる
- フォントや解像度高く入れた画像は iPad 〜 iPad2 相当の見た目になるが、概ね気にならないだろう
- スマフォターゲットだと iPhone 4 の 960 x 640 レベルでゲームの画面を作ることが多いと思うので、
  パフォーマンスを優先するならやっておいてもよい
- iPad Air 系列も Retina 避けたいなら "iPad4" を指定する

> - 【参考リンク】http://cuaoar.jp/2012/12/flash-player-116-adobe-a.html




