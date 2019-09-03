#!/bin/sh
#
export outcome=1
git ls-files | xargs -n 1 dirname | uniq >/tmp/dirs.txt
sed -i 's/\//\n/g' /tmp/dirs.txt
paste -d" " -s /tmp/dirs.txt > /tmp/dir_before_commit_final
sed -i 's/\.//g' /tmp/dir_before_commit_final
sed -i 's/gitignore//g' /tmp/dir_before_commit_final
sed -i 's/ /\n/g' /tmp/dir_before_commit_final | sort|uniq
sed -i '/^$/d' /tmp/dir_before_commit_final
cat /tmp/dir_before_commit_final | sort |uniq -c | awk -F " " '

{print $2}' > /tmp/dir_before_commit_final
export DIR="$(</tmp/dir_before_commit_final)"
echo "shivangi dir list is **************************** /n" $DIR
#rm -rf /tmp/dir_before_commit_final
#rm -rf /tmp/dirs.txt
git add --all
git commit -m "updated file"
find . -type d ( -path .git ) -prune -o -type d -print | grep -v .git > /tmp/dir_after_commit
sed -i 's/\.//g' /tmp/dir_after_commit
sed -i 's/\.//g' /tmp/dir_after_commit
sed -i 's/\.///g' /tmp/dir_after_commit
sed -i 's/\// /g' /tmp/dir_after_commit
paste -d" " -s /tmp/dir_after_commit > /tmp/dir_after_commit_final
sed -i 's/ /\n/g' /tmp/dir_after_commit_final | sort | uniq
sed -i '/^$/d' /tmp/dir_after_commit_final | sort | uniq
cat /tmp/dir_after_commit_final | sort |uniq -c | awk -F " " '{print $2}' > /tmp/dir_after_commit_final
tr -s '[:blank:]' '[\n*]' </tmp/dir_after_commit_final |while IFS=" " read -r word;
do
echo "shivangi in tr loop word is ********************************************************************************************** "$word
result=$(grep $word /tmp/dir_before_commit_final)
echo $word "searched in /tmp/dir_before_commit_final , and result is "$result
if [ ${#result} -ge 2 ]; then
#if [ $(echo "${result}" | wc -l) -eq 1 ]; then
echo " shivangi result of grep is " $result "that means match found "
#outcome=1
echo 1 > /tmp/outcome
else
echo "No Match found , exitting , you will not be allowed to psuh code as you have added some directory"
#outcome=2
echo 2 > /tmp/outcome
exit 1
fi
done
if [ `cat /tmp/outcome` = 1 ]; then
git push origin master
else
echo "Sorry no push allowed as you have created a new directory "
fi

exit 0
