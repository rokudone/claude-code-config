# 🟢🟡🔴Stage-Gate Process🟢🟡🔴

## 概要と全体原則

Stage-Gate Process は、検証主義（憶測ではなく検証する）に基づく段階的な開発手法です。
- 各Stageで成果物を作成し、Gateでレビューを受ける
- Gateステップでは `exit_plan_mode` ツールを実行して計画承認を得る

## 標準Gateプロセス

各Gateでは以下を実施：
1. Claude Codeがユーザーに対して成果物を提示
2. ユーザーが確認し、問題があればフィードバック
3. 問題がないと答えるまで修正を繰り返す

## Stage-Gate フロー

### Stage 0: 準備フェーズ

- ユーザーがClaude Codeに対して、実行したいタスクの概要を伝える
- `git rev-parse --show-toplevel` でプロジェクトルート確認
- specディレクトリを作成
    - ステップ1 まず date コマンドで時刻を取得
        - `date +"%Y-%m-%d_%H-%M-%S"`
    - ステップ2 その結果を使って mkdir -p を実行
        - `mkdir -p /path/to/.agent/specs/2025-08-20_14-45-58-feature-name/`

  - mkdir -p はパイプで繋がず必ず単独で実行すること
- mkdir -p はパイプで繋がず必ず単独で実行すること そうしないと余計な確認が挟まります
- 動的な値は先に取得してから使うこと そうしないと余計な確認が挟まります

### Stage 1: spec.md作成ステージ

- 要件定義ステージ（Joel Spolsky式 + EARS表記法）
- Taskツールを用いて並列に調査を行う
- ユーザーから伝えられたタスクの概要に基づいて、タスクが満たすべき「spec.md」ファイルを作成

#### spec.mdの例
```markdown
# 要件定義書

## 概要
この機能は、プロジェクトテンプレートシステムを強化し、より良いテンプレート管理、テンプレート編集のUI改善、の修正を提供します。

## 要件

### 要件1
**ユーザーストーリー:** ユーザーとして、新しいプロジェクトテンプレートを準備・編集したい。

#### 受け入れ基準
1. テンプレート管理インターフェースにアクセスしたとき、システムは新しいテンプレートを作成するオプションを提供する
2. 新しいテンプレートを作成するとき、システムは初期タスク、プロジェクト構造、設定を定義できるようにする
```

### Gate 1: spec.md承認ステージ
標準Gateプロセスを実施（spec.mdのレビュー）

### Stage 2: design.md作成ステージ

- 設計ステージ
- Joel Spolsky式
- Taskツールを用いて並列に調査を行う
- spec.mdをベースに「design.md」ファイルを作成

#### design.mdの例
```markdown
# 設計書

## 概要
プロジェクトテンプレートシステムの強化により、テンプレート管理の改善を実現します。

## アーキテクチャ
\```
UI Layer
├── ProjectTemplateManager.tsx (専用ポップアップ)
├── TemplateEditModal.tsx (新規作成)
└── TaskColumn.tsx (横スクロール対応)
\```

## 主要コンポーネント
### 1. ProjectTemplateManager.tsx
\```typescript
interface ProjectTemplateManagerProps {
  onApplyTemplate: (projectName: string, templateId: string) => void;
  isOpen: boolean;
  onClose: () => void;
}
\```
```

### Gate 2: design.md承認ステージ
標準Gateプロセスを実施（design.mdのレビュー）

### Stage 3: tasks.md作成ステージ

- 実装計画ステージ
- Taskツールを用いて並列に調査を行う
- spec.md、design.mdをベースに「tasks.md」を作成

#### tasks.mdの例
```markdown
# 実装計画

- [ ] 1. TemplateEditModal コンポーネントの作成
  - 専用のテンプレート編集ポップアップモーダルを実装
  - 新規作成モードと編集モードの両方をサポート
  - _要件: 2.1, 2.2, 3.1, 3.2_

- [ ] 2. ProjectTemplateManager の編集機能分離
  - 右パネルから編集フォームを削除
  - _要件: 2.1, 2.3_
```

### Gate 3: tasks.md承認ステージ
標準Gateプロセスを実施（tasks.mdのレビュー）

### Stage 4: 実装ステージ（Kent Beck式TDD）

- spec.md、design.md、tasks.mdを元に実装を開始
- tasks.mdに基づいて実装を進める
- 要件と設計に記載されている内容を守りながら実装

### Gate 4: 実装確認ゲート
実装結果をユーザーに確認してもらう。必要に応じて前のステージに戻る

### Stage 5: クリーンアップステージ

- 開発中に作成した一時ファイルの削除
- デバッグ用のconsole.logやコメントアウトされたコードの削除
- 不要なimport文の削除
- コードフォーマットの適用（prettier、eslint等）
- TODOコメントの確認と処理
- テスト用のモックデータやダミーファイルの削除
- `.agent/specs/` 内の作業ファイルの最終確認とアーカイブ

### Gate 5: 最終確認ゲート
- クリーンアップ結果の確認
- 全ての要件が満たされているかの最終確認
- 本番環境へのデプロイ準備完了の確認

## 必須出力フォーマット

技術的な作業（実装、修正、調査など）の応答には🟢🟡🔴のいずれかの絵文字を含め必ず冒頭に以下を表示：

```
🟢 Stage-Gate状態 🟢
現在: Stage X - {ステージ名}
状態: {未着手|進行中|完了}
次: {具体的なアクション}
```
