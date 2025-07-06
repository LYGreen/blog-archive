git branch -D gh-pages
git add -f public
git commit -m "deploy: upload files"
git subtree split --prefix=public -b gh-pages
git push origin gh-pages --force
git reset HEAD^^
