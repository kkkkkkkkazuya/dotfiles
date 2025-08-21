# claude

## コマンド
例: `claude mcp add context7 -s project -- npx -y @upstash/context7-mcp`

### sオプション
1. local（デフォルト）

適用範囲: 現在のプロジェクトディレクトリでのみ利用可能
設定場所: プロジェクトのユーザー設定
用途: 個人的な開発サーバー、実験的な設定、機密情報を含むサーバー

2. project

適用範囲: プロジェクト全体で共有、チーム全体が利用可能
設定場所: .mcp.jsonファイル（プロジェクトルート）
用途: チーム共有のツール、プロジェクト固有のMCPサーバー

3. user（global）

適用範囲: すべてのプロジェクトで利用可能
設定場所: ユーザーのグローバル設定
用途: 個人的によく使うツール、汎用的なMCPサーバー

## knowledge
Claude Desktop:
設定ファイル: `~/Library/Application Support/Claude/claude_desktop_config.json`
Claude Code:
設定ファイル: `.claude.json`

## claude code mcp
### github
`claude mcp add -s user --transport http github-server https://api.githubcopilot.com/mcp -H "Authorization: Bearer $GITHUB_PERSONAL_ACCESS_TOKEN"`
### aws document
`claude mcp add -s user aws-documentation-mcp-server uvx "awslabs.aws-documentation-mcp-server@latest"`
### context7
`claude mcp add context7 -s user -- npx -y @upstash/context7-mcp`
### playwright
`claude mcp add playwright -s project -- npx -y @playwright/mcp@latest`
