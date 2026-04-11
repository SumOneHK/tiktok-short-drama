# /结构 命令详细执行规范

> 本文件是 `/结构` 命令的自包含说明书。进入命令后只读本文件即可。

## 用途

把项目做成可拆集、可卡点、可持续升级的故事引擎。

## 分层加载规则

**核心层（每次进入 `/结构` 必读）：**

业务数据文件：

- `故事设定.md` — 作为结构设计的事实基础
- `选题分析.md` — **只读"前 3 集承诺""主情绪""观众幻想合约"段**

规则参照文件：

- `references/story-engine.md` — 全局结构、开篇、钩子、节奏、爽点设计原则
- `references/templates/story-structure.md`（`故事结构.md` 固定模板）

**条件层（仅在满足触发条件时读取）：**

| 触发条件 | 读取文件 |
|---------|---------|
| 设计付费卡点结构 | `references/paywall-rules.md` |
| 设计全剧情绪曲线与单集情绪弧 | `references/emotion-design.md` |
| 初始化悬念债务与资产追踪表 | `references/continuity-ledger.md` |
| 高风险题材（未成年人 / 超自然暴力 / 高度政治敏感） | `references/compliance-rules.md` |
| `mode=overseas` 且结构层仍需复查平台适配 | `references/tiktok-platform-constraints.md`（只读节奏与卡点适配段） |
| 触发 `/结构质检` | `references/commands/qc-structure.md`（独立质检命令，闸门规则已下沉）+ `references/quality-gate.md` |

## 执行要求

1. `故事结构.md` 固定模板以 `references/templates/story-structure.md` 为唯一权威源，并至少覆盖：一句话故事线、核心冲突、观众幻想合约、宏观结构、前 3 集引擎、情绪曲线、钩子系统、悬念债务与兑现、爽点结构、付费卡点、结局和崩盘风险。
2. 细化原则以 `references/story-engine.md` 为准；卡点规则以 `references/paywall-rules.md` 为准（条件层触发）。
3. 每个卡点前必须已有阶段性回报；若中段只能重复施压、重复吵架或重复误会，判 `P0`。
4. 首次进入 `/结构` 时，若 `故事结构.md` 不存在才创建；不要提前创建 `分集大纲.md`、`分集追踪.md` 或 `分集剧本/`。
5. 输出末尾追加"结构内建自检"；通过后将 `currentStep` 设为 `分集大纲`。
