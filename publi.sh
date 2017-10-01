slimrb -p *.slim *.html
git add --all
git commit -m 'commit via publi.sh'
git push origin HEAD
echo '-------------------------------- finished --------------------------------'
git status
