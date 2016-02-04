function countdown(){
  if [ "$1" -gt 0 ]
    then date1=$((`date +%s` + $1));
    else date1=$((`date +%s` + 10));
  fi
   while [ "$date1" -ne `date +%s` ]; do 
     echo -ne "$(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r";
   done
}
function stopwatch(){
  date1=`date +%s`; 
   while true; do 
    echo -ne "$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r"; 
   done
}
