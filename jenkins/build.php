#!/usr/bin/php

<?php

// This is PHP Build script.
//

	// Create the Build class as the basis for all builds.  
	// Other classes can extend and inherit from this main class.
	class Build {
		public $build_number;
		public $repos;
		public $branch;
		public $build_user;
		public $license;
		
		// Create the constructor to be able to build new build objects.
		public function __construct($build_number, $repos, $branch, $build_user, $license) {
			$this->build_number = $build_number;
			$this->repos = $repos;
			$this->branch = $branch;
			$this->build_user = $build_user;
			$this->license = $license;
		}

		// Get and set methods for the build number.
		public function getBuild() {
			return $this->build_number;
		}
		
		public function setBuild($build_number) {
			$this->build_number = $build_number;
		}
		
		
		// Get and set methods for repos;
		public function getRepos() {
			return $this->repos;
		}
		
		public function setRepos($repos) {
			$this->repos = $repos;
		}
		
		//Get and set methods for branch.
		public function getBranch() {
			return $this->branch;
		}
		
		public function setBranch($branch) {
			$this->branch = $branch;
		}
		
		
		// Get and set methods for build user.
		public function getBuildUser() {
			return $this->build_user;
		}
		
		public function setBuildUser($build_user) {
			$this->build_user = $build_user;
		}
		
		
		// Get and set methods for license.
		// The get and set method for license may not be necessary if the
		// license is a static element in the builds.
		public function getLicense() {
			return $this->license;
		}
		
		public function setLicense($license) {
			$this->license = $license;
		}
		
		
		/////////////////////////////////////////////////////////
		//
		// Non constructor, get or set methods.
		//
		/////////////////////////////////////////////////////////
		
		// Init function - top of build.
		public function init() {
			
			setlocale(LC_TIME, "C");
			
			
			if(file_exists('/usr/bin/git')) {
				$git = "/usr/bin/git";
			} elseif(file_exists('/bin/git')) {
				$git = "/bin/git";
			} elseif(file_exists('C:/Program Files \(x86\)/Git/bin/git.exe')) {
				$git = "C:/Program Files \(x86\)/Git/bin/git.exe";
			} else {
				$git = "Unable to find git";
			}
			
			
			print "=============================================================================\n";
			print "                    Initializing Build System \n\n";
			print "Date: " . strftime('%A, %B %d, %G - %r') . "\n";
			print "Building: " . $this->getRepos() . "/" . $this->getBranch() . "\n";
			print "Build Number: " . $this->getBuild() . "\n";
			print "Requested by: " . $this->getBuildUser() . "\n";
			print "License file: " . $this->getLicense() . "\n";
			print "Git Location: " . $git . "\n";
			print "\n";
			print "=============================================================================\n";

		}
		
		
	}
	
	// Create the DebugBuild class which will provide a 
	// extra set of features for debugging builds.
	class DebugBuild extends Build {
		public $debug = true;
		public $debugLog;
			
		// Create the constructor to be able to build new build objects.
		public function __construct($debugLog) {
			$this->debugLog = $debugLog;
	
		}
			
		public function getDebugLog() {
			return $this->$debugLog;
		}
		
		public function setDebugLog() {
			$this->debugLog = $debugLog;
		}
	}

	
	/////////////////////////////////////////////////////////
	// Beginning of build
	/////////////////////////////////////////////////////////
	//
	// Programmatically, the build should be able to figure out what the 
	// build number is, get the user who started the build from git or Jenkins,
	// have the license file statically set (perhaps), but the project to build
	// would likely need to be passed in.  Ideally, this information would be
	// in a build database.
	
	$build = new Build('1','https://github.com/hphelion/hos.docs', 'hos-40', 'check-in-person', 'myLicense');
	$build->init();
	
	
?>
