<?php

/**
 * @author 
 * @copyright 2009
 */

require_once("class.gocli.php");

$expected_params = array(
	
	'help' =>
		array(	
			'short'		=> 'h',
			'long'		=> 'help',
			'info'		=> 'Show this help page.',
			'required'	=> FALSE,
			'switch'	=> TRUE,
			'multi'		=> TRUE,
			'help'		=> TRUE
		),
	
	'test' =>
		array(	
			'short'		=> 'a',
			'long'		=> 'all',
			'info'		=> 'This option is internally called "test" (dummy)',
			'required'	=> TRUE,
			'switch'	=> FALSE,
			'multi'		=> TRUE
		),
	
	'file' =>
		array(	
			'short'		=> 'f',
			'long'		=> 'file',
			'info'		=> 'File to process (dummy)',
			'argument'  => 'file',
			'required'	=> TRUE,
			'switch'	=> FALSE,
			'multi'		=> FALSE
		),
	
	'input' =>
		array(	
			'short'		=> '',
			'long'		=> '',
			'info'		=> 'Input file (dummy)',
			'argument'  => 'file',
			'required'	=> TRUE,
			'switch'	=> FALSE,
			'multi'		=> FALSE
		),
	
	'output' =>
		array(	
			'short'		=> '',
			'long'		=> '',
			'info'		=> 'Output file (dummy)',
			'required'	=> TRUE,
			'switch'	=> FALSE,
			'multi'		=> FALSE
		),
	
	'show_received' =>
		array(	
			'short'		=> 'R',
			'long'		=> 'show-received',
			'info'		=> 'Show received parameters',
			'required'	=> FALSE,
			'switch'	=> TRUE,
			'multi'		=> FALSE
		),
	
	'show_expected' =>
		array(	
			'short'		=> 'X',
			'long'		=> 'show-expected',
			'info'		=> 'Show expected parameters',
			'required'	=> FALSE,
			'switch'	=> TRUE,
			'multi'		=> FALSE
		),
	
	'show_data' =>
		array(	
			'short'		=> 'D',
			'long'		=> 'show-data',
			'info'		=> 'Show interpreted parameter data',
			'required'	=> FALSE,
			'switch'	=> TRUE,
			'multi'		=> FALSE
		)
				
);


$cCLI = new goCLI($expected_params); 
$param = $cCLI->go();

if($param['show_expected']) var_dump($expected_params);
if($param['show_data']) 	var_dump($cCLI->param_data);
if($param['show_received']) var_dump($param);




