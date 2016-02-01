<?php 

define('DS', DIRECTORY_SEPARATOR); 
define('ROOT', dirname(__FILE__));
define('ROOT_CONFIG', ROOT . DS . '.config');
define('VIRTUAL_HOST_NAME', prompt("Nombre del Virtual Host", basename(ROOT)));
define('VIRTUAL_HOST_URL', "http://". VIRTUAL_HOST_NAME ."/");

$templates = array(
                   'symfony' => 'symfony',
                   'web/symfony.php' => 'web/symfony.php',
                   'config/databases.yml' => 'config/databases.yml',
                   'config/server/config_local.php' => 'config/server/config_local.php'
);

$replaces = array(
                  'CONF_BUDA_ROOT' => ROOT,
                  'CONF_BUDA_VIRTUAL_HOST_URL' => VIRTUAL_HOST_URL,
                  'CONF_BUDA_VIRTUAL_HOST_NAME' => VIRTUAL_HOST_NAME,
);
function prompt($prompt, $default = '') { 
  while (!isset($input)) { 
    echo $prompt . (empty($default) ? ": " :  " - Si dejas en blanco se usa `$default`: "); 
    $input = strtolower(trim(fgets(STDIN))); 
    if(empty($input) && !empty($default)) { 
      $input = $default; 
    }
  } 
  return $input; 
} 


function root($dir) 
{
  return ROOT . DS . $dir;
}
function rootConfig($dir) 
{
  return ROOT_CONFIG . DS . $dir;
}

function out($l) 
{
  echo $l . "\n";
}
function e($command)
{
  out('Ejecutando ' . $command);
  return out(exec($command));
}
function copyRel($source, $dest)
{
  out("Copiando " . $source  . " a " . $dest);
  return copy(root($source), root($dest));
}

function copyConfig($source, $dest)
{
  out("Copiando configuracion " . rootConfig($source)  . " a " . root($dest));
  return copy(rootConfig($source), root($dest));
}
function _mappedReplaceKeys($k) 
{
  return '%%{{' . $k . '}}%%';
}
function applyReplaces($file, $replaces)
{
  out("Aplicando reemplazos a " . $file);
  $fileContent = file_get_contents($file);
  $fileContent = str_replace(array_map('_mappedReplaceKeys',array_keys($replaces)), array_values($replaces), $fileContent);
  file_put_contents($file, $fileContent);
}

function generateCopiesFromTemplates($templates, $replaces) {
  foreach($templates as $source => $dest) {
    copyConfig($source, $dest);
    applyReplaces(root($dest), $replaces);    
    out("Generada template " . $dest);
  }
}

out("Configurando para " . ROOT);
out("Generando copias desde templates");
generateCopiesFromTemplates($templates, $replaces);
out("Generando VIRTUAL HOST para Apache2:");
$vhFile = VIRTUAL_HOST_NAME . '.conf';
copyConfig('intranet.conf', $vhFile);
applyReplaces(root($vhFile), $replaces);
out("# Ejecutar:");
out('cd config && ./crear_symlinks_en_linux.sh && cd -');
out("sudo cp " . root($vhFile) . " /etc/apache2/sites-available/$vhFile");
out("sudo a2ensite $vhFile");
out("sudo /etc/init.d/apache2 reload");
out('unzip "'.ROOT.'/lib/vendor/symfony-1.4.8-con-parche-(descomprimir-aqui).zip" -d "'. ROOT . '/lib/vendor/" && mv "'.ROOT.'/lib/vendor/symfony-1.4.8" ' . ROOT . '/lib/vendor/sf/');
out("# Como root (sudo -s) ejecutar: ");
out('echo "127.0.0.1 '.VIRTUAL_HOST_NAME.'" >> /etc/hosts');
e('chmod -R ugo+xrw ' . root('cache') . ' ' . root('log') );
e('cp '. rootConfig('web/images/lg_df_page.gif') . ' ' . root('web/images/lg_df_page.gif'));


