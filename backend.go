package backend
 
import (
  "fmt"
  "time"
  "net/http"
 
  "appengine"
  "appengine/runtime"
)
 
func init() {
  http.HandleFunc("/_ah/start", start)
  http.HandleFunc("/_ah/stop", stop)
}
 
func start(writer http.ResponseWriter, req *http.Request) {
  fmt.Fprintln(writer, "OK")
  ctx := appengine.NewContext(req)
  ctx.Infof("Starting ..")
  error := runtime.RunInBackground(ctx, loop)
  ctx.Errorf("Background loop exited: %s", error)
}
 
func loop(ctx appengine.Context) {
  for {
    ctx.Infof("The loop goes around")
    time.Sleep(10 * time.Second)
  }
}
 
func stop(writer http.ResponseWriter, req *http.Request) {
  fmt.Fprintln(writer, "OK")
  ctx := appengine.NewContext(req)
  ctx.Infof("Stopping ..")
}
