---
scope: cross-repository
recorded: 2026-11-10
---
# 長く放置された PR の競合は、解消する前に同じ機能が origin/main に入っていないかを確かめる

長く放置された PR で競合が出た時、同じ機能が別の PR で `origin/main` に入っていることがある。その時は競合を解消せず close する。競合したファイルだけを見ると普通の競合に見え、競合せずに自動マージされるファイルの方に壊れた結果が入る。

実測 (2026-11-10。close 済みの PR #260 の head `f9162f1` と、その日の `origin/main` の commit `a2c2e5c`):

```sh
git fetch origin a2c2e5c068c02d8a9f30d21fce3a473ec6ba789b f9162f1f57eadf46b26ac0cdc1ef2a31aabb1063
git merge-tree --write-tree a2c2e5c068c02d8a9f30d21fce3a473ec6ba789b f9162f1f57eadf46b26ac0cdc1ef2a31aabb1063
# 1 行目にツリーの ID (847299a…)、続けて競合したファイル。exit code は競合があると 1
# 「Auto-merging ios/Runner/Runner.entitlements」「Auto-merging lib/main.dart」は CONFLICT にならない
git show 847299ade69add016448da49f039d8f05cb8d638:ios/Runner/Runner.entitlements
# com.apple.developer.devicecheck.appattest-environment のキーが 1 つの dict に 2 回現れる
git grep -n -i appcheck 847299ade69add016448da49f039d8f05cb8d638 -- lib/main.dart
# lib/main.dart:85: await activateFirebaseAppCheck(isDebugMode: kDebugMode);  (main 側)
# lib/main.dart:91: await activateAppCheck();                                 (PR 側)
```

**なぜ:** PR #260 (Firebase App Check の導入。2026-08-08 作成) の競合の解消を 2026-10-28 に指示された時、App Check は PR #338 (2026-09-09 マージ) で main に実装済みだった。競合した 5 ファイルを解消しても、競合しない `lib/main.dart` では App Check の有効化が 2 回呼ばれ、`ios/Runner/Runner.entitlements` は同じキーが重複した plist になっていた。#260 は解消せず close した。

**どう使う:**

- 以下のコマンドは、`git fetch origin main` で `origin/main` を最新にし、PR のブランチを checkout した状態 (`HEAD` が PR の head) で実行する
- 競合したファイルを読む前に、PR が触る全ファイル (`git diff origin/main...HEAD --stat`) について、PR の変更に当たるものが main 側にあるかを調べる。全部あれば close する
- 競合しないファイルの自動マージ結果は、`git merge-tree --write-tree origin/main HEAD` が返すツリーを `git show <ツリーの ID>:<パス>` で読めば、merge せずに検査できる
- close する時は remote のブランチを残して `gh pr reopen` で戻せるようにし、PR body の「人間が確認」の未解決の項目の引き継ぎ先を close のコメントに書く
