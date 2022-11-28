FROM node:latest

MAINTAINER linci <1591352008@qq.com>

# 正式工作目录
WORKDIR /usr/blog

# 配置 npm 镜像站点  
RUN npm config set registry https://registry.npm.taobao.org

# 安装 git hexo-cli
RUN npm install -g hexo-cli
# 初始化 hexo blog  
RUN hexo init

ADD data .

#把主题移到theme中
RUN cp -a hexo-theme-matery themes

# 配置 hexo 使用 matery 主题  
RUN sed -i 's/landscape/hexo-theme-matery/g' _config.yml

#新建分类 categories 页 标签 tags 页 about 页 友情连接 friends 页
RUN hexo new page "categories" && \
    hexo new page "tags" && \
    hexo new page "about" && \
    hexo new page "friends"

#添加内容
RUN sed -i '/data/atype: "categories" \nlayout: "categories"' source/categories/index.md && \
    sed -i '/data/atype: "tags" \nlayout: "tags"' source/tags/index.md && \
    sed -i '/data/atype: "about" \nlayout: "about"' source/about/index.md && \
    sed -i '/data/atype: "friends" \nlayout: "friends"' source/friends/index.md

#新建_data目录，在该目录中新建friends.json
RUN mkdir source/_data

# 生成sitemap，优化SEO
RUN npm install && \
    npm install --save hexo-generator-sitemap hexo-generator-baidu-sitemap

#代码高亮
RUN npm i -S hexo-prism-plugin  && \
    npm install hexo-generator-search --save && \
    npm i hexo-permalink-pinyin --save && \
    npm i --save hexo-wordcount && \
    npm install hexo-generator-feed --save

RUN sed -i '47s/true/false/' _config.yml
RUN sed -i '$aprism_plugin:\n  mode: 'preprocess'    # realtime/preprocess\n  theme: 'tomorrow'\n  line_number: false    # default false\n  custom_css:\nsearch:\n  path: search.xml\n  field: post\npermalink_pinyin:\n  enable: true\n  separator: '\''-'\'' # default: '-'\nfeed:\n  type: atom\n  path: atom.xml\n  limit: 20\n  hub:\n  content:\n  content_limit: 140\n  content_limit_delim: ''\n  order_by: \-date' _config.yml

#文章字数统计插件
RUN sed -i '46s/false/true/' themes/hexo-theme-matery/_config.yml && \
    sed -i '47s/false/true/' themes/hexo-theme-matery/_config.yml && \
    sed -i '48s/false/true/' themes/hexo-theme-matery/_config.yml && \
    sed -i '49s/false/true/' themes/hexo-theme-matery/_config.yml && \
    sed -i '50s/false/true/' themes/hexo-theme-matery/_config.yml

#重新生成博客文件
#RUN hexo clean && hexo g

# Expose Server Port
EXPOSE 4000
# 运行命令
CMD ["hexo","server"]
