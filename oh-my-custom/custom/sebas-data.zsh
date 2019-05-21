#Funciones para el autocompletar de "data" (command-line-data)

function _completedata {
  reply=($(data autocomplete))
}

compctl -K _completedata data
