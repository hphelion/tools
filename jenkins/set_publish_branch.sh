#!/bin/bash

git checkout master
git pull

echo "
<html>
<body>
<p>The $1 branch currently selected to push to production is:</p>

<p><b>

<!-- BRANCH_TO_PUBLISH -->  $BRANCH_TO_PUBLISH

</b>
</p>

</body>
</html>

"> ./jenkins/${1}.publish.branch.html

git add .
git commit -m "A jenkins job changed the $1 publish branch to $BRANCH_TO_PUBLISH"
git push
