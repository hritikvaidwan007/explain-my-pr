# explain-my-pr

Agent skill plugin that teaches coding agents to write **merge-request explanation documents** for leads and managers — plain language, before/after code, reviewer checklist, suggested commit message.

Follows the [Agent Skills](https://agentskills.io/specification) layout used by [Superpowers](https://github.com/obra/superpowers): one canonical `skills/` tree, multiple harness install paths.

## Quick install

### Cursor (plugin marketplace)

When this repo is on GitHub, install from your marketplace or:

```text
/add-plugin <your-github-user>/explain-my-pr
```

Requires a `.cursor-plugin/plugin.json` (included) pointing at `./skills/`.

### Claude Code (plugin marketplace)

Register your marketplace (once), then install:

```text
/plugin marketplace add <your-github-user>/explain-my-pr
/plugin install explain-my-pr@explain-my-pr
```

Uses `.claude-plugin/marketplace.json` and `.claude-plugin/plugin.json`.

### Manual (any agent)

```bash
git clone https://github.com/<you>/explain-my-pr.git
cd explain-my-pr
./scripts/install-local.sh
```

Copies the skill to `~/.cursor/skills/`, `~/.claude/skills/`, and `~/.agents/skills/`.

### Project-only (one repo)

```bash
mkdir -p .cursor/skills/explain-my-pr
cp -r skills/explain-my-pr/* .cursor/skills/explain-my-pr/
```

Same for `.claude/skills/` on Claude Code projects.

## Use

Enable the skill, then prompt:

```text
Write an MR change explanation for merging feat/add-metrics into main.
Focus on pkg/middleware/metrics.go.
Save to docs/mr-change-explanations/metrics-middleware.md.
```

| Doc type | Branch names | Example to copy |
|----------|--------------|-----------------|
| Public / resume | `main`, `feat/...` | `skills/.../examples/example-output.md` |
| Internal only | Real names OK | `examples/*-private.md` (gitignored) |

## Repository layout (Superpowers-style)

```
explain-my-pr/
├── README.md
├── LICENSE
├── skills/
│   └── explain-my-pr/
│       ├── SKILL.md              # agents load this
│       ├── reference.md
│       └── examples/
│           ├── example-output.md   # safe to publish
│           └── .gitignore
├── .cursor-plugin/plugin.json    # Cursor: "skills": "./skills/"
├── .claude-plugin/
│   ├── plugin.json
│   └── marketplace.json
├── .codex-plugin/plugin.json     # Codex CLI plugin
└── scripts/install-local.sh
```

## License

MIT — see [LICENSE](LICENSE).
