<?php

/**
 * go  - Jump to a directory, anywhere in the disc
 * @author 
 * @copyright 2009
 */
  
  
/**
 * Linux:  add to .bashrc
 *
 
 function go()
 {
  /bin/go $*
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
			'help'		=> FALSE   //(we don't want goCLI to show the help page automatically)
		),

	'list' =>
		array(
			'short'		=> 'l',
			'long'		=> 'list',
			'info'		=> 'List exiting aliases',
			'switch'	=> TRUE,
		),
				
	'plain' =>
		array(
			'short'		=> 'p',
			'long'		=> 'plain-list',
			'info'		=> 'List exiting aliases in a clean list (good for use on autocomplete)',
			'switch'	=> TRUE,
		),
				
	'add' =>
		array(	
			'short'		=> 'a',
			'long'		=> 'add',
			'info'		=> 'Add an alias to specified or current directory',
			'switch'	=> TRUE,
		),
		
	'remove' =>
		array(	
			'short'		=> 'r',
			'long'		=> 'remove',
			'info'		=> 'Remove an alias by name',
			'switch'	=> TRUE,
		),
		
	'alias' =>
		array(	
			'short'		=> '',
			'long'		=> '',
			'info'		=> 'Alias (when calling the program without any argument it tries to jump to the alias named "default")',
		),

	'directory' =>
		array(
			'info'		=> 'Directory to apply the alias to. (Default: current)',
		),

);

$cCLI = new goCLI($expected_params); 
$param = $cCLI->go();

goDirAlias::clear();

if($param['help'])
{
	echo $cCLI->help();
}

elseif($param['list']) return goDirAlias::alias_list();

elseif($param['plain']) return goDirAlias::alias_list_plain();

elseif($param['add']) 
{
	if($param['alias']) 
	{
		return goDirAlias::add($param['alias'],(empty($param['directory'])?"":$param['directory']));
	} 
	else
	{
		echo "Please specify the alias name.\n";
	}
}

elseif($param['remove']) 
{
	if($param['alias']) 
	{
		return goDirAlias::remove($param['alias']);
	} 
	else
	{
		echo "Please specify the alias name.\n";
	}
	
}

elseif($param['alias'])
{
	goDirAlias::go($param['alias']);
}

else
{
	goDirAlias::go('default');
}

class goDirAlias
{
	public function go($alias = NULL)
	{
		$a = goDirAlias::get_alias_array();
		if(isset($a[$alias]))
		{
			//echo "Jumping to ".$a[$alias]."\n";
			//chdir($a[$alias]);
			//exec("cd \"".$a[$alias]."\"");
			//echo "Now on ". getcwd();
			$drive = substr($a[$alias],1,1) == ":"?"@".substr($a[$alias],0,2)."\n":"";
			
			file_put_contents(goDirAlias::home_dir().".gotopath.bat",$drive."@cd ".$a[$alias]."\n");
			chmod(goDirAlias::home_dir().".gotopath.bat",0700);
			file_put_contents(goDirAlias::home_dir().".gotopath","".$a[$alias]);
			chmod(goDirAlias::home_dir().".gotopath",0700);
		} 
		else
		{
			echo "Alias \"$alias\" not found\n";
		}
	}
	public function clear()
	{
			file_put_contents(self::home_dir().".gotopath.bat","");
			chmod(self::home_dir().".gotopath.bat",0700);
			file_put_contents(self::home_dir().".gotopath","");
			chmod(self::home_dir().".gotopath",0700);
	}
	
	public function alias_file(){
		return goDirAlias::home_dir().".gotab";
	}
	
	public function add($alias, $dir = NULL)
	{
		$a = goDirAlias::get_alias_array();
		if(isset($a[$alias]))
		{
			$o = "Alias replaced\n";;
		}
		else
		{
			$o = "Alias added\n";
		}
		$a[$alias] = empty($dir)? getcwd() : $dir ;
		file_put_contents(goDirAlias::alias_file(),serialize($a));
		echo($o);
	}
	
	public function remove($alias)
	{
		$a = goDirAlias::get_alias_array();
		if(isset($a[$alias])) 
		{
			unset($a[$alias]);
			file_put_contents(goDirAlias::alias_file(),serialize($a));
			echo("Alias removed\n");
		} 
		else 
		{
			echo("Alias not found\n");
		}
	}
	
	public function alias_list_plain()
	{
		$a = goDirAlias::get_alias_array();
		foreach($a as $k => $v)
		{
			echo($k ."\n");
		}
		
	}
	
	public function alias_list()
	{
		echo("Aliases listing:\n");
		$a = goDirAlias::get_alias_array();
		foreach($a as $k => $v)
		{
			echo($k . "\t\t" . $v ."\n");
		}
		
	}
	
	private function get_alias_array()
	{
		try
		{
			$a = array();
			if(file_exists(goDirAlias::alias_file()))
			{
				$a = file_get_contents(goDirAlias::alias_file());
				if(!empty($a))
				{
					$a = unserialize($a);
				}
			}
			return is_array($a)?$a:array();
		}
		catch(exception $e)
		{
			return array();
		}
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

}
