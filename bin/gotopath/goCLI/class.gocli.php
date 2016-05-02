<?php

/**
 * goCLI v1.0 -  Easily receive parameters in command line mode.
 * Copyright (C) 2009  Sebastián Grignoli <grignoli@gmail.com>
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 **/

class goCLI
{
	/** 
	 *    This class enables you to invoke your script like this:
	 *     $command --help    
	 *     $command -p=value -asxf --param2=value2 "look for this" ./directoryname/*
	 */
	 
	private $want_help = FALSE; // Whether or not the user asked for help
	
	private $params_array = NULL; // Will contain the parsed parameter in an array
	
	private $errors = array();
	
	private $short_escape = "-";
	
	private $long_escape = "--";
	
	private $key_val_separator = "=";
	
	public $param_data;
	
	public function __construct($params, $_argc = NULL, $_argv = NULL)
	{
		global $argc, $argv;
		if(!isset($_argc)) $_argc = isset($argc)?$argc : die("Couldn't access argc and argv.  Check your PHP configuration.");
		if(!isset($_argv)) $_argv = $argv;

		$this->argc = $_argc;		
		$this->argv = $_argv;
		
		$this->initializeParameters($params);
	}
	
	public function go()
	{
		$params_array = $this->parseParameters();
		if($this->wantHelp()) {die($this->help());}
		if($this->errors()) {$this->showErrors(); die();}
		return $params_array;
	}

	public function parseParameters()
	{
		foreach($this->argv as $index => $param)
		{
			if(substr($param,0,strlen($this->long_escape)) == $this->long_escape)
			{
				$this->longReceived($param);
			} 
			elseif(substr($param,0,strlen($this->short_escape)) == $this->short_escape)
			{
				$this->shortReceived($param);			
			}
			else
			{
				//no es un parametro con nombre
				$param_name = $this->nextUnnamedParam($param);
				if(!($param_name === false)) $param_val = $param;
				$this->registerValue($param_name, $param_val);
			}
		}
		//print_r($this->param_data);
		$this->checkRequired();
		$this->normalizeResponse();
		
		return $this->params_array;
	}
	
	public function showErrors()
	{
		if(count($this->errors))
		{
			foreach($this->errors as $error)
			{
				echo $error . "\n";
			}
			echo "\n".$this->usage();
			echo $this->tryHelp();
		}
	}
	
	public function errors()
	{
		return count($this->errors)?1:0; //TODO: true if errors happened
	}

	private function longReceived($param)
	{
		$param = substr($param, strlen($this->long_escape));
		
		$param_name = $this->findParamByLong($this->str_ibefore($param, $this->key_val_separator));
		if(!($param_name === false)){
			$param_val = $this->str_iafter($param, $this->key_val_separator);
			$param_val = $param_val == $param? true : $param_val;
			$this->registerValue($param_name, $param_val);
		} else {
			$this->errors[] = $this->params_array['_script_name'] . " option not known: ". $this->long_escape . $this->str_ibefore($param, $this->key_val_separator);
		}
	}
	
	public function help()
	{
		$o = $this->usage();
		
		foreach($this->param_data['unnamed'] as $param) 
		{
			$o .= '  ' . strtoupper($param) . "\t\t" . (empty($this->param_data['info'][$param])?"":$this->param_data['info'][$param]) . "\n";
		}
		
		$o .= "Options:\n";
		foreach($this->param_data['shortnames'] as $shortname => $param)
		{
			$argname = $this->getArgumentName($param);
			$arg = empty($argname)?'': $this->key_val_separator.'<'.$argname.'>';	
			
			$o .= "  ".$this->short_escape.$shortname.$arg;
			if($longname = array_search($param ,$this->param_data['longnames']))
			{
				$o .= "  ".$this->long_escape.$longname.$arg;
			}
			
			if(!empty($this->param_data['info'][$param]))
			{
				$o .= "\t\t".$this->param_data['info'][$param];
			}
			$o .= "\n";
		}
		
		return $o;
	}
	
	public function usage()
	{
		$usage = "Usage: ".$this->params_array['_script_name'] . " " .
		(count($this->param_data['shortnames'])+count($this->param_data['longnames'])?"[OPTION] ": "") ;
		foreach($this->param_data['unnamed'] as $param) 
		{
			$usage .= (in_array($param, $this->param_data['required'])?strtoupper($param):"[".strtoupper($param)."]")." ";
		}
		$usage .= "\n";
		return $usage;
	}
		
	public function tryHelp()
	{
		if(!empty($this->param_data['help'])) 
			{
				return "Try '".$this->params_array['_script_name']." ".
				$this->param_data['helplabel']. 
				"' for more information.\n";
			};
	}
	
	
	
  /** *****************
   * Private functions
   ****************** */	
	
	private function shortReceived($param)
	{
		$param = substr($param, strlen($this->short_escape));
		$sep_pos = strpos($param, $this->key_val_separator); //position of the separatos within the parameters string
		$last_short = empty($sep_pos)?strlen($param):$sep_pos; //find out where to stop looking (find minimum but not zero)
		// ie:  $command -xjf  (x=1,j=1,f=1)     or      $command -xjf=value  (x=1,j=1,f=value)

		for($i = 0;$i < $last_short; $i++)
		{
			$param_name = $this->findParamByShort($param{$i});
			if(!($param_name === false)){
				if(strpos(substr($param, $i+1), $this->key_val_separator) === 0) 
				{
					$param_val = substr($param, $i+1+strlen($this->key_val_separator));
				}
				$param_val = !isset($param_val)? true : $param_val;
			
				$this->registerValue($param_name, $param_val);
				unset($param_val);
			} else {
				$this->errors[] = $this->params_array['_script_name'] . " invalid option: ". $this->short_escape . $this->str_ibefore($param{$i}, $this->key_val_separator);
			}
		}		
	}
	
	private function registerValue($param_name, $param_val)
	{
		if(in_array($param_name,$this->param_data['switch'] ) && !($param_val === true)) 
		{
			$this->errors[] = $this->params_array['_script_name'].": option ".
				(in_array($param_name,$this->param_data['longnames'])? $this->long_escape . array_search($param_name,$this->param_data['longnames']) : '').
				(in_array($param_name,$this->param_data['shortnames'])? ' (' . $this->short_escape . array_search($param_name,$this->param_data['shortnames']) .')' : '').
				" doesn't take an argument.";
		}

		if(!in_array($param_name,$this->param_data['switch']) && in_array($param_name,$this->param_data['required'] ) && is_bool($param_val)) 
		{
			$this->errors[] = $this->params_array['_script_name'].": option ".
				(in_array($param_name,$this->param_data['longnames'])? $this->long_escape . array_search($param_name,$this->param_data['longnames']).'=<'.$this->getArgumentName($param_name).'>' : '').
				(in_array($param_name,$this->param_data['shortnames'])? ' (' . $this->short_escape . array_search($param_name,$this->param_data['shortnames']) .'=<'.$this->getArgumentName($param_name).'>)' : '').
				" missing an argument.";
		}		
		
				
		if(in_array($param_name, $this->param_data['multiple'])) 
		{
			$this->params_array[$param_name][] = $param_val;
		}
		else
		{
			// duplicate?
			if(!isset($this->params_array[$param_name]))
			{
				$this->params_array[$param_name] = $param_val;
			} 
			else
			{
				$this->errors[] = $this->params_array['_script_name'].": option ".
				(in_array($param_name,$this->param_data['longnames'])? $this->long_escape . array_search($param_name,$this->param_data['longnames']) : '').
				(in_array($param_name,$this->param_data['shortnames'])? ' (' . $this->short_escape . array_search($param_name,$this->param_data['shortnames']) .')' : '').
				' cannot receive multiple values';
			}
			
		}
		return $param_val;	
	}
	
	private function nextUnnamedParam($val)
	{
		if(count($this->param_data['unnamed-tmp']) < 1) 
		{
			$this->errors[] = $this->params_array['_script_name'].': unexpected parameter: "'.$val.'"';
			return false;
		} else
		{
			$param_name = array_shift($this->param_data['unnamed-tmp']);
			return $param_name;
		}		
	}
	
	private function checkRequired()
	{
		foreach($this->param_data['required'] as $param)
		{
			if(!isset($this->params_array[$param]) || $this->params_array[$param] === false) 
			{
				$this->errors[] = $this->params_array['_script_name'].": ".
				
				((!in_array($param,$this->param_data['longnames'])&&!in_array($param,$this->param_data['shortnames']))
				?
				"missing parameter: " . strtoupper($param)	
				:

					"option ".
					(in_array($param,$this->param_data['longnames'])? $this->long_escape . array_search($param,$this->param_data['longnames']) : '').
					(in_array($param,$this->param_data['shortnames'])? ' (' . $this->short_escape . array_search($param,$this->param_data['shortnames']) .')' : '')." is required"	
				);
			}
		}
	}
	
	private function normalizeResponse()
	{
		foreach($this->param_data['switch'] as $switch)
		{
			if(empty($this->params_array[$switch])) $this->params_array[$switch] = false;
		};
				
		foreach($this->param_data['unnamed'] as $unnamed)
		{
			if(empty($this->params_array[$unnamed])) $this->params_array[$unnamed] = false;
		};
	}
	
	private function initializeParameters($params)
	{
		$this->param_data['shortnames'] = array();
		$this->param_data['longnames'] = array();
		$this->param_data['info'] = array();
		$this->param_data['required'] = array();
		$this->param_data['switch'] = array();
		$this->param_data['multiple'] = array();
		$this->param_data['argument'] = array();
		$this->param_data['default'] = array();
		$this->param_data['unnamed'] = array('_script_name');
		$this->param_data['help'] = "";
				
		foreach($params as $name => $data){
			if(!empty($data['short']))		$this->param_data['shortnames'][$data['short']] = $name;
			if(!empty($data['long']))		$this->param_data['longnames'][$data['long']] = $name;
			if(!empty($data['info']))		$this->param_data['info'][$name] = $data['info'];
			if(!empty($data['argument']))	$this->param_data['argument'][$name] = $data['argument'];
			if(!empty($data['default']))	$this->param_data['default'][$name] = $data['default'];
			if(!empty($data['required']))	$this->param_data['required'][] = $name;
			if(!empty($data['switch']))		$this->param_data['switch'][] = $name;
			if(!empty($data['multi']))		$this->param_data['multiple'][] = $name;
			if(!empty($data['help']))		$this->param_data['help'] = $name;
			if(!empty($data['help']))		$this->param_data['helplabel'] = (empty($data['long'])?$this->short_escape.$data['short']:$this->long_escape.$data['long']);

			
			if(empty($data['short']) && empty($data['long'])) $this->param_data['unnamed'][] = $name;
		}
		
		$this->param_data['unnamed-tmp'] = $this->param_data['unnamed']; 
		array_shift($this->param_data['unnamed']);
	}
	
	private function findParamByLong($identifier)
	{
		$param_name = empty($this->param_data['longnames'][$identifier])? false : $this->param_data['longnames'][$identifier];
		return $param_name;
	}
	
	private function findParamByShort($identifier)
	{
		$param_name = empty($this->param_data['shortnames'][$identifier])? false : $this->param_data['shortnames'][$identifier];
		return $param_name;
	}
	
	private function wantHelp()
	{
		if(empty($this->param_data['help'])) return false;
		return empty($this->params_array[$this->param_data['help']])? false : true;
	}
	
	private function getArgumentName($param)
	{
		return (!in_array($param,$this->param_data['switch'])?(!empty($this->param_data['argument'][$param])?$this->param_data['argument'][$param]:'arg'):'');
	}
	
	
	//  ************************************************************
	
	// auxiliar functions that are for internal use
	private function str_ibefore($haystack, $limit) 
	{
		// returns string from the begining of haystack to the limit (not including it) or end
		return ($_pos = strpos(strtoupper($haystack),strtoupper($limit)))===false?
		        $haystack:substr($haystack,0,$_pos);
	}
	
	private function str_iafter($haystack, $limit)
	{
		// returns string from the limit (not including it) to the end of haystack
		return strlen($str = stristr($haystack, $limit)) == 0? 
		        $haystack:substr($str,strlen($limit));
	}

  
}