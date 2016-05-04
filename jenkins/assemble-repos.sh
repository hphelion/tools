#!/bin/bash
source <(curl -s https://raw.githubusercontent.com/hphelion/tools/master/jenkins/functionLibrary.sh)
HIPCHAT_ROOM="$1"


function adjust_date_to_last_commit {
	pwd
    cd $repo
	pwd    
    for t in $(find . -name "*.dita");
    do
    	echo $repo : $t
        stat --format=%y $t
    	git log -1 --date=iso --pretty=format:%ad $t | sed 's| +.*||'
        echo""
    	touch -d "`git log -1 --date=iso --pretty=format:%ad $t | sed 's| +.*||'` " $t
        stat --format=%y $t
        echo""
	done
    cd -    
}
 
 function clone_repo {
 repo=$1
 branch=$2
 
	echo "clone $repo"
 	if [[ $(git ls-remote git@github.com:hphelion/${repo} ${branch} ) ]]; then
    echo "Branch $branch exists on github"
	
	rm -r $repo
		if ! git clone -b ${branch} --single-branch --depth 1 git@github.com:hphelion/${repo}.git ${repo}
		then
			echo >&2 Cloning git@github.com:hphelion/${repo}.git failed.  Stopping the build.

			hipChat FAIL "Cloning the <b>$repo repo failed.</b> Stopping the build.  The files on docs.hpcloud.com were not changed." $HIPCHAT_ROOM
			exit 1;
		fi
	
	else
		echo "Branch $branch does not exist on github.  Stopping the build."
		hipChat FAIL "Branch <b>$branch</b> does not exist on in the $repo on github. Stopping the build. The files on docs.hpcloud.com were not changed." $HIPCHAT_ROOM

		exit 1;
	fi	
}


  


pwd
source ./tools/jenkins/publish-config.sh
 
echo "

#################################################################

      devplat_docs_BRANCH = $devplat_docs_BRANCH
          hos_docs_BRANCH = $hos_docs_BRANCH
          hos_docs_LEGACYBRANCH = $hos_docs_LEGACYBRANCH
carrier_grade_docs_BRANCH = $carrier_grade_docs_BRANCH
 public_cloud_docs_BRANCH = $public_cloud_docs_BRANCH
          hcf_docs_BRANCH = $hcf_docs_BRANCH

#################################################################
"



   repo="hos.docs"
   echo start $repo clone
	echo "clone $repo"
 	rm -r $repo
	git clone -b $hos_docs_BRANCH --single-branch git@github.com:hphelion/${repo}.git ${repo}
    
    adjust_date_to_last_commit

    cp -rp ${repo}/community/ ./3.x/
    cp -rp ${repo}/commercial/ ./3.x/
    cp -rp ${repo}/helion/ ./3.x/
    cp -rp ${repo}/hos-html/ ./3.x/
	cp -rp ${repo}/media/ ./3.x/
    cp -rp ${repo}/media/${repo} ./3.x/media/${repo}
    cp -rp ${repo}/*.ditamap ./3.x/
 
	rm -r ${repo}
    
	
	
repo="devplat.docs"
echo start $repo clone
branch="$devplat_docs_BRANCH"
rm -r $repo
	git clone -b $hos_docs_BRANCH --single-branch git@github.com:hphelion/${repo}.git ${repo}
    
    adjust_date_to_last_commit
	cp -rp ${repo}/devplatform/ ./
	cp -rp ${repo}/media/${repo} ./media/${repo}
    cp -rp ${repo}/*.ditamap ./
    cp -rp ${repo}/hdp-html/ ./
 
    rm -r $repo
 
  

repo="carrier.grade.docs"
echo start $repo clone
branch="$carrier_grade_docs_BRANCH"

rm -r $repo
	git clone -b $hos_docs_BRANCH --single-branch git@github.com:hphelion/${repo}.git ${repo}
    
    adjust_date_to_last_commit
	cp -rp ${repo}/media/${repo} ./media/${repo}
	cp -rp ${repo}/CarrierGrade/ ./
    cp -rp ${repo}/CarrierGrade2.0/ ./
    cp -rp ${repo}/CarrierGrade2.1/ ./
    cp -rp ${repo}/*.ditamap ./

	rm -r ${repo}


repo="hcf.docs"
echo start $repo clone
branch="$hcf_docs_BRANCH"
rm -r $repo
	git clone -b $hos_docs_BRANCH --single-branch git@github.com:hphelion/${repo}.git ${repo}
    
    adjust_date_to_last_commit
	cp -rp ${repo}/media/${repo} ./media/${repo}
    cp -rp ${repo}/*.ditamap ./
	cp -rp ${repo}/hcf/ ./
    
	rm -r ${repo}

	
	
repo="hos.docs"
echo start $repo clone
branch="$hos_docs_LEGACYBRANCH"
rm -r $repo
	git clone -b $hos_docs_BRANCH --single-branch git@github.com:hphelion/${repo}.git ${repo}
    
    adjust_date_to_last_commit
	cp -rp ${repo}/community/ ./
    cp -rp ${repo}/commercial/ ./
    cp -rp ${repo}/helion/ ./
    cp -rp ${repo}/hos-html/ ./
	cp -rp ${repo}/media/ ./
    cp -rp ${repo}/media/${repo} ./media/${repo}
    cp -rp ${repo}/*.ditamap ./
 
	rm -r ${repo}

 	echo "clone $repo"
 repo="wrapper.docs"
branch="bundle-2015-may"
  rm -r $repo
   rm -r docs.hpcloud.com.ditamap
	git clone -b $hos_docs_BRANCH --single-branch git@github.com:hphelion/${repo}.git ${repo}
    
 
 
   

 
    
    adjust_date_to_last_commit

	cp -r ${repo}/* ./
   
    rm -r ${repo}


 
 
