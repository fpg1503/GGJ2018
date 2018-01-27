const mongoose = require('mongoose')

const Schema = mongoose.Schema

const LevelSchema = new Schema({
    parentId: Schema.ObjectId,
    level: { type: Number, required: true },
    name: { type: String, required: true },
    map: { type: [{x: Number, y: Number, type: {type: String}, _id: false}], required: true },
    lastEditedBy: { type: String, required: true },
    lastEditedAt: { type: String, required: true }
})

const model = mongoose.model('Level', LevelSchema)
module.exports = model