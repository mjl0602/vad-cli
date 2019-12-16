

# Vue-Admin-Dart-Cli
使用dart语言编写的vue-admin代码生成器，简称Vad-Cli

# TODO
- [ ] 确定bmob的独立config
- [ ] bmob的Json生成
- [ ] bmob的init函数生成
- [ ] 路由的覆盖与生成
- [ ] 检查当前项目是否是vue admin项目
- [ ] vue admin整体模板载入
# 安装

```shell
git clone https://github.com/mjl0602/vad-cli.git
cd vad-cli
pub global activate --source path ./
```

# dart2native

```bash
# mac
dart2native bin/main.dart -o build/vad-cli-mac
# win
dart2native bin/main.dart -o build/vad-cli-win
```

# 命令
- vad config
- vad init
- vad build
- vad build (-m bmob)
- vad build (-m axios)
- vad build admin

# 目录
```bash
├── bin # 总目录
│   ├── config # 配置类
│   │   └── vadConfig.dart
│   ├── controller # builder类，负责生成代码
│   │   ├── bmobBuilder.dart
│   │   └── builder.dart
│   ├── model # 表格内容类
│   │   ├── vadKey.dart
│   │   ├── vadProject.dart
│   │   └── vadTable.dart
│   ├── tools # 加载json的类，待完成
│   │   └── bmobLoader.dart
│   ├── main.dart # 主入口
│   └── utils # 各种工具类
│       ├── help.dart
│       ├── path.dart
│       ├── safeMap.dart
│       └── type.dart
├── example # 示范
│   ├── src
│   │   ├── vad-api
│   │   │   ├── admin.js
│   │   │   └── super
│   │   │       └── dataSource.js
│   │   ├── vad-data
│   │   │   └── admin.json
│   │   └── vad-pages
│   │       ├── adminManage.vue
│   │       └── basic
│   │           └── mixin.js
│   └── vad-config.json
├── pubspec.lock
├── pubspec.yaml
├── readme.md
└── template
    ├── bmob_api.js
    ├── bmob_template.vue
    ├── temp_admin.json
    ├── temp_api.js
    ├── temp_dataSource.js
    ├── temp_mixin.js
    ├── temp_page.vue
    └── vad-config.json
```