express = require "express"
fs = require "fs"
{ compose, map, delay } = require "functors"
app = express()
pubdir = "public"
app.get "/files/*", (req, res) ->
  do (path=req.params[0], dir="./#{pubdir}/#{req.params[0]}") ->
    compose(
      fs.readdir
      map.obj compose(
        delay (f) -> "#{dir}/#{f}"
        fs.lstat
      )
    ) dir, (err, files) ->
      if err?
        console.warn err
        return res.status(404).end "Not found"
      res.render "files.pug", {path, files} 
app.use express.static pubdir
app.listen 8888
