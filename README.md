===克隆 deepin 各项目源码===

    mkdir deepin
    wget https://gitcafe.com/Deepin/git-repo/raw/master/repo
    chmod +a repo
    ./repo init -u https://cr.deepin.io/repos --no-repo-verify
    ./repo sync --no-clone-bundle

===添加 ssh 访问权限===

    cd .repo/manifests
    cp __local_tpl.xml __local.xml
    # 编辑 __local.xml, 输入 ssh 用户名
    cd -
    ./repo init -m __local.xml
    ./repo sync
