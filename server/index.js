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

app.get('/levels/:number/random', (req, res) => {
  Level.findOne(
    { level: { $eq: req.params.number }, lastEditedBy: { $ne: req.query.userName }, completed: { $ne: true }, 'map.0': {$exists: true}},
    { __v: false },
    {sort: { 'lastEditedAt': -1 }})
  .then(result => {
    res.json(result)  
  })
  .catch(error => console.error(error))
})

app.get('/levels/:number/ranking', (req, res) => {
  Level.find( { level: { $eq: req.params.number } }, { creatorName: 1, numberOfAttempts: 1 }).sort({ numberOfAttempts: -1 }).limit(req.query.pageSize || 10)  
  .then(result => {
    const mapped = result.map ( values => {
      return { name: values.creatorName, ranking: values.numberOfAttempts}
    })
    res.json(mapped)  
  })
  .catch(error => console.error(error))
})

app.post('/levels/:number/creation', (req, res) => {
  console.log(req.body)
  const level = new Level({
    name: 'First',
    level: req.params.number,
    map: req.body.map,
    parentId: req.body.parentId,
    lastEditedBy: req.body.userId,
    creatorName: req.body.name,
    lastEditedAt: new Date(),
    attempts: []
  })
  level.save()
  .then(console.log)
  .catch(console.error)
  res.statusCode = 201
  res.send()
})

app.post('/levels/:number/version/:versionId/attempt', (req, res) => {
  const completed = req.body.completed
  Level.findOneAndUpdate({ level: { $eq: req.params.number }, _id: { $eq: req.params.versionId} }, { $inc: { numberOfAttempts: 1 }, $set: { completed }, $push: { attempts: { userId: req.body.user, successful: completed } } })
  .then(result => {
    console.log(result)
    res.statusCode = 201
    res.send()
  })
  .catch(error => {
    console.error(error)
    res.error(error)
  })
})


app.listen(port, () => console.log(`Listening on port ${port}!`))