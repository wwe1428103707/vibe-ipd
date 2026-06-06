# IPD与敏捷术语表

**所属合集**: IPD工具包改造计划

## A

**Agile-Stage-Gate（敏捷-门径混合模型）**: 一种混合项目管理模型，同时保留门径（TR）的宏观治理框架与敏捷方法（Scrum/Kanban）的微观执行能力。实现"纪律与敏捷并存"。

## C

**CBB（公用基础模块，Common Building Block）**: 可跨多个产品或功能复用的软件组件、模块或库。IPD推崇CBB复用以减少重复开发、加速交付。

## D

**DoD（完成标准，Definition of Done）**: 工作项（用户故事、功能或发布版本）被认为完成之前必须满足的标准清单。包括代码质量、测试、文档和安全检查。

**Dual-Track Agile（双轨敏捷）**: 一种开发方法，包含两条并行轨道：探索轨（Discovery Track，探索、验证、原型）和交付轨（Delivery Track，实现、测试、部署）。确保只有经过验证的功能才进入开发。

## L

**LPDT（PDT经理，Lead Product Development Team Manager）**: IPD角色，负责协调PDT团队、管理跨团队依赖、主持技术评审（TR）门径。映射到SAFe中的RTE（敏捷发布火车工程师，Release Train Engineer）。

## M

**MoSCoW优先级模型**: 一种需求优先级分类方法，将需求分为必须有（Must-have）、应该有（Should-have）、可以有（Could-have）和不会有（Won't-have）。用于IPD需求筛选流程。

## P

**PDT（产品开发团队，Product Development Team）**: IPD中的跨职能团队，包含交付产品所需的所有能力：产品管理、架构、开发、测试和运维。

**PO（产品负责人，Product Owner）**: 敏捷角色，负责定义用户故事、排期产品待办列表、验收完成的工作。映射到IPD中的产品经理角色。

**Product Trio（产品三人组）**: 由产品负责人（PO）、系统架构师和UX设计师组成的跨职能探索团队。三人组在探索轨共同验证功能的市场需求度、技术可行性和商业可行性。

## R

**RTE（敏捷发布火车工程师，Release Train Engineer）**: SAFe角色，负责促进ART（敏捷发布火车）事件、管理依赖关系和推动持续改进。映射到IPD中的LPDT角色。

## S

**SDD（规格驱动开发，Spec-Driven Development）**: 一种开发方法论，将规格说明视为可执行产物，直接生成可工作的实现。是Spec Kit工具包的基础方法论。

## T

**TR（技术评审，Technology Review）**: IPD门径评审，在阶段边界评估项目就绪度。6个TR门径为：
- **TR1**: 概念/可行性评审
- **TR2**: 系统架构评审
- **TR3**: 概要设计评审
- **TR4/TR4A**: 开发增量/灰度发布就绪评审
- **TR5**: 系统与Beta测试评审
- **TR6**: 上线准备度与运维交接评审

## W

**WSJF（加权最短作业优先，Weighted Shortest Job First）**: 一种优先级排序方法，将业务价值（包括时间紧迫度和风险降低）除以作业规模。WSJF得分越高表示优先级越高。用于数据驱动的待办列表优先级排序。