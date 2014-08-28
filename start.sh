echo Current working directory:
echo $PWD
if [[ ! -f server.pid ]] ; then
  echo Starting server...
  nohup ./node_modules/coffee-script/bin/coffee server/ \
    >> logs/server.log 2>&1 </dev/null & PID=$!
  echo $PID > server.pid
  echo Server started. PID $PID
  sleep 1
  kill -s 0 $PID
  if [[ $? != 0 ]]; then
    rm -f server.pid
    tail -n 50 logs/server.log
  fi
fi
