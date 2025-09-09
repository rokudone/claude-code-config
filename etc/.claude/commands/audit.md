
# 差分を監査し、要件検証を指示せよ

**追って指示をだします。まだ作業をしないでください。**

## 概要と全体原則

指定されたブランチ（BASE）から現在の作業ブランチ（HEAD）までの差分を解析し、そこから「想定される要件（仮説）」を組み立てる。続いて、その要件を満たしているかを**ファイル出力ベースで監査**できるよう、計画と成果物を作成する。
Debugging Workflowに準拠して進めること。**コードの書き換えやビルド実行は行わない。**

---

### Stage 0: 準備フェーズ

- `git rev-parse --show-toplevel` でプロジェクトルート確認
- 出力先ルートを `.agent/audits` とする
- タイムスタンプ取得 → ディレクトリ作成（必ず単独で実行）
- 動的な値は事前に取得してから使う
- このフェーズは承認不要

---

### Stage 1: 計画フェーズ

- 差分監査の目的と範囲を定義
- 観点を列挙（仕様意図・影響範囲・IF変更・例外処理・テスト）
- 成果物の雛形を定義

#### Gate 1: 計画確認

- 計画を要約し承認を求める
- 承認後のみ Stage 2 へ進む

---

### Stage 2: 差分収集フェーズ

- fetch → 差分・統計・パッチ・コミットログ保存
- BASE/HEAD のスナップショット保存
- TODO/FIXME 抽出（任意）
- 収集物はすべて `raw/` 以下に配置する

#### Gate 2: 収集確認

- `raw/` ディレクトリの中身を提示し承認を求める
- 承認後のみ Stage 3 へ進む

---

### Stage 3: 要件仮説構築フェーズ

- **`expected_requirements.md`**  
  - 差分から推定した要件を整理  
  - REQ-ID, 背景, 機能/非機能, 受け入れ基準, 根拠（`raw/` の参照）

- **`verification_plan.md`**  
  - 各 REQ-ID ごとの検証観点  
  - 必要証拠（`raw/` 内ファイル名と対象行）  
  - 確認手順と期待シグナル

#### Gate 3: 仮説確認

- `expected_requirements.md` と `verification_plan.md` を提示し承認を求める
- 承認後のみ Stage 4 へ進む

---

### Stage 4: 静的監査フェーズ

- `verification_plan.md` に従い検証を実施
- 結果を **`verification_results.md`** に記録  
  - REQ-ID ごとに観測事実の引用（`raw/` の断片）  
  - 判定（可/否/要確認）  
  - 差分要約

#### Gate 4: 最終確認

- `verification_results.md` を提示し結論を要約
- 必要に応じて再計画（Stage 1 へ戻る）

---

## 成果物一覧

```

OUTDIR/
├── raw/                        # 生データ（監査証跡）
│    ├── changed\_files.txt
│    ├── diffstat.txt
│    ├── diff.patch
│    ├── commits.txt
│    ├── snapshots/
│    │    ├── BASE/...
│    │    └── HEAD/...
│    └── notes\_grep.txt   (任意)
├── expected\_requirements.md     # 要件仮説
├── verification\_plan.md         # 検証手順
└── verification\_results.md      # 検証結果

```

---

## 重要

**追って指示をだします。まだ作業をしないでください。**
