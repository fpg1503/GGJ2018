const http = require('http')
const port = process.env.port || 80

const server = http.createServer((req, res) => {
  res.writeHead(200, {'Content-Type': 'text/plain'})
  res.end('Hello World\n')
})

server.listen(port)
console.log(`Server running at http://localhost:${port}/`)