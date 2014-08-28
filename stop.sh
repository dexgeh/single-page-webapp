if [[ -f server.pid ]] ; then
  echo Stopping server... PID $(cat server.pid)
  kill -s INT $(cat server.pid)
  echo Server stopped.
  rm -f server.pid
fi
