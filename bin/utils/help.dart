class VadHelp {
  final String usage;

  VadHelp(this.usage);

  show() {
    print("""

** DVA-CLI 帮助 **

主要指令
vad config  生成config文件，在编辑完config文件后，你应当立即调用一次vad init
vad init    生成基础的mixin与数据源结构
vad build   生成页面，可以使用-m,-d指令指定对应参数
vad complete 完善json，例如 vad complete -d admin 可以完善admin的json格式为完整格式

修饰指令
${usage}

    """);
  }
}
