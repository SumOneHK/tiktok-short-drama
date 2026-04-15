# /分集大纲 命令详细执行规范

> 本文件是 `/分集大纲` 命令的自包含说明书。进入命令后只读本文件即可。

## 用途

把结构引擎拆成全剧分集推进图，并同步维护 `分集追踪.md`。

## 分层加载规则

**核心层（每次进入 `/分集大纲` 必读）：**

业务数据文件：

- `故事设定.md` — **只读角色表、场景池、能力边界**
- `故事结构.md` — 作为大纲拆解的事实基础

规则参照文件：

- `references/story-engine.md`（**只读 §按集数映射的结构骨架 与 §节奏设计 段**，对应 story-engine.md 顶部按需分章表的"拆集节拍与前 3 集引擎"用途）
- `references/templates/episode-outline.md`（`分集大纲.md` 固定模板）
- `references/templates/episode-tracker.md`（`分集追踪.md` 固定模板）

**条件层（仅在满足触发条件时读取）：**

| 触发条件 | 读取文件 |
|---------|---------|
| 单集情绪弧与尾钩设计 | `references/emotion-design.md` |
| 卡点集标注与付费兑现设计 | `references/paywall-rules.md` |
| 初始化或维护 `分集追踪.md` 的悬念债务 | `references/continuity-ledger.md` |
| `mode=overseas` 且大纲需复查竖屏节奏 | `references/tiktok-platform-constraints.md`（只读节奏段） |
| 触发 `/大纲质检` | `references/commands/qc-outline.md`（独立质检命令，闸门规则已下沉）+ `references/quality-gate.md` |

## 执行要求

0. **前置质检闸门（P0）**：进入 `/分集大纲` 前必须确认 `qcStatus.architecture = 已通过`；若为 `未检查` 或 `需修改`，先执行或修复 `/结构质检`，不得凭 `/结构` 内建自检直接推进。
1. `分集大纲.md` 和 `分集追踪.md` 的固定模板分别以 `references/templates/episode-outline.md` 和 `references/templates/episode-tracker.md` 为唯一权威源。
2. 覆盖全部集数；前 3 集完成题材承诺与主关系建立，前 8-12 集出现第一轮高价值兑现。
3. 每集至少有一个明确状态变化；`💰` 标记要有商业逻辑，不能把所有关键集都标成卡点。
4. 每完成一轮大纲更新，同步回填 `分集追踪.md` 中的新增悬念、兑现节点、关系温度和资产变化。
5. 若连续 2-3 集没有状态变化、尾钩经常不被承接或前 3 集未完成题材承诺，判 `P0`。
6. 首次进入 `/分集大纲` 时，若 `分集大纲.md` 或 `分集追踪.md` 不存在才创建；不要提前创建 `分集剧本/` 或导出目录。
7. 输出末尾追加"大纲内建自检"；通过后只将 `qcStatus.outline` 保持或回写为 `未检查`，`currentStep` 保持 `分集大纲`，下一步必须执行 `/大纲质检`。只有 `/大纲质检` 写入 `qcStatus.outline = 已通过` 后，才允许进入 `/分集剧本`。
