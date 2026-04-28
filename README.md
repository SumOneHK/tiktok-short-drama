# TikTok 短剧创作 Skill

面向 **TikTok / 海外竖屏短剧**（vertical short drama / micro-drama / TikTok drama）的 Claude Code 创作 Skill。覆盖从**选题验证**到**分镜交付**的全流程：市场分析 → 世界观 → 故事结构 → 分集大纲 → 分集剧本 → 分镜脚本 → 过程质检 → 付费卡点 → 合规审核。

支持**国内全中文稿**与**出海英文对白稿**（中文策划文档 + 英文对白）两种模式。

> 不是"先写剧情再补逻辑"，而是按"市场验证 → 设定搭建 → 结构引擎 → 分集拆解 → 剧本落地 → 分镜执行 → 质检合规 → 导出交付"的顺序稳定产出**可看、可卖、可续写**的短剧。

---

## 为什么需要它

AI 写短剧最常见的三个坑：

1. **剧情爽感碎片化**——单集好看，串起来逻辑断裂、角色漂移、悬念不兑现
2. **钩子与付费卡点失灵**——开场留不住人，该付费的地方没爽点，会员转化拉胯
3. **跨文档漂移**——设定、结构、大纲、剧本、分镜各写各的，改一处漏十处

本 Skill 用一套**4 层主线流程 + 7 道过程质检 + 跨文档漂移双向复检**的工程化框架解决这些问题，把短剧创作做成可追踪、可回滚、可交付的流水线，而不是灵光一现的手工作坊。

---

## 核心特性

### 工程化流水线
- **4 层主线流程**：方向锁定 → 引擎搭建 → 批次生产 → 收口交付
- **兼容主创创作递进**：创意 → 梗概 → 情节点大纲 → 剧本初稿；命令名不强制对应传统叫法，但产物边界必须对应
- **7 道过程质检**：设定 / 结构 / 大纲 / 剧本 / 衔接 / 整剧通读 / 分镜，每道都带 P0 硬阻断
- **状态机驱动**：`剧本状态.json` 记录 `currentStep` / `deliveryProgress` / `qcStatus`，支持中断恢复与批次滚动生产
- **跨文档漂移双向复检**：上游改动自动回退下游质检状态，下游新增共享字段反向触发上游复检

### 短剧专属能力
- **TikTok 平台约束**：60-90 秒单集、竖屏安全区、开场 3 秒钩子、付费卡点节奏
- **情绪工程**：13 条核心原则驱动情绪曲线、悬念债务、爽点与卡点设计
- **本地化双轨**：中文策划稳定不变，英文对白按语言模式规则生成，支持出海 / 国内对照版
- **AI 视频友好**：分镜脚本按时长守恒规则（自下而上推导 · ±0.5s 闭合）输出，含镜头功能分类与对白校准公式，配合 `AI资产圣经.md` 做角色/场景资产连续性

### 合并式文档结构（避免碎片化）
- 世界观 / 角色 / 关系 / 场景 → `故事设定.md`
- 全局大纲 / 情绪曲线 / 钩子 / 悬念债务 / 爽点 / 付费卡点 → `故事结构.md`
- 分集推进 / 单集情绪曲线 / 尾钩 / 卡点 → `分集大纲.md`
- 事实 / 悬念 / 情绪 / 资产连续性 → `分集追踪.md`

---

## 安装

### 方式一：作为项目级 Skill

```bash
cd your-project
mkdir -p .claude/skills
git clone https://github.com/SumOneHK/tiktok-short-drama.git .claude/skills/tiktok-short-drama
```

### 方式二：作为全局 Skill

```bash
mkdir -p ~/.claude/skills
git clone https://github.com/SumOneHK/tiktok-short-drama.git ~/.claude/skills/tiktok-short-drama
```

装好后在 Claude Code 中打开目标项目目录，直接输入 `/开始` 即可进入 Skill。任何涉及「短剧 / 竖屏剧 / TikTok 剧 / 微短剧 / 出海剧 / 60-90 秒 AI 视频剧 / 分集大纲 / 分镜脚本 / 付费卡点」的需求都会自动路由到本 Skill，即使用户没有显式提及"skill"。

---

## 快速开始

```text
# 1. 方向锁定
/开始                        # 交互式题材推荐
/开始 一个豪门少爷被未婚妻甩了的故事   # 基于用户想法收窄

# 2. 立项 → 设定 → 结构
/立项
/设定        →   /设定质检
/结构        →   /结构质检

# 3. 批次生产
/分集大纲    →   /大纲质检
/分集剧本 1-10   →   /剧本质检 1-10
全剧剧本完成后    →   /整剧通读
/分镜脚本 1-10   →   /分镜质检 1-10

# 4. 收口交付
/总检
/合规
/导出
```

每条命令都以 `references/commands/{命令}.md` 为入口；进入命令后先读对应命令说明书，再按其中的核心层/条件层加载必要引用，不需要反复回查主文件。

---

## 命令索引

### 主线流程

| 命令 | 用途 |
|------|------|
| `/开始` | 题材收窄与方向锁定（交互式推荐 / 基于用户想法收窄） |
| `/立项` | 把锁定方向整理为正式版 `选题分析.md`，产出短版故事梗概 |
| `/设定` | 一体化完成世界观、角色、关系、场景、本地化 |
| `/结构` | 把梗概拆成可追踪的全剧关键情节点链条 |
| `/分集大纲` | 拆全剧分集推进图，明确逐集情节点与情节点后果 |
| `/分集剧本 {起止集}` | 按批次落地剧本初稿 / 纯叙事中间稿（不写镜头） |
| `/分镜脚本 {起止集}` | 把已通过剧本质检的单集转成可执行 AI 视频分镜 |
| `/总检` | 跨文档一致性、商业强度、AI 制作就绪检查 |
| `/合规` | 内部前置合规筛查 |
| `/导出` | 汇总对外协作包 |

### 过程质检

| 命令 | 检查对象 | 阻断条件 |
|------|---------|---------|
| `/设定质检` | 世界规则、角色功能、命名体系、场景池、本地化 | 通过后才进 `/结构` |
| `/结构质检` | 情绪曲线、钩子、悬念债务、卡点关系 | 通过后才进 `/分集大纲` |
| `/大纲质检` | 承接、重复桥段、水集、卡点兑现 | 通过后才进 `/分集剧本` |
| `/剧本质检 {起止集}` | 批次剧本的人设、台词、承接、模板 | 通过后才写后续批次 |
| `/衔接质检 {起止集}` | 相邻集断裂、重复、连续性问题 | 不通过先修相邻集 |
| `/整剧通读` | 全剧分集剧本宏观体验、商业强度、可分镜性 | 全剧剧本完成后、分镜前必须通过 |
| `/分镜质检 {起止集}` | 拆镜粒度、执行性、竖屏适配、与剧本一致性 | 通过后才进 `/总检` 或导出 |

任一质检出现 `P0`，对应 `qcStatus` 必须记为 `需修改`，**禁止推进下一阶段**。

---

## 目录结构

### Skill 本身

```text
tiktok-short-drama/
├── SKILL.md                    # 入口文件（Claude Code 自动加载）
├── README.md                   # 本文件
├── LICENSE                     # MIT
├── agents/
│   └── openai.yaml
├── scripts/
│   └── merge_episode_scripts.sh
└── references/
    ├── state-schema.md         # 状态机字段约定
    ├── philosophy.md           # 13 条核心原则
    ├── role-perspectives.md    # 8 阶段角色视角清单
    ├── display-vocab.md        # 用户展示口径中英映射
    ├── start-topic-pool.md     # 题材池
    ├── market-analysis.md      # 市场分析方法论
    ├── world-character-scene.md
    ├── story-engine.md         # 故事引擎（结构骨架 + 节奏设计）
    ├── episode-writing-protocol.md
    ├── episode-script-templates.md
    ├── storyboard-conversion.md    # 时长守恒规则
    ├── storyboard-script-templates.md
    ├── continuity-ledger.md        # 连续性账（含双时间线/闪回）
    ├── emotion-design.md
    ├── paywall-rules.md            # 付费卡点规则
    ├── language-mode.md            # 中英语言模式
    ├── document-sync.md            # 跨文档一致性
    ├── tiktok-platform-constraints.md
    ├── compliance-rules.md         # R-01~R-06 红线
    ├── ai-production.md            # AI 制作规范（按章节精读）
    ├── process-qc.md               # 跨阶段质检时机、记录和推进元规则
    ├── quality-gate.md             # 响应格式与 P0/P1/P2 分级
    ├── commands/                   # 17 个命令说明书
    │   ├── start.md / kickoff.md / setup.md / structure.md
    │   ├── outline.md / episode.md / storyboard.md
    │   ├── review.md / compliance.md / export.md
    │   └── qc-setup.md / qc-structure.md / qc-outline.md
    │       qc-episode.md / qc-link.md / qc-full-read.md / qc-storyboard.md
    └── templates/                  # 10 个独立文档模板
        ├── topic-start.md / topic-proposal.md
        ├── story-setup.md / story-structure.md
        ├── episode-outline.md / episode-tracker.md
        ├── ai-asset-bible.md
        ├── qc-checkpoint.md
        ├── review-report.md
        └── compliance-report.md
```

### 跑完一个完整项目后的工作目录

```text
{项目目录}/
├── 剧本状态.json              # 状态机
├── 选题分析.md
├── 故事设定.md
├── 故事结构.md
├── 分集大纲.md
├── 分集追踪.md
├── 质检检查点.md              # 跨阶段质检记录
├── AI资产圣经.md              # 分镜阶段首次创建
├── 分集剧本/
│   ├── 第001集.md
│   └── ...
├── 分镜脚本/
│   ├── 第001集.md
│   └── ...
├── 总检报告.md
├── 合规报告.md
└── 导出/
```

文件**延迟创建**：不为"看起来完整"而预建未来步骤的空文件，每个阶段只创建当前立即要用的文档。

---

## 设计原则（13 条核心原则节选）

1. **验证为先**——题材先过市场，再进设定，不靠感觉拍板
2. **合并设计**——世界观/角色/场景等高耦合内容合并成一篇，避免漂移
3. **悬念是债务**——每开一个悬念都要记账，按节奏兑现
4. **情绪工程**——情绪曲线是结构的主轴，不是结构的副产品
5. **复杂度服务质量**——不做炫技式复杂结构，所有复杂度必须落到可看性上

完整 13 条原则见 `references/philosophy.md`。

---

## 工作模式

### 模式一：从 0 到 1 新建项目
直接 `/开始` → 一路推进到 `/导出`，每步有内建自检 + 阶段闸门质检；从 `/设定质检` 开始，独立质检通过才授权下一阶段。

### 模式二：已有中文短剧改出海版
从 `/设定` 阶段接手，`mode` 设置为 `overseas`，`languageMode` 设置为 `overseas-en-dialogue`，中文策划稳定，英文对白按 `language-mode.md` 规则生成。

### 模式三：重做题材定位 / 钩子 / 节奏
从 `/结构` 阶段回头，结构变更后按"跨文档漂移双向复检"规则自动回退下游 `qcStatus`。

### 模式四：滚动批次生产
`/分集剧本 {起止集}` + `/分镜脚本 {起止集}` 可按批次循环推进，`deliveryProgress` 字段自动记账完成区间与下一批次。

---

## 状态机与恢复

每次进入 Skill 都先检查 `剧本状态.json`：

- `currentStep`：当前阶段（`开始 | 立项 | 设定 | 结构 | 分集大纲 | 分集剧本 | 分镜脚本 | 总检 | 合规 | 导出`）
- `deliveryProgress`：批次生产进度，含 `scriptCompletedRanges` / `storyboardCompletedRanges` / `nextScriptRange` / `nextStoryboardRange`
- `qcStatus`：各阶段质检状态（`未检查 | 已通过 | 需修改`）

恢复现场时**必须同时**检查：剧本完成区间、分镜缺口、下一批次、最近一批质检状态——不允许只看 `currentStep` 就继续写。

---

## 许可证

[MIT License](./LICENSE) © 2026 mufeng

---

## 贡献

欢迎提 Issue / PR。涉及核心流程改动建议先开 Issue 讨论方向——本 Skill 的设计是**刻意保守**的，每条规则都有其对应的失败案例作为依据。

---

## 致谢

本 Skill 在以下方面参考了行业实践：

- TikTok / Reelshort / DramaBox 等平台的竖屏短剧内容规律
- 传统编剧结构理论（三幕式、Save the Cat、悬念债务）
- AI 视频生产的工程化流水线（资产连续性、时长守恒、分镜粒度）
