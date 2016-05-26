## 拉取所有Deepin项目源码

```
mkdir deepin
wget https://gitcafe.com/Deepin/git-repo/raw/master/repo
chmod +x repo
./repo init -u https://cr.deepin.io/repos --no-repo-verify
./repo sync --no-clone-bundle
```

## 添加SSH访问权限, 否则无法推送变更

```
cd .repo/manifests
cp __local_tpl.xml __local.xml
# edit __local.xml and input ssh username
cd -
./repo init -m __local.xml
./repo sync
```

## 检测Gerrit项目列表

```
./.repo/manifests/check_projects.sh
```

## Tips

1. 运行`repo sync -f`修复失效的项目

2. 如果`repo sync`阻塞可以先`Ctrl-\`退出进程然后运行下面的命令检测是哪
个项目同步失败
```
repo sync -j1
```

3. 显示所有没有tag的项目列表
```
./.repo/manifests/repokit.sh show_prj_no_tag
```

4. 显示最新提交没有tag的项目列表
```
./.repo/manifests/repokit.sh show_prj_latest_no_tag
```

5. 为指定项目创建tag
```
./.repo/manifests/repokit.sh new_tag --push dde/dde-daemon 3.0.0
```

5. 为多个项目批量创建tag
```
./.repo/manifests/repokit.sh --push multi_new_tags newtags.txt
```

5. 显示repokit.sh使用帮助
```
./.repo/manifests/repokit.sh -h
./.repo/manifests/repokit.sh -h show_prj_no_tag
```
