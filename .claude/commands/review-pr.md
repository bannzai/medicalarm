# PR Review Command

このコマンドはPRのコードレビューを5つの観点から並列で実行します。

## 許可するツール
- Bash(gh:*)
- Bash(jq:*)
- Read
- Glob
- Grep
- WebFetch
- Task
- mcp__github_inline_comment__create_inline_comment

## 実行手順

1. まずCLAUDE.mdを読み込み、プロジェクトのルールを理解してください
2. `gh pr view --json number,headRefName,baseRefName` でPR情報を取得してください
3. `gh pr diff` でPRの差分を取得してください
4. 以下の5つのサブエージェントを**並列で**実行してください：

### サブエージェント一覧

| エージェント | ファイル | 役割 |
|------------|---------|------|
| Code Quality | .claude/agents/code-quality-reviewer.md | 可読性、メンテナンス性、コーディング規約 |
| Performance | .claude/agents/performance-reviewer.md | パフォーマンス、ボトルネック |
| Test Coverage | .claude/agents/test-coverage-reviewer.md | テストカバレッジ分析 |
| Documentation | .claude/agents/documentation-accuracy-reviewer.md | ドキュメント精度 |
| Security | .claude/agents/security-code-reviewer.md | セキュリティ脆弱性 |

5. 各サブエージェントは `mcp__github_inline_comment__create_inline_comment` を使用して、該当コード行に直接コメントを追加してください

## レビュー時の注意事項

- 指摘は具体的で建設的なものにしてください
- 可能な場合は修正案（suggestion）を提示してください
- 重複した指摘は避けてください
- CLAUDE.mdのプロジェクト固有ルールを遵守してください
