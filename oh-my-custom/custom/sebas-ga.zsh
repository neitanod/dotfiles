#Funciones para el autocompletar de "ga" (goto alias)

function _completega {
  reply=($(ga -p))
}

compctl -K _completega ga
