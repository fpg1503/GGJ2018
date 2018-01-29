console.log(JSON.stringify(process.env))

const express = require('express')
const bodyParser = require('body-parser')
const port = process.env.port || 3000
const mongooseUri = process.env.mongooseUri || 'mongodb://localhost/test'
const mongoose = require('mongoose')
const app = express()

const Level = require('./Model/Level')

mongoose.connect(mongooseUri)

app.use(bodyParser.json())

app.get('/', (req, res) => {
  res.json({levels: 1})
})

app.get('/levels', (req, res) => {
  res.json([
    { level: 1, name: 'First' },
  ])
})

app.get('/levels/:id', (req, res) => {
  Level.findOne(
    { level: { $eq: req.params.id }, lastEditedBy: { $ne: req.query.userName }},
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