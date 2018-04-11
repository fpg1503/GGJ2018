const mongoose = require('mongoose')

const Schema = mongoose.Schema

const LevelSchema = new Schema({
    parentId: Schema.ObjectId,
    level: { type: Number, required: true },
    name: { type: String, required: true },
    map: { type: [{x: Number, y: Number, type: {type: String}, _id: false}], required: true },
    lastEditedBy: { type: String, required: true },
    creatorName: { type: String, required: true },
    lastEditedAt: { type: String, required: true },
    attempts: { type: [{ userId: String, successful: Boolean, _id: false}], required: true},
    completed: { type: Boolean, required: true, default: false},
    numberOfAttempts: { type: Number, required: true, default: 0}
})

LevelSchema.index({ level: 1, lastEditedBy: 1, lastEditedAt: -1}, { unique: false, partialFilterExpression: { completed: false, 'map.0': {$exists: true} }, name: 'Random' })
LevelSchema.index({ level: 1, numberOfAttempts: -1, creatorName: 1}, { name: 'Ranking' })

const model = mongoose.model('Level', LevelSchema)
module.exports = model