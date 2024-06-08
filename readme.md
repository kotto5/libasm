This project's aim is to implement function in **ASSEMBLY**.

When you create archive file, you should
```Makefile
make
```

When you test with main.c, you should
```Makefile
make test && ./main
```

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

