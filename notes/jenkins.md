---
title: 'Jenkins 2.0'
date: '2016-10-06'
description:
categories: []
tags: [anything, Tips, Jenkins]
position: 6
---

# Jenkins 2.0 Memo

## リンク集

- 公式
    - [Jenkins](https://jenkins.io/)
    - [Jenkins Documentation](https://jenkins.io/doc/)
- リファレンス
    - Pipeline の Groovy 書くときの公式リファレンス
        - [Pipeline Steps Reference](https://jenkins.io/doc/pipeline/steps/)
    - 公式リポジトリのチュートリアル
        - [pipeline-plugin/TUTORIAL.md at master · jenkinsci/pipeline-plugin](https://github.com/jenkinsci/pipeline-plugin/blob/master/TUTORIAL.md)
- ハンズオン系記事
    - [Jenkins 2の新機能「Pipeline」を使ってみよう - Build Insider](http://www.buildinsider.net/enterprise/jenkins/005)
    - [Jenkins 2.0 Pipeline as Code | GMOインターネット 次世代システム研究室](http://recruit.gmo.jp/engineer/jisedai/blog/jenkins-2-pipeline-as-code/)
    - [Jenkins2でPipelineジョブのサンプルを実行する - システム開発現場の道具箱](http://blog.monocrea.co.jp/entry/2016/05/22/145817)
    - [Jenkins2.0のPipelineを触ってみたら便利だった - be-hase blog](http://be-hase.hatenablog.com/entry/2016/04/28/175311)
- スライド
    - [Jenkins 2.0 (日本語)](http://www.slideshare.net/kohsuke/jenkins-20)


## Mac にインストール

    # * 先に java 入れとく

    # コマンドラインで入れるなら
    $ brew install jenkins

    # 起動
    $ jenkins --httpPort=8080

- `localhost:8080` にアクセスすると初期設定用の画面が出てくるので画面に従いユーザなどを設定する


## Pipeline

- 前からプラグインであったらしいけど Pipeline が Jenkins 2.0 で標準搭載に
- ジョブの内容を **Groovy** な DSL で書ける（書いたファイルを **Jenkinsfile** と呼ぶ）
    - ジョブの設定で「このリポジトリのこの Jenkinsfile を checkout して実行」みたいにできる
    - 想定されてるのはリポジトリのブランチごとのビルドやテストを CI で回す使い方かな

____

- ジョブのフェーズを stage として定義できる
    - ジョブの実行状況が stage 単位で表示されるので進捗が見やすく、どこでエラーが出たかわかりやすい


## Jenkinsfile の書き方

### 基本イメージ

    // node 単位で Workspace が作られる感じ
    node('master') {
        //--------------------------------------------------------
        // フェーズごとに stage って書くと進行状況やログが stage 単位で表示される
        stage('Checkout Repo.') {

            // ワークスペースにコードベースを checkout
            git branch: 'master', url: 'git@github.com:hoge/fuga.git'

            // * ジョブに SCM が設定されている場合はこう書いてもいい
            checkout scm
        }

        //--------------------------------------------------------
        stage('Experiment') {

            // 単なる echo
            echo 'hello'

            // 変数展開（env で環境変数にアクセス）
            echo "build id: ${env.BUILD_ID}"

            // シェルの実行
            sh 'echo hello'

            // シェルスクリプト実行（checkout したリポジトリの root からのパスで指定）
            sh './path/to/script.sh'
        }
    }

## Groovy Tips

※ あんまり慣れてないので真っ当なやり方かわからんけどとりあえず…

### 文法系

    // 空ハッシュ
    def obj = [:]
    obj.hoge = 'fuga'

    // ハッシュの走査
    obj.each { key, value ->
        ...
    }

    // エルビス演算子（a が偽なら b）
    result = a ?: b

### 別の .groovy 読み込みたい

    # workspace@script/ みたいなディレクトリに Jenkinsfile のある
    # リポジトリが checkout されるので
    def script_dir = pwd() + '@script'
    load "${script_dir}/pipelines/chaos_centurions/build_settings.groovy"

### 外部ファイルの関数呼び出すのは？

    //---------- utils.groovy ----------
    def hoge() {
        ...
    }
    return this

    //---------- 呼び出し側 ----------
    def utils = load "${script_dir}/hoge.groovy"
    utils.hoge()

### Slack 通知する関数

※ 要 Slack Notification Plugin

    def notifySlack(String buildStatus='STARTED') {
      // build status 'null' means successful
      buildStatus =  buildStatus ?: 'SUCCESSFUL'
    
      def colorCode = 'good'
      def subject   = "${buildStatus}: *${env.JOB_NAME} #${env.BUILD_NUMBER}*"
      def summary   = "${subject} - <${env.BUILD_URL}|Open>"
    
      switch (buildStatus) {
      case 'STARTED':
        colorCode = '#dddd00'
        break
      case 'SUCCESSFUL':
        colorCode = 'good'
        break
      default:
        colorCode = 'danger'
        break
      }
    
      slackSend(color: colorCode, message: summary)
    }

____

失敗時にもちゃんと通知したいなら try catch で括るとよい

    try {
        notifySlack('STARTED')

        /** Your Task */

    } catch (e) {
        currentBuild.result = 'FAILED'
        throw e
    } finally {
        notifySlack(currentBuild.result)
    }

### workspace 外にある成果物を保存したい

シンボリックリンク貼るとかが手軽な気がする

    sh "ln -fs ${EXTERNAL_PATH} ."
    archiveArtifacts allowEmptyArchive: true,
                             artifacts: "path/to/result"


## トラブルシュート

### (2016-10-06) なんか Groovy で each したら変なエラー出る

こんなん言われる：

    java.io.NotSerializableException: java.util.LinkedHashMap Entry

関係あるかもしれないリンク：

- https://groups.google.com/forum/?utm_medium=email&utm_source=footer#!msg/jenkinsci-users/UwN39RI06S0/ED39ayfQMgAJ
- https://issues.jenkins-ci.org/browse/JENKINS-26481

以下の書き方ではエラーが出てしまった（Groovy の文法的には問題ないはずだが）：

    // エラーが出るパターン 1
    obj.each { key, value ->
        ...
    }

    // エラーが出るパターン 2
    for (item in obj) {
        ...
    }

____

仕方ないので不本意だけど

    def keys = obj.keySet() as String[]
    for (int i = 0; i < keys.length; ++i) {
        ...
    }


### (2016-10-06) Boolean のビルドパラメータで false 渡したはずなのに

false 渡したのに `(!BOOL_PARAM)` が false なんですけど… というとき

- 実は文字列 `"false"` で渡ってきているのだ！！

        // こう書こう
        if (BOOL_PARAM == 'false') { ... }



