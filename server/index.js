const express = require('express')
const bodyParser = require('body-parser')
const port = process.env.port || 3000
const mongooseUri = process.env.mongoose || 'mongodb://localhost/test'
const mongoose = require('mongoose')
const app = express()

const Level = require('./Model/Level')

let map = [
  {x: 6, y: 4, type: 'Player'},
  {x: 0, y: 4, type: 'Box'},
  {x: 6, y: 1, type: 'Box'},
  {x: 7, y: 6, type: 'Box'},
  {x: 9, y: 4, type: 'Box'}
]

mongoose.connect(mongooseUri)

app.use(bodyParser.json())

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
  Level.findOne(
    { level: { $eq: req.params.id }},
    { __v: false },
    {sort: { 'lastEditedAt': -1 }})
  .then(result => {
    res.json(result)  
  })
  .catch(error => console.error(error))
})

app.post('/levels/:id', (req, res) => {
  console.log(req.body)
  const level = new Level({
    name: 'First',
    level: req.params.id,
    map: req.body.map,
    parentId: req.body.parentId,
    lastEditedBy: req.body.userName,
    lastEditedAt: new Date()
  })
  level.save()
  .then(console.log)
  .catch(console.error)
  res.statusCode = 201
  res.send()
})

app.listen(port, () => console.log(`Listening on port ${port}!`))