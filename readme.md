This project's aim is to implement function in **ASSEMBLY**.

When you create archive file, you should
```Makefile
make
```

When you test with main.c, you should
```Makefile
make test && ./main
```

## libasm

アセンブリで関数を書いてみる

## アセンブリとは
アセンブラによって機械語 (コンピュータが実行できるフォーマット)に翻訳される言語

## Cコードが実行ファイルになる流れ (C プロトタイプ風)
assembly    C_compiler(C_source_code);
executable  assembler(assembly);
**アセンブリは機械語になるまでの中間表現! コンパイル言語がみな通る道(おそらく)**

## 実際のアセンブリのコード
アセンブリの一命令(一行)をニーモニックという
<ニーモニック> ::= <オペコード> <オペランドリスト>
<オペコード> ::= 関数のようなもの ex: mov, add, sub
<オペランドリスト> ::= <オペランド> <オペランドリスト> | <オペランド>
<オペランド> ::= <定数> | <レジスタ> | <メモリから参照して取れる値>

ex: mov, rax, 1 (オペコード, レジスタ, 定数)

他にも条件分岐や, 他の関数を呼ぶためのオペコードなどが存在する

## システムコールとは
カーネルのプログラムを呼ぶこと

write, read, open

カーネルのプログラムにはユーザーは直接アクセスできない
なぜか
- プロセスはそれぞれが独自のテキスト領域(関数の定義)を持っている
- プロセスのメモリ領域はお互い独立していてアクセスできない

プロセスのモード :== <ユーザーモード> | <カーネルモード>

カーネル .text

write
...

read
...


## 変数とは

可変なプロセスのメモリ領域に確保された (概ねstack) 特定のメモリ

errno はdata 領域にあるはず
じゃあ
errno を宣言する場所として
- ユーザモードのメモリ (answer)
- カーネルモードのメモリ

ユーザモードのメモリ(errno) を誰が編集するか
- ユーザー側
- カーネル側

ゆーざ

strdup INT_MAX でなぜか terminated

stdin 入力 read ブロック size未満

