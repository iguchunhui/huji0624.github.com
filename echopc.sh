if [[ $# != "3" ]]; then
	#statements
	echo 'echopost.sh author title categories'
	exit 1
fi

echo '---\\n'
echo "author: $1"'\\n'
echo 'comments: true\\n'
dstr=`date +%Y-%m-%d\ %H:%M:%S+00:00`
echo 'date: '$dstr'\\n'
echo 'layout: post\\n'
echo "slug: $2"'\\n'
echo "title: $2"'\\n'
echo 'categories:\\n'
echo "- $3"'\\n'
echo '---\\n'
echo 'content'
exit 0
