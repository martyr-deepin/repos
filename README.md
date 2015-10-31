## Clone Deepin projects

```
mkdir deepin
wget https://gitcafe.com/Deepin/git-repo/raw/master/repo
chmod +a repo
./repo init -u https://cr.deepin.io/repos --no-repo-verify
./repo sync --no-clone-bundle
```

## Add SSH access permision

```
cd .repo/manifests
cp __local_tpl.xml __local.xml
# edit __local.xml and input ssh username
cd -
./repo init -m __local.xml
./repo sync
```

## Check project list

```
./.repo/manifests/check_projects.sh
```

## Tips

1. Advice to run `repo sync -f` to fix broken repositories

2. Sometimes `repo sync` will blocked and there is no more messages, just
`Ctrl-\` and re-sync with one job to see which one failed
```
./repo sync -j1
```
