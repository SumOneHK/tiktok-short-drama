# /开始 命令详细执行规范

> 本文件是 `/开始` 命令的自包含说明书。进入命令后只读本文件即可，不需要再回 `SKILL.md` 查加载规则。

## 用途

完成题材收窄与方向锁定，不直接跳正式立项。

## 分层加载规则

**核心层（每次进入 `/开始` 必读）：**

- `references/workspace-projects.md` — 解析工作区、创建单部剧目录、隔离多剧业务文件
- `references/state-schema.md` §新项目初始化模板 — 首次创建 `剧本状态.json` 时使用，必须保持合法 JSON
- `references/start-topic-pool.md` — `/开始` 题材推荐池、叠加规则、出海映射
- `references/market-analysis.md` — 选题、受众、赛道、竞品、TikTok 平台适配
- `references/tiktok-platform-constraints.md` — TikTok 平台特性与阶段约束
- `references/compliance-rules.md` §通用红线 + §风险分级 —— **前置快筛必读**（见执行要求 6）
- `references/templates/topic-start.md` — `选题分析.md` 推荐版固定模板（写入推荐版前必读）
- `references/quality-gate.md` — 仅触发自检时按需

**条件层（仅在满足触发条件时读取）：**

| 触发条件 | 读取文件 |
|---------|---------|
| 命中通用红线或高风险题材 | `references/compliance-rules.md` 全文（补读 §审核流程 + §常用安全改写法） |
| `/开始` 内建自检 | `references/process-qc.md`（**只读 §三「/开始」段**） |

> 此阶段无需加载 `emotion-design.md`，主情绪规则已包含在 `tiktok-platform-constraints.md` 中。

## 执行要求

1. `/开始` 是唯一启动入口，支持 `/开始` 与 `/开始 {用户自己的想法}`。
2. 用户没有明确方向时，优先从 `references/start-topic-pool.md` 的推荐池中挑 1 个主推方向和 1-2 个备选；用户已有想法时，先总结"当前方向理解"，再给 1 个主推修正版和 1-2 个变体。
3. 推荐方案一律用中文用户口径，不直接暴露内部枚举值。
4. `/开始` 的题材推荐不要只围绕 2-3 个老题材打转；若用户没有偏好，候选方向应尽量覆盖不同情绪和不同制作负担。
5. 每轮对话只推进 1-2 个关键选择，不做问卷；优先收敛题材、主情绪、模式、形态与推荐集数。
6. **合规前置快筛（强制）**：候选方向形成后，必须按 `references/compliance-rules.md` §通用红线表格**逐 ID（R-01 ~ R-06）核对**，并按 §风险分级给出"绿/黄/红"判定。命中任一红线 R-ID = 直接 `P0` 踢出，不得出现在推荐版；黄色高风险方向必须在推荐版中明确标注"需后续合规改写"+对应 R-ID。合规筛查**不是**最后补丁，`/开始` 阶段就要拦住不该上的题。
7. 若方向仍靠解释成立、主情绪不清或不适合竖屏表达，视为 `P0`，不得推进。
8. 首次进入 `/开始` 时，必须先按 `references/workspace-projects.md` 建立或解析 `ACTIVE_DRAMA_DIR`：当前目录若不是已含 `剧本状态.json` 的剧本目录，则在当前工作区下新建一个单部剧目录，禁止把 `剧本状态.json` 与 `选题分析.md` 直接落到工作区根目录。
9. `/开始` 只补建 `ACTIVE_DRAMA_DIR/剧本状态.json` 与 `ACTIVE_DRAMA_DIR/选题分析.md` 这两个最小文件；`剧本状态.json` 必须使用 `references/state-schema.md` §新项目初始化模板，并写入 `project.directoryName / createdAt / workspaceMode`；未确认字段保留空值或空数组；过程性内容写入 `选题分析.md` 推荐版。
10. 推荐版中只能写"用户已确认项"和"当前建议配置（未确认）"；在用户明确选择前，不得把主推方案写成已确认题材。
11. 当方向已收敛到 1-2 个关键选择，且用户已明确选择方向或授权按主推推进时，必须在输出末尾追加"`/开始` 内建自检"（检查项见 `references/process-qc.md` 的 `/开始` 闸门段）；自检通过后才进入 `/立项`，不单独暴露 `/开始质检` 命令。

## 输出要求

当前推荐方向、当前方向理解、为什么主推、待确认的 1-2 个选择、下一步建议。

## 合规提醒

合规前置快筛已强制写入执行要求 #6。发现命中通用红线或黄色高风险分级时，补读 `references/compliance-rules.md` 的 §审核流程 + §常用安全改写法。此阶段无需加载 `emotion-design.md`，主情绪规则已包含在 `tiktok-platform-constraints.md` 中。
