# 固定文档模板索引

> **⚠️ 读取规则**：本文件只是索引；各模板的**真正内容**已经全部下沉到 `references/templates/` 目录。调用方**不要读本文件的模板内容**，直接按阶段定位到 `templates/xxx.md` 即可。

## 按阶段定位表

| 调用阶段 | 对应模板文件 | 说明 |
|---------|------------|------|
| `/设定` | `references/templates/story-setup.md` | `故事设定.md` 固定模板（19 个子块，按 A/B/C 三档分级读取） |
| `/结构` | `references/templates/story-structure.md` | `故事结构.md` 固定模板 |
| `/分集大纲` | `references/templates/episode-outline.md` + `references/templates/episode-tracker.md` | `分集大纲.md`、`分集追踪.md` |
| `/分镜脚本` 首次进入（**唯一**创建点） | `references/templates/ai-asset-bible.md` | `AI资产圣经.md`（若不存在才创建） |
| `/设定质检` `/结构质检` `/大纲质检` `/剧本质检` `/衔接质检` `/分镜质检` | `references/templates/qc-checkpoint.md` | `质检检查点.md` |
| `/总检` | `references/templates/review-report.md` | `总检报告.md` |
| `/合规` | `references/templates/compliance-report.md` | `合规报告.md` |

## 使用原则

- 上述模板是**默认格式**，不是示例；对应文档默认按模板输出
- 模板只在对应文档**首次真正需要落盘**时使用，不为未来步骤提前创建空文件
- 模板实例化目标始终是 `ACTIVE_DRAMA_DIR` 下的对应业务文件；不得把模板产物直接写到多剧工作区根目录
- 题材特殊时可以加字段，但不要删核心字段
- 同一项目内栏目名尽量保持稳定，不随阶段切换而改写
- **读取规则**：每个模板文件都是独立单元，调用方只读自己那一份；不要跨阶段混读

## 使用提醒（收敛自旧 §九）

- `AI资产圣经.md` 是 AI 生成的稳定资产库；单集文件默认继承，只写增量
- `故事设定.md` 是稳定事实库，只有明确设定变化时才改
- `故事结构.md` 是全剧引擎；结构层变化先改这里，再改大纲和单集
- `分集大纲.md` 是全剧推进蓝图；结构变化先改这里，再改单集
- `分集追踪.md` 是逐集变化库，每写完一集就要回填
- `质检检查点.md` 是问题账本，同一问题必须同一 ID 跟踪到底
- `总检报告.md` 与 `合规报告.md` 是导出前的最终闸门，不是可选文件
