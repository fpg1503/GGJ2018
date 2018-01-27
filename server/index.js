const express = require('express')
const port = process.env.port || 3000
const mongooseUri = process.env.mongoose || 'mongodb://localhost/test'
const mongoose = require('mongoose')
const app = express()

mongoose.connect(mongooseUri)

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
    name: 'First',
    map: [
      {x: 6, y: 4, type: 'Player'},
      {x: 0, y: 4, type: 'Box'},
      {x: 6, y: 1, type: 'Box'},
      {x: 7, y: 6, type: 'Box'},
      {x: 9, y: 4, type: 'Box'}
    ]
  })
})

app.post('/levels/:id', (req, res) => {
  //TODO!
  res.statusCode = 201
  res.send()
})

app.listen(port, () => console.log(`Listening on port ${port}!`))