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

## Check projects difference with gerrit

```
./.repo/manifests/check_projects.sh
```

## Tips

1. Advice to run `repo sync -f` to fix broken repositories

2. Sometimes `repo sync` will blocked and there is no more messages, just
`Ctrl-\` and re-sync with one job to see which one failed
```
repo sync -j1
```

3. Show projects with no tag
```
./.repo/manifests/repokit.sh show_prj_with_no_tag
```

4. Show projects that latest commit with no tag
```
./.repo/manifests/repokit.sh show_prj_latest_commit_with_no_tag
```

5. Create new tag for project
```
./.repo/manifests/repokit.sh new_tag_for_prj --push dde/dde-daemon 3.0.0
```

5. Create new tags for multiple projects
```
./.repo/manifests/repokit.sh --push multi_new_tag_for_prjs newtags.txt
```

5. Show repokit.sh usage
```
./.repo/manifests/repokit.sh -h
./.repo/manifests/repokit.sh -h show_prj_with_no_tag
```
