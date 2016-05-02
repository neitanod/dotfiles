<?php

/**
 * go  - Jump to a directory, anywhere in the disc
 * @author 
 * @copyright 2009
 */
  
  
/**
 * Linux:  add to .bashrc
 *
 
 function gd()
 {
  /bin/gd $*
  RESULT=`cat $HOME/.gotopath`
  $RESULT
 }
 
 */
  
require_once( dirname(__FILE__).'/goCLI/class.gocli.php');

$expected_params = array(

	'help' =>
		array(	
			'short'		=> 'h',
			'long'		=> 'help',
			'info'		=> 'Show this help page.',
			'required'	=> FALSE,
			'switch'	=> TRUE,
			'multi'		=> FALSE,
			'help'		=> TRUE   //(we want goCLI to show the help page automatically)
		),

	'build' =>
		array(
			'short'		=> 'b',
			'long'		=> 'build',
			'info'		=> 'Rebuild database',
			'switch'	=> TRUE,
		),

	'directory' =>
		array(
			'info'     => 'Directory to jump to. (Default: current)',
			'required' => FALSE,
		),

);

$cCLI = new goCLI($expected_params); 
$param = $cCLI->go();

goDirSeek::clear();

if($param['help']) { echo $cCLI->help(); }
elseif($param['build']) { return goDirSeek::build(); }
elseif(strlen($param['directory'])) {
  try{
    return goDirSeek::jumpTo($param['directory']);
  } catch(Exception $e) {
    echo $e->getMessage();
  }
}


class goDirSeek
{

  private function ignore(){
    return array(
                          ".",
                          "..",
                          ".svn",
                          ".cvs"
      );
  }

	public function build()
	{
    echo "Building DB...\n";
    //exec('cmd.exe /C dir \ /b /s /ad > "'.self::db_file().'"');
    $cwd = getcwd();
    $drive = strpos($cwd,':') == 1 ? substr($cwd, 0, 3): "";
    self::listdir($drive);
    self::clear();
	}
  
  private function listdir($path, $db_file = null)
  {

    if(is_null($db_file)) $db_file = fopen(self::db_file(),"w+");
    $path = self::add_trailing_slash($path);
    $d = @dir($path);
    while (!empty($d) && false !== ($entry = $d->read())) {
      if(@filetype($path.$entry) == "dir" && !in_array($entry, self::ignore()) ){
        fputs($db_file, $path.$entry."\n");
        self::listdir($path.$entry, $db_file);
      }
    }
    if(is_object($d)) $d->close();
  }

	public function jumpTo($dir)
	{
    if(!file_exists(self::db_file())) throw new Exception("DB file not found.  Build DB first.  Use:  gd -b");
    $db = fopen(self::db_file(),"r");
    
    $d = self::seekFor($db, getcwd()); //avanzamos en la db hasta el dir actual

    $d = self::nextMatch($db, $dir); //buscamos el siguiente match

    //si no hay ninguno y $partialsearch == true => buscamos desde el principio
    if($d === false){
      rewind($db);
      $d = self::nextMatch($db, $dir);
      if($d == getcwd() || $d === false) {
        return 0;
      }
    }
    // si encontramos algo, hacemos el CD
    file_put_contents(goDirSeek::home_dir().".gotopath.bat","@cd \"".$d."\"\n");
    chmod(goDirSeek::home_dir().".gotopath.bat",0700);
    file_put_contents(goDirSeek::home_dir().".gotopath","cd ".$d);
    chmod(goDirSeek::home_dir().".gotopath",0700);

	}

	public function seekFor($db, $dir)
	{
    $d = "";
    $dir = trim($dir);
    //echo(">".$dir."<");
    while( $d != $dir && !feof($db) ){
      $d = trim(fgets($db));      
    }

    return $d;
	}

	public function nextMatch($db, $dir)
	{
    $dir = strtolower($dir);
    $d = "";
    $len = strlen($dir);
    while( !feof($db) ){
      $d = trim(fgets($db));
      $dn = substr($d, strrpos($d, DIRECTORY_SEPARATOR)+1);
      if($dir == strtolower(substr($dn,0,$len))){
        return $d;
      }
    }
    return false;
	}

	public function db_file(){
		return self::home_dir().".gd_db";
		//return "/.gd_db";
	}

	public function clear()
	{
			file_put_contents(self::home_dir().".gotopath.bat","");
			chmod(self::home_dir().".gotopath.bat",0700);
			file_put_contents(self::home_dir().".gotopath","");
			chmod(self::home_dir().".gotopath",0700);
	}
	
	private function whoami()
	{
		// Try to find out the username of the user running the script
		if(function_exists('posix_getpwuid'))
		{
			// using posix
			$running_user = posix_getpwuid(posix_geteuid());
			$running_user = $running_user['name'];
		} else {
			// Looking for Windows environment variables
			$running_user = getenv('USERNAME');
			if(empty($running_user))
			{
				// Running *nix whoami
				$running_user = exec('whoami');
			}
		}

	return $running_user;
	
	}
	
	
	private function home_dir()
	{
		// Try to find out the home directory of the user running the script
		if(function_exists("posix_getpwnam"))
		{
			// using posix
			$user_info = posix_getpwnam(self::whoami());
			$home_dir = $user_info['dir']."/";
			//print_r($user_info);
		} else 
		{
			// Looking for Windows environment variables
			$home_dir = getenv('HOMEDRIVE').getenv('HOMEPATH').'\\';
			if($home_dir == "\\")
			{
				// Looking for *nix environment variables
				$home_dir = getenv('HOME')."/";
			}
		}
	
	return $home_dir;
	
	}


  private function add_trailing_slash($string){
    if(empty($string)) return DIRECTORY_SEPARATOR;
    if(substr($string, -1) != DIRECTORY_SEPARATOR) return $string . DIRECTORY_SEPARATOR;
    return $string;
  }

}
