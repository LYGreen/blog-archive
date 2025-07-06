+++
date = '2025-01-04T15:12:12+08:00'
draft = false
title = 'Hugo 创建网站教程'
description = "使用 Hugo 创建自己的网站"
categories = [
    "知识分享",
]
tags = [
    "Hugo",
]
+++

## 准备工作
- [Hugo](https://gohugo.io/)
- Hugo 主题，这里使用的是 [Stack](https://github.com/CaiJimmy/hugo-theme-stack)

## 进行网站的创建
### 创建网站
找一个空的文件夹，输入命令，之后会出现新的文件夹，进入到文件夹里面
```bash
hugo new site [name]
cd [name]
```

此时会生成这一堆文件夹
```
[name]/
├── archetypes/
│   └── default.md
├── assets/
├── content/
├── data/
├── i18n/
├── layouts/
├── static/
├── themes/
└── hugo.toml         <-- 站点配置
```

将下载的主题放到这个 `theme` 文件夹里面，改个名，像这样(也可以不改名但是这样的话等下就要改配置文件)
![](img-create-a-hugo-website/img0.png)

进到这个目录里面，里面也是有一堆文件，和我们刚才创建网站时生成的有点像，不过没关系不重要，里面有一个`exampleSite` 文件夹，进入到里面，我们把 `hugo.yaml` 文件复制到 `[name]/hugo.yaml` ，并删除 `hugo.toml` (Hugo 支持 `yaml`, `toml` 和 `json` 这 3 种语法格式，只需要一个就好)，就像这样
![](img-create-a-hugo-website/img1.png)

在 `[name]/` 目录打开 `cmd`，输入
```bash
hugo server
```
再在浏览器里输入 `localhost:1313` 即可看到网站
![](img-create-a-hugo-website/img2.png)

## 配置网站
Stack 主题的配置说明可以在 [这里](https://stack.jimmycai.com/config/) 找到，这篇文章只列出少部分

### 创建文章
根据刚才的 `exampleSite/content` 进行对我们网站里面的 `content` 进行创建目录 (也可以直接复制粘贴)，因为不同的主题设置的目录结构可能会不同，例如有的主题把 `content/post` 当作存储文章的地方，而有的主题把 `content/posts` 当作存储文章的地方，`Stack` 主题用的是 `content/post` ，如果不把文章放在这个地方，会导致首页显示不出文章来 (如果有能力的话可以进行对主题源文件的修改，很简单的)
![](img-create-a-hugo-website/img3.png)
![](img-create-a-hugo-website/img4.png)

接着创建一篇文章，有 2 种方法，这 2 种方法等效
- 第一种做法(我喜欢的)
```bash
hugo new post/first-post/index.md
```
- 第二种做法
```bash
hugo new post/first-post.md
```
创建好了之后用记事本进行编辑，可以看到里面已经自动生成了一些内容
```
+++
date = '2025-01-04T17:43:36+08:00'
draft = true
title = 'First Post'
+++
```
这个内容是根据 `archetypes/default.md` 进行创建的，如果有需要也可以创建其他模板。编辑一下：
```
+++
date = '2025-01-04T17:43:36+08:00'
draft = true
title = 'First Post'
+++

# First post
Some content.
```
保存，再次打开 `localhost:1313` 会发现并没有文章输出，这是因为这篇文章当前是草稿(draft)，有 2 种方法可以解决
- 将 draft 变量 改成 false
```
draft = false
```
- 停止运行 Hugo，在命令行里输入
```
hugo server --buildDrafts
```
此时再次打开 `localhost:1313` 就会发现第一篇文章已经显示在首页当中了

#### 分类与标签
在文件中加入 `categories` 和 `tags` 参数，例如：
- 例子
```
date = '2025-01-04T17:43:36+08:00'
draft = false
title = 'First Post'
categories = "test categories"
tags = "test tags"
```
- 例子
```
date = '2025-01-04T17:43:36+08:00'
draft = false
title = 'First Post'
categories = [
    "test categories",
    "test categories 2",
]
tags = [
    "test tags",
    "test tags 2",
]
```
![](img-create-a-hugo-website/img5.png)

### 名称与描述
刚才我们已经把 `exampleSite/hugo.yaml` 文件复制到 `[name]/hugo.yaml` 了，用记事本打开这个文件，可以找到一下内容
```
# Theme i18n support
# Available values: ar, bn, ca, de, el, en, es, fr, hu, id, it, ja, ko, nl, pt-br, th, uk, zh-cn, zh-hk, zh-tw
DefaultContentLanguage: en

# Set hasCJKLanguage to true if DefaultContentLanguage is in [zh-cn ja ko]
# This will make .Summary and .WordCount behave correctly for CJK languages.
hasCJKLanguage: false

languages:
    en:
        languageName: English
        title: Example Site
        weight: 1
        params:
            sidebar:
                subtitle: Example description
    zh-cn:
        languageName: 中文
        title: 演示站点
        weight: 2
        params:
            sidebar:
                subtitle: 演示说明
```
`DefaultContentLanguage` 值可以改成 `zh-cn`，两种语言的 `演示站点` 和 `演示说明` 部分根据自己的需要进行修改

### 头像
如果需要插入图片，则需要把图片放在 static 文件夹里面，并且配置的时候需要用绝对路径，否则在某些页面会显示不出来  
将自己的图片放在 `static` 文件夹里面，例如我放在了 static/my-img/ 里面
![](img-create-a-hugo-website/img6.png)
在 `hugo.yaml` 中找到
```
    sidebar:
        emoji: 🍥
        subtitle: Lorem ipsum dolor sit amet, consectetur adipiscing elit.
        avatar:
            enabled: true
            local: true
            src: img/avatar.png
```
将 src 的值修改为 `/my-img/image.png` ，绝对路径以 `/` 开头，`./my-img/image.png` 和 `my-img/image.png` 都是相对路径，修改了之后可以自己查看效果

### 菜单
在 `content` 目录下创建文件 `index.zh-cn.md` (也可以创建 `index.md`，`index.en.md` 或者根据语言来创建其他的版本)，这个文件相当于网站的首页(index)，将内容清空，输入以下内容：
```
---
title: 主页
menu:
    main:
        params:
            icon: home
---
```
不同的主题有不同的配置，具体看文档，添加了之后效果：
![](img-create-a-hugo-website/img7.png)

## 扩展功能
这里我 [fork](https://github.com/LYGreen/hugo-theme-stack) 了一份原来的主题，用来对原来的主题进行细微的修改

### 自定义的网站图标和主页标题
#### 网站图标
`layouts/partials/head/head.html`
```html
<link rel="icon" href="{{ .Site.Params.websiteIcon }}" type="image/x-icon" />
```
`exampleSite/hugo.yaml`
```yaml
...
params:
    # 网站图标，绝对路径以 '/' 开头，例如 /path/image.png。 path/image.png 和 ./path/image.png 都是相对路径
    websiteIcon: 
...
```

#### 主页标题
`layouts/partials/data/title.html`
```html
{{- $siteTitle := .Site.Params.homepageTitle -}} <!-- 此处做了修改，原值为 .Site.Title -->
```
`exampleSite/hugo.yaml`
```yaml
languages:
    en:
        ...
        params:
            homepageTitle: "Example homepage title"
            ...
    zh-cn:
        ...
        params:
            homepageTitle: "演示主页标题"
            ...
```

### 布局
`assets/scss/gird.scss`
```scss
...
    .left-sidebar {
        margin-left: 2%; /* 经改动，原版没有 */
        margin-right: 2%; /* 经改动，原版没有 */
        order: -3;
        max-width: var(--left-sidebar-max-width);
    }
...
    &.extended {
        @include respond(md) {
            max-width: 1024px;
            --left-sidebar-max-width: 25%;
            --right-sidebar-max-width: 25%; /* 经改动，原值 30% */
        }

        @include respond(lg) {
            max-width: 1280px;
            --left-sidebar-max-width: 20%;
            --right-sidebar-max-width: 25%; /* 经改动，原值 30% */
        }

        @include respond(xl) {
            max-width: 1536px;
            --left-sidebar-max-width: 15%;
            --right-sidebar-max-width: 21%; /* 经改动，原值 25% */
        }
    }
...
```
`assets/scss/variables.scss`
```scss
    --section-separation: 20px; /* 经改动，原值 40px */
```

---
还有的不列啦，我懒(实际上修改的也不多，目前一共只添加了3样功能)