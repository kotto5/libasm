## ファイルとは何か

ファイルとは、ファイルシステム上の扱う単位である

## ファイルシステムとは何か

ブロックデバイスを構造的に扱うためのシステムである。ファイル、ディレクトリという概念で構成されている

## ブロックデバイスとは何か

データの読み書きがブロック単位で、ランダムに行えるデバイスのこと
ストレージ。内蔵SSD, 外付けHHD が例
デバイス = ブロックデバイス | キャラクタデバイス
**今回はブロックデバイスに関するファイルの話**


## ブロックデバイスをファイルシステムで管理する利点
スワップ領域はファイルシステムを利用せずにブロックデバイスにアクセスしている
- 木構造の名前空間
- 木構造と組み合わせたアクセス制限

## スワップとは
プロセスの一部の情報を、メモリからストレージに出し入れすることである
プロセスが増えたり、休眠状態、あるいは重要度の低いプロセスを対象にしたりする
限られたメモリを有効活用するための手段である
スワップ領域 map(id, data) で管理してるんじゃないかな? って思ってます。分かりません。実装に依存してるし

## ファイルシステムと map 管理との違い
- 構造的な管理が出来るか
- アクセスが早いか (ファイルシステムだと、ディレクトリ名で追っていく必要がある)

# ファイルシステムについてもう少し詳しく

## ファイルとは
ブロックデバイスのブロックの集合を管理するための概念
ファイル = inode + データ
inode = ファイルサイズ + アクセス権限 + ブロック番号(ブロックデバイスのアドレス)

## ファイルに書き込むときに起きていること

1. inode を取得する
2. inode から該当するブロック番号を取得する
3. ブロック番号に書き込みを行う

## その他面白かったこと
- カーネルって具体的に何?
今までは、カーネルプロセス みたいなユニークなプロセスが居るのだと思ってた。
実際は, プロセスにはユーザーモードとカーネルモードという二つの状態がある。
カーネルモードでは、カーネルプログラムにアクセスできる。システムコール関数のこと(他にもあるかも)

- 仮想メモリ

- プロセスのデータ構造

- "引数" の実装方法

- コンテキストスイッチは user構造体のコピー

## OS周りの本を読んでて思ったこと

- 今までバラバラだった知識が繋がって面白い (仮想メモリの仕組み自体は知っていたが、カーネルと絡むのは知らなかった)

- カーネルとは、物理メモリとプログラムのインターフェース

- 今回はUNIX V6 というOSについて調べたが、どのOSも実装例に過ぎない。Unixが無くなっても活用できる知識はあるし、Unixのそのバージョンでしか活用できない内容もある (〇〇構造体は△△メモリにある とか)