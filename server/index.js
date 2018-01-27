const express = require('express')
const port = process.env.port || 3000

const app = express()

app.get('/', (req, res) => {
  res.json({levels: 3})
})

app.get('/levels', (req, res) => {
  res.json([
    { level: 1, name: 'First' },
    { level: 2, map: 'Second' }
  ])
})

app.get('/levels/:id', (req, res) => {
  res.json({
    level: req.params.id,
    name: 'foo',
    map: 'TODO'
  })
})

app.post('/levels/:id', (req, res) => {
  //TODO!
  res.statusCode = 201
  res.send()
})

app.listen(port, () => console.log(`Listening on port ${port}!`))