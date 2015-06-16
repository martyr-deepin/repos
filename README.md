=克隆 deepin 各项目源码=

    mkdir deepin
    wget https://gitcafe.com/Deepin/git-repo/raw/master/repo
    chmod +a repo
    ./repo init -u https://cr.deepin.io/repos --no-repo-verify
    ./repo sync --no-clone-bundle
    ./repo init -b develop
