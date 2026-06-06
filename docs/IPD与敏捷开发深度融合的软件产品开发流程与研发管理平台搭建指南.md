# **IPD与敏捷开发深度融合的软件产品开发流程与研发管理平台搭建指南**

## **一、 国际视野下IPD与敏捷开发（Agile-Stage-Gate）的融合逻辑**

在现代软件开发中，如何在保持宏观技术治理和资金管控的同时，获取敏捷开发的柔性响应力，已成为全球科技企业共同面对的核心课题。传统的集成产品开发（IPD）和阶段门径系统（Stage-Gate）常因前置规划期长、文档化繁琐而导致产品推向市场（Go-to-Market）迟缓。  
为了解决这一痛点，阶段门径创始人罗伯特·库珀（Robert G. Cooper）以及国际先进企业（如Honeywell、LEGO、GE等）探索并验证了**Agile-Stage-Gate混合模型（敏捷-门径混合模型）**。该模型提出了“**纪律与敏捷并存（Agility with discipline）**”的理念：

1. **宏观治理轨（Gated Governance）**：保留Stage-Gate（IPD技术评审TR）作为生命周期和资金/技术路线的决策关卡，确保战略一致性与合规性，实现“做正确的事”。  
2. **微观执行轨（Agile Delivery）**：在各阶段内部引入敏捷Scrum或Kanban迭代，打破传统的串行大瀑布模式，实行并行工程（Parallel Processing）与微观迭代。  
3. **双轨敏捷（Dual-Track Agile）**：创新引入探索轨（Discovery Track）**与**交付轨（Delivery Track）的并轨运行机制。在前端采用设计思考（Design Thinking）和精益创业（Lean Startup）进行快速验证与需求去噪，随后将高置信度的交付件源源不断地送入后端的工程交付轨中。

这种混合模式将软件规格定义的重心从“如何在开发前确定100%的Spec”转变为“在迭代Spec中渐进明晰”的螺旋式上升（Spiral Development），使整体交付效率大幅提升，并显著降低了开发后期的返工几率。

## **二、 跨职能重量级团队（PDT）与敏捷角色的网格化映射**

在无高层商业投资决策（如IPMT）的纯开发场景下，项目交付依赖于全功能型的产品开发团队（PDT） 1。为使团队更具自组织与自治权，本指南将IPD角色与敏捷体系（含SAFe规模化敏捷、Scrum）的角色进行深度网格化映射，并引入国际前沿的“产品三人组”（Product Trio）理念。

### **2.1 融合型组织架构与角色映射关系**

| IPD项目开发团队角色 | 敏捷与规模化敏捷（SAFe）角色映射 | 在产品开发流程中的核心职责 |
| :---- | :---- | :---- |
| **PDT经理 (LPDT)** | **项目群总监 / 敏捷发布火车司机 (RTE)** | 负责跨团队规划、依赖对齐及障碍清理（Blocking & Tackling），主导TR技术评审。 |
| **PDT产品经理 / 需求代表** | **产品负责人 (Product Owner, PO)** | 与“探索轨”紧密协作，维护并排期产品待办列表（Product Backlog），定义用户故事验收标准。 |
| **PDT研发代表** | **系统架构师 (System Architect)** | 负责软件整体微服务架构、模块解耦与CBB（公用基础模块）建设，确保架构合规。 |
| **PDT测试代表** | **敏捷测试主管 / 质量专家 (QA)** | 负责系统性集成与非功能性测试策略，定义DoD（完成标准），主导TR5评审。 |
| **PDT运维代表** | **DevOps负责人 / 现场应用(FAE)主管** | 打通灰度发布（Canary Release）与日常CI/CD流水线，建立监控与热补丁响应回路。 |
| **PDT核心成员** | **全功能自组织团队 (Feature Team / Scrum Team)** | 跨职能协作，一专多能。对所分配的特性从“设计”到“上线”的端到端质量全权负责。 |

### **2.2 黄金搭档：“产品三人组”（Product Trio）在探索轨的应用**

在前端需求探索中，企业极易陷入“研发闭门造车”或“市场胡乱提需”的泥潭 2。为此，本指南在PDT内设立一个常设敏捷先锋单元——**产品三人组（Product Trio）**，由**PO（产品经理）**、**系统架构师（研发）和UX设计师**共同组成。三人组在“探索轨”共同直面客户，用低成本原型（Mockups）或技术刺针（Spike）快速验证用户渴望度、技术可行性及商业可行性，并在 Gate 3（Go-to-Development）前将高度确信的Feature移交至开发队列，实现质量内建。

## **三、 结合西方实践的软件产品开发流程与交付物矩阵**

本套流程将传统的IPD六阶段模型进行敏捷改良，把各阶段作为“高阶约束”，而将阶段内的工作拆解为2-4周的Sprint（迭代）。门径评审（TR）引入西方常用的**双重决策准则**：**Must-Meet（红线一票否决指标）与Should-Meet（定性评分卡指标）**，拒绝主观偏见，用客观数据做出Go/Kill/Hold/Recycle的决策。

### **3.1 研发需求流转机制（从原始需求到代码落地）**

 \[原始需求 (统一需求池)\] ──\> 进行 KANO/MoSCoW 模型初筛与分发  
                                │  
                                v  
                   \[史诗需求 (Epic)\] ──\> 通过 TR1 可行性评估  
                                │  
                                v  
               \[产品特性 (Feature)\] ──\> 确定技术可行性与架构边界 (TR2/TR3)  
                                │  
                                v  
             ──\> 关联 Spikes 与 Sprint 开发计划  
                                │  
                                v  
                    \[合并代码 (Code Commit)\] ──\> 自动触发 CI 管道和 DoD 验证

### **3.2 优化后的敏捷门径流程与交付物规范**

| 开发阶段 | 技术评审 (TR) / 门径 | 对齐之敏捷/双轨活动 | 阶段核心交付物清单 | 门径评审核心准则（Must-Meet / Should-Meet） |
| :---- | :---- | :---- | :---- | :---- |
| **概念阶段** (Scoping & Concept) | **TR1**（需求与技术可行性评审） 3 | 原始需求澄清、用户访谈（VoC）、产品三人组探索 | 1\. 结构化《原始需求矩阵(OR)》 4 2\. 概念验证原型与《技术可行性分析》 3\. 跨职能PDT项目授权章程 2 | **Must-Meet**: 战略契合度不低于90%；不触及法律与安全红线。 **Should-Meet**: 市场吸引力评分 \> 8/10。 |
| **计划阶段** (Business Case) | **TR2**（系统架构设计评审） 3 **TR3**（概要设计可行性评审） 3 | 架构Spikes、特性拆解与优先级评估（如WSJF法） | 1\. 系统API协议与《概要设计说明书》 1 2\. 排序完成的《Feature Backlog》 3\. 详细《测试策略及环境就绪报告》 5 | **Must-Meet**: 架构解耦方案通过技术委员会评审；核心外部依赖已锁定。 **Should-Meet**: 估算的故事点/团队容量（Capacity）比值处于合理区间。 |
| **开发阶段** (Development) | **TR4/TR4A**（迭代增量与灰度可行性质量核准） 3 | 迭代规划、每日站会（Daily Scrum）、Sprint演示与回顾 | 1\. 持续集成的软件部署包（制品库Artifact） 6 2\. 自动化集成测试用例及脚本 6 3\. 各Sprint进度与燃尽图报告 | **Must-Meet**: 100%符合开发完成标准（DoD）；代码质量分析无未修复安全漏洞。 **Should-Meet**: 开发实际速率（Velocity）在计划波动的 ![][image1]15% 以内。 |
| **验证阶段** (Testing & Validation) | **TR5**（系统与Beta测试评审） 3 | 探索性测试、端到端集成验证、早期用户Beta体验反馈 | 1\. 《全量功能与性能（非功能性）测试报告》 5 2\. 《Beta客户体验验证总结报告》 3 3\. 用户指南与《部署运维说明书》 5 | **Must-Meet**: 一级与二级严重缺陷（Blocker/Critical Bug）清零；性能压测吞吐量达标 5。 **Should-Meet**: 外部Beta用户满意度调查（NPS）评分 ![][image2] 8。 |
| **发布阶段** (Launch & Release) | **TR6**（上线准备度与运维交接评审） 3 | 灰度放量监控、蓝绿部署预演、运维就绪度核对 6 | 1\. 《灰度发布监控报告与回滚预案》 5 2\. 《软件Release Notes》 5 3\. 运维及售后支持（FAE）交接清单 7 | **Must-Meet**: 自动化部署脚本预演100%成功；运维基础设施资源就绪 2。 **Should-Meet**: 客服及FAE培训考核通过率达100% 2。 |
| **生命周期** (Life Cycle) | **不定期技术复盘** | 紧急缺陷修补（Hotfix）、计划外变更评估（PCR） 6 | 1\. 《变更控制日志（PCR Log）》 6 2\. 运维监控日志与高频缺陷复盘 7 3\. 版本生命周期中止（EOL）公告 6 | **Must-Meet**: 生产事件响应时效（SLA）满足约定；未授权变更次数为零。 **Should-Meet**: CBB（公共组件）重用率持续上升 1。 |

## **四、 敏捷IPD一体化研发管理数字化平台搭建指南（基于Jira Cloud Premium）**

实现Agile-Stage-Gate混合模型的关键在于，将Jira打造成唯一的事实真实源（Single Source of Truth），统一呈现宏观门径路线图与微观敏捷迭代，以消除多工具并用产生的数据偏差。

### **4.1 树状多级需求体系在 Jira 中的配置与“重映射”**

Jira原生仅支持Epic (长篇故事) \-\> Story (用户故事)的两级层级，难以承接“Epic \-\> Feature \-\> Story”的IPD标准层次。为此，我们需要在Jira Cloud Premium（高级版/包含高级路线图Plans）中进行重映射配置：

1. **自定义问题类型（Issue Types）**：  
   * 创建全新的工作项类型：Initiative (倡议/史诗级需求)，用以承接宏观的TR概念与资金规划。  
   * 将原生的 Epic 重新命名或映射为 Feature (特性级需求)。  
   * 维持 Story/Task（用户故事/任务级）作为最小开发流转单元。  
2. **在高级路线图（Advanced Roadmaps Plans）中配置层级关系**：  
   * 进入“Jira 齿轮图标 \-\> 方案配置 \-\> 关联设置（Issue types hierarchy）”。  
   * 将最大层级设置为 Initiative，并将其父级关联指向 Feature（即原来的Epic），最后指向 Story/Task。  
   * 这样一来，在高级路线图中，所有的故事工时和状态都会自动向上进行树状聚合。

 Initiative  
     └── Feature \[特性级 \- 原Jira Epic\]  
             └── Story \[故事级 \- 开发单元\]  
                     └── Sub-Task \[子任务级 \- 个人执行\]

### **4.2 Jira 工作流（Workflows）中的自动化门径与DoD控制**

为了防止开发团队在门径评审通过前擅自进入后续阶段，我们需利用Jira的条件（Conditions）、验证器（Validators）和后置动作（Post-Functions）来建立自动化流水线门径：

#### **1\. 工作流状态与门径跳转设计**

在 Initiative 工作流中配置核心状态：Draft ![][image3] Feasibility Study ![][image3] Concept Approved (Gate 1\) ![][image3] Business Case Ready (Gate 2\) ![][image3] In Development ![][image3] Testing ![][image3] GA Release。

#### **2\. 配置门径自动化校验规则 (Jira Automation Rules)**

* **无代码自动化触发器（Gate 1 自动解锁任务）**：  
  配置触发器：“当 Initiative 的状态从 Feasibility 流转到 Concept Approved (Gate 1\) 时”。  
  * **后置动作**：使用无代码自动化克隆或创建预设的任务模板CSV包（包含该阶段必须完成的概要设计、API定义、测试用例规划等标准Task），并自动将其父级关联到该 Initiative 下，极大地减免了项目经理手动建单的负担。  
* **过渡验证器（Validator）硬约束**：  
  限制“从 In Development 跳转到 Testing”：  
  * **Jira 表达式校验**：设置验证器，检验当前 Initiative 下属的所有 Feature 以及所有的 User Story 是否已100%流转到 Done（或 Resolved）。若存在未完成的卡片，系统直接弹出红色警告并中断拖拽行为，确保阶段验证的严肃性。

#### **3\. 细化DoD至Jira字段限制（Field Required on Transition）**

在Story的“测试中”到“完成”过渡上，配置“验证器（Required Field Validator）”，强制要求开发和测试人员勾选完成以下DoD属性字段，否则无法结单：

* SonarQube\_Scan\_Passed (强制布尔值 True，即静态代码扫描通过且无致命缺陷)。  
* UnitTest\_Coverage\_Rate (强制输入数值 ![][image4])。  
* API\_Doc\_Updated (必填关联文档链接，确保证书或Wiki文档最新) 8。

### **4.3 跨项目依赖管理与路线图配置**

高级路线图（Advanced Roadmaps）是PDT经理控制跨团队依赖的核心看板，避免敏捷开发中的“单兵突进”导致系统集成失败。

* **路线图排期与资源动态调整**：  
  在高级路线图中导入包含前端、后端、测试等不同团队的Jira Boards，并在左侧以Initiative/Feature视图统一展示。右侧的时间条会基于各项目中的团队实际速率（Velocity）和团队容量（Capacity）自动计算交付时间，并直观投射在甘特图上。  
* **依赖红线警告配置**：  
  当一个Feature（如前端页面展现）在Jira中添加了“依赖于（is blocked by）”另一个Feature（如后端服务接口）的链接关系时，Plans路线图会自动在甘特图的时间条之间画出红/绿连接线。一旦后端接口团队将排期向后拖延，导致其预计完成时间超出了前端团队的开始时间，**连接线会瞬间自动变为红色（Red Out Of Sequence Alert）**，并在路线图顶部显示冲突预警，使PDT经理能在Daily Sync（每日站会）上迅速识别依赖冲突并进行资源重排。

### **4.4 外部缺陷流转与基于WSJF的优先级决策配置**

在西方实践中，优先级排期不再由产品经理凭经验拍脑袋决定，而是通过Jira Align中内置的WSJF（Weighted Shortest Job First，加权最短作业优先）算法来进行量化评估：  
![][image5]  
在Jira中，可以配置自定义脚本字段自动计算该得分，并建立缺陷闭环：

1. **外部工单入口**：技术支持团队通过外部平台（如Jira Service Management）上报系统缺陷或改进需求。  
2. **自动同步与估算**：工单自动流转入研发需求池 7。系统架构师和PO协作对该缺陷评估“作业规模（故事点）”，同时输入“业务价值（User/Business Value）”、“时间紧急度（Time Criticality）”和“降低风险/带来新机遇（Risk Reduction/Opportunity Enablement）”。  
3. **优先级自动重排**：Jira通过自定义函数算出WSJF分值。WSJF得分越高的缺陷，其Jira排期优先级会被自动化逻辑自动提到待办列表（Backlog）的最上方，优先塞入下个Sprint的开发范畴，彻底打破产研与业务方在“缺陷修补优先级”上的博弈纠纷。

## **五、 落地路径与实施建议**

将IPD宏观治理与敏捷交付轨相结合，需要持续提升团队的组织素养和工程自动化底座：

1. **从试点（Pilot）开始，遵循“僵化-优化-固化”演进原则**  
   企业切忌在全公司范围内一次性铺开这套混合流程。推荐挑选一个中等风险、跨团队依赖较多的软件产品作为变革试点（Pilot），并挑选具备双轨敏捷思维的骨干出任PDT经理和PO。试点初期，必须“僵化”地遵守门径TR评审的Must-Meet红线，以此约束并纠正以往敏捷开发中“只求速度、不管质量和合规”的坏习惯；试点成功后，再结合团队特点进行裁剪与工作流“优化”，最终将其通过Jira等管理工具予以“固化”。  
2. **构建高度自动化的CI/CD流水线与“质量内建”机制**  
   敏捷交付的前提是系统不发生回退和雪崩 9。传统通过TR评审点来进行“事后围堵缺陷”的质控方式已无法跟上敏捷的发布节奏 9。团队必须推行“质量内建（Quality Built-in）”和流程左移。通过将Jira与GitHub/GitLab及CI系统（如Jenkins/GitLab CI）深度整合，使每一次代码Merge自动运行单元测试、SonarQube扫描和自动化回归测试，用工具和数据代替人工审批，真正实现持续部署、按需发布。  
3. **倡导持续学习，打造高度对齐但自治的团队文化**  
   在双轨制下，PDT经理不应该扮演微观任务指派者的角色，而是要提供战略澄清、路线图对齐和依赖协调。微观执行中，必须充分信任和授权Feature Team在Sprint内自组织和适度自治，让他们直接面对“交付物”结果而非过程汇报。通过在企业内部推行持续学习（Continuous Learning）文化，使职能经理、项目经理和普通研发人员都具备混合项目管理的全局视角，利用可视化看板实现“信息辐射（Information Radiator）”，用数据和流程来推动组织的良性运转。

#### **引用的著作**

1. 从偶然到必然：华为研发投资与管理实践 \- Scribd, 访问时间为 六月 6, 2026， [https://www.scribd.com/document/996949556/%E4%BB%8E%E5%81%B6%E7%84%B6%E5%88%B0%E5%BF%85%E7%84%B6-%E5%8D%8E%E4%B8%BA%E7%A0%94%E5%8F%91%E6%8A%95%E8%B5%84%E4%B8%8E%E7%AE%A1%E7%90%86%E5%AE%9E%E8%B7%B5](https://www.scribd.com/document/996949556/%E4%BB%8E%E5%81%B6%E7%84%B6%E5%88%B0%E5%BF%85%E7%84%B6-%E5%8D%8E%E4%B8%BA%E7%A0%94%E5%8F%91%E6%8A%95%E8%B5%84%E4%B8%8E%E7%AE%A1%E7%90%86%E5%AE%9E%E8%B7%B5)  
2. 3分钟详解IPD的矩阵式组织- 集成产品开发（IPD） \- 禅道项目管理软件, 访问时间为 六月 6, 2026， [https://www.zentao.net/thread/296259.html](https://www.zentao.net/thread/296259.html)  
3. 一文搞懂华为IPD：没有流程支撑的策略，都是纸上谈兵\_北京华夏基石企业管理咨询有限公司, 访问时间为 六月 6, 2026， [http://www.chnstone.com.cn/a/media/Edongcha/2022nian/2022/0208/4949.html](http://www.chnstone.com.cn/a/media/Edongcha/2022nian/2022/0208/4949.html)  
4. IPD框架- 全流程的IPD集成产品研发管理- 禅道项目管理软件, 访问时间为 六月 6, 2026， [https://www.zentao.net/model-ipd.html](https://www.zentao.net/model-ipd.html)  
5. IPD产品开发流程流程图模板\_ProcessOn思维导图, 访问时间为 六月 6, 2026， [https://www.processon.com/view/66bdc09dfb35b76d02dafa2c](https://www.processon.com/view/66bdc09dfb35b76d02dafa2c)  
6. 一文解读：华为IPD结构化流程与敏捷变革\_北京华夏基石企业管理咨询有限公司, 访问时间为 六月 6, 2026， [http://www.chnstone.com.cn/a/media/Edongcha/2022nian/2022/0614/5046.html](http://www.chnstone.com.cn/a/media/Edongcha/2022nian/2022/0614/5046.html)  
7. 了解更多行业及客户案例 \- PingCode \- 新一代智能化研发管理工具, 访问时间为 六月 6, 2026， [https://pingcode.com/customers](https://pingcode.com/customers)  
8. 高效敏捷开发：飞书项目助力企业敏捷开发流程- 飞书官网, 访问时间为 六月 6, 2026， [https://www.feishu.cn/content/agile-development-with-feishu-projects](https://www.feishu.cn/content/agile-development-with-feishu-projects)  
9. 华为IPD结构化流程及其敏捷变革 \- 中国石化新闻网, 访问时间为 六月 6, 2026， [http://www.sinopecnews.com.cn/xnews/content/2025-10/11/content\_7134858.html](http://www.sinopecnews.com.cn/xnews/content/2025-10/11/content_7134858.html)

[image1]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAWCAYAAADwza0nAAAANElEQVR4XmNgGAVDCJSjCxALRjUCgTgQS2LBzVjEQJgZog03IGgjLjAINZIaOIwQbUMCAAAbzgfTePszEAAAAABJRU5ErkJggg==>

[image2]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAWCAYAAADwza0nAAAAkUlEQVR4XmNgGAWDENQBcSe6IDFABojnQ7EimhzRQBiIvwDxcSBmRJMjCLiBOB+IrwOxP5oc0YAViB8C8Ssg5kSTIwiYGSA2fwTiXDQ5vEAPiHcBcTcDJAwIApBNVgyQwKpBk8MKIhgg/gLRID8SBCDPJzGQEJppDBDngPxCUtzpArEKuuDgBE1A/IhIfBekAQCDPBviFiAAkgAAAABJRU5ErkJggg==>

[image3]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABUAAAAZCAYAAADe1WXtAAAAYElEQVR4XmNgGAWjYBSQBFrRBagBPICYH12QGuAiEMujC1IKZgHxHnRBSgE3EC8GYhl0CRiYxgCxmVS8AIh/AXEfA5UAQZeSA64wUDmiQMkpCF2QUkCTxK+ALjAKhiAAAP1eEUD8tdt8AAAAAElFTkSuQmCC>

[image4]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADsAAAAZCAYAAACPQVaOAAAC1ElEQVR4Xu2XTahNURTHl1BEyUc+olySIl+lx9SAIl/FgFIGFCMpihh5ysSbvXoTqZeBDJhIIkm8NyATFCklH4kiSTEhH/+/tZez9nbOdc49uaXOr/7ds/Y+5969zvrY+4o0NDQ0NNRiE3QUGgO9gtbE07+YDg1Bo9OJbrEcOhm0MpkzRojedwrqDbZnKvQQmhDs09APaK2o82Qa9BF6Guy2zIIGg+Ykc53At8vFT3Jj86Drki2a8L5v0FY3RpvPGodFnTPmQnecTUaJrr1SVAegL9AS+fMNV2EV9C4dFHVku7MZnavQWDdGm/cZZyR2dgZ039mEL6uVjJVmHLQfegxtTubKYNFI3/RXaG+4ngk9hw78nlXs2SnB3hFsowe67WxmAaNam13QW9FopAtvhy2QacsSIXyezcXKhHX6GdoYbMOeXRrsRdAHyerzmMTOPZIaUc1jpGiE2QT2JXNFLBNdNMWIclEeOsm51Nm8cavtN9BO0RKzvlAlCJUYlrie/sYTyRzmc74285xqNz5etF4N1ukDZ6+HLkAL3VhHsGFdg/qgyclcEQuge6L7ozl8RbJuXORU0XgKM8W6OKP7CToIPYNW2E1lYeqyQTF12bCqcAl67WymHQ8CdMLqdl2wU6fM2dXJuGcbNDtcs5Yvi75cMhG6Fa5LwYb0Inx2UhNsPIPpoOh29F3UEWtQW6I7tFvTWWtQKS2J658NkC/Qpzi3q7YweowiU49RrQMbUn86CE5A70WjwIPAuTDmsRNS0T7P05RFldhL886m3xmxRzTn6x4mDC4o7+h2VzTFrVHlHSpuSnETbEl82iJpZLn+s9n0v4c/uEF00TeCeG115TkvGsnd4Zrpn9cjWKe++3r4R+GI6O8egi7G092Btck/Ab2i6ZYHFzhfdM9kNy2C2UKn8uB38JjLrYfdeHE8HWN7WBnxH8Z/zXHoZUnl1WJDQ0N3+AkZ353FmINYewAAAABJRU5ErkJggg==>

[image5]: <data:image/png;base64,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>