<?php

// This is PHP script.
// Build.class provides the class object, method and variables.
//

	// Create the Build class as the basis for all builds.  
	// Other classes can extend and inherit from this main class.
	class Build {
		public $BUILD_NUMBER;
		public $BUILD_USER;
		public $debug;
		public $CONF_DIR = "/var/lib/jenkins/tools/conf";

		// Create the constructor to be able to build new build objects.
		public function __construct() {
			$this->BUILD_NUMBER = $BUILD_NUMBER;
			$this->BUILD_USER = $BUILD_USER;
		}

		// Magic get method.
		function __get($name) {
			return $this->$name;
		}

		// Magic set method.
		function __set($key, $value) {
			$this->$key = $value;				
		
		}		
		
		// Destructor - deletes the build object.
		public function __destruct() {
		
			echo $this->name . " is being destroyed.\n";
		}
		
		public function buildTime() {
		
			// Prints the local time in Pacific Time Zone.
			//
			date_default_timezone_set('America/Los_Angeles');
			$time = date("F j, Y, g:i a");
			return "$time (Pacific Time)\n";
			
		}
		
		public function getCmdLine() {
		
			// Using getopt, get the options for this build.  The two options are currently:
			// --debug - sets debug flag to on 
			// --conf=<conf_file> - take a configuration file as input to the build.  REQUIRED.
			//
			$options = getopt('', array('debug','conf:'));
			if($options['debug'] === false) {
				$this->debug = true;
				//var_dump($options);
			} else {
				$this->debug = false;
			}
			
			// Make sure the conf file was passed to the script, without it the build is dead.
			if(!$options["conf"]) {
				echo "--conf=<conf_file>: conf file required!\n";
				exit(1);
			} elseif(!file_exists($options['conf'])) {
				echo "Unable to find conf file: " . $options['conf'] . "\n";
				exit(1);
			} else {				
				$buildconf = parse_ini_file($options['conf']);
				$this->conf = $options['conf'];
				foreach($buildconf as $key => $value) {
					//print "Key: $key  => Value: $value\n";
					$this->$key = $value;
				
				}
			}


		}
		
		
		public function init() {
		
			print "===================================================================\n";
			print "Build Started at:       " . $this->buildTime() . "\n";
			print "Building:               $this->PROJECT_NAME\n\n";
			print "Project:                $this->PROJECT\n";
			print "Version:                $this->VERSION\n";
			print "Git Repository:         $this->REPOS\n";
			print "Branch:                 $this->BRANCH\n";
			print "Git Tools Repository:   $this->TOOLS_REPOS\n";
			print "Branch:                 $this->TOOLS_BRANCH\n";
			print "Configuration File:     $this->conf\n";
			if($this->debug) {	
				print "DEBUG MODE:             On\n";
			} else {
				print "DEBUG MODE:             Off\n";
			}
			print "===================================================================\n";

			//
			// Set Environment Variables
			//
			
			// JAVA
			if($this->JAVA) { 
				putenv("JAVA=" . $this->JAVA);
			} else {
				print "JAVA not set.  Please make sure JAVA is set in the $this->conf file.\n";
				exit(1);
			}
			
			// CLASSPATH
			if($this->CLASSPATH) {
				$current_classpath = getenv("CLASSPATH");
				putenv("CLASSPATH=" . $this->CLASSPATH . ":" . $current_classpath);
			} else {
				print "CLASSPATH not set.  Please make sure CLASSPATH is set in the $this->conf file.\n";
				exit(1);
			}
			
			//XEP_HOME
			if($this->XEP_HOME) {
				putenv("XEP_HOME=" . $this->XEP_HOME);
			} else {
				print "XEP_HOME not set.  Please make sure XEP_HOME is set in the $this->conf file.\n";
				exit(1);
			}
			
			// DITA_HOME
			if($this->DITA_HOME) {
				putenv("DITA_HOME=" . $this->DITA_HOME);
			} else {
				print "DITA_HOME not set.  Please make sure DITA_HOME is set in the $this->conf file.\n";
				exit(1);
			}
			
			//DITA_OT_INSTALL_DIR
			if($this->DITA_OT_INSTALL_DIR) {
				putenv("DITA_OT_INSTALL_DIR=" . $this->DITA_OT_INSTALL_DIR);
			} else {
				print "DITA_OT_INSTALL_DIR not set.  Please make sure DITA_OT_INSTALL_DIR is set in the $this->conf file.\n";
				exit(1);
			}	

			//DITA_MAP_BASE_DIR
			//
			// !!!  Check this variable out and see if it needs to be set here before running the bulds. !!! //
			//
			if($this->DITA_MAP_BASE_DIR) {
				putenv("DITA_MAP_BASE_DIR=" . $this->DITA_MAP_BASE_DIR);
			} else {
				print "DITA_MAP_BASE_DIR not set.  Please make sure DITA_MAP_BASE_DIR is set in the $this->conf file.\n";
				exit(1);
			}	

			// WORKSPACE
			if($this->WORKSPACE) {
				putenv("WORKSPACE=" . $this->WORKSPACE);
			} else {
				print "WORKSPACE not set.  Please make sure WORKSPACE is set in the $this->conf file.\n";
				exit(1);
			}
			
			//SAXON9_DIR
			if($this->SAXON9_DIR) {
				putenv("SAXON9_DIR=" . $this->SAXON9_DIR);
			} else {
				print "SAXON9_DIR not set.  Please make sure SAXON9_DIR is set in the $this->conf file.\n";
				exit(1);
			}
			
			//ANT_HOME
			if($this->ANT_HOME) {
				putenv("ANT_HOME=" . $this->ANT_HOME);
			} else {
				print "ANT_HOME not set.  Please make sure ANT_HOME is set in the $this->conf file.\n";
				exit(1);
			}

			//ANT_OPTS
			if($this->ANT_OPTS) {
				putenv("ANT_OPTS=" . $this->ANT_OPTS);
			} else {
				print "ANT_OPTS not set.  Please make sure ANT_OPTS is set in the $this->conf file.\n";
				exit(1);
			}

			// Print out environment is debug is set.
			if($this->debug) {
				phpinfo(INFO_ENVIRONMENT);
			}


		}
		
		public function getSource() {
		
			// In here we need to get the tools branch from the appropriate repos, and 
			// then get the product branch from it's repos.  These come from the conf
			// file and are part of the build oject.
			
			// Location of git binary.
			$git = "/usr/bin/git";
			
			// Get tools into the current workspace.
			//system("$git --version", $status);
			system("$git clone --local -b $branch --single-branch ${HUDSON_HOME}/canonical/tools", $status);
			system("$git clone --local -b $this->BRANCH --single-branch $this->TOOLS_DIR", $status);
			
			if($status == 0) {
				print "Sucess!\n";
			} else {
				print "Failure!\n";
			}
			
			// Get the product source into the workspace.
			

// WORK IN PROGRESS   --   taken from Greg's original scripts.

//	#If no argument was passed to the function, use the master branch.  Otherwise use the argument as the branch
//	if [[ -z "$1"   ]];
//	then 
//		branch="master"
//	else
//		branch=$1
//	fi
//	echo "Cloning $branch branch of tools repo"
//	
//	#The tools repo should not be there already, but try to remove it--just in case
  //  	rm -r tools || true
//	
//	#Do a single-branch, shallow clone of the tools repo from ${HUDSON_HOME}/canonical/
//	#If anything goes wrong, stop the build.
//	if !  git clone --local -b $branch --single-branch   ${HUDSON_HOME}/canonical/tools
//	then
//		echo >&2 Cloning git@github.com:hphelion/tools.git failed.  Stopping the build.
//		exit 1
//	fi
//	
//	cd tools
//	git checkout $branch
//	git branch
//	cd ..
//	
//	
//	#Make sure that the scripts in the jenkins folder are executable
//	chmod 755 ./tools/jenkins/*.sh






			
		}
		
		public function runBuild() {
		
			print "You are here in runBuild\n";			

			//print "getenv is: " . getenv("JAVA") . "\n";

		}	
		
		public function postActions() {
		
			print "You are here in postAction\n";			

		
		}
		
		public function pushToStaging() {
		
			print "You are here in postAction\n";			

		
		}
		
	}


	
?>
