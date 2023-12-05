const mongoose = require('mongoose');

const BagSchema = new mongoose.Schema({
    name:{
        type: String,
        required:[true, 'Must provide an event name!'],
        trim: true
    },
    type:{
        type: String,
    },
    description:{
        type: String
    },
    price:{
        type: String
    },
    quantity:{
        type: String
    },
    size:{
        type: String
    },
    addedDate:{
        type: String
    },
    userID:{
        type: String
    },
})

module.exports = mongoose.model('Bag', BagSchema)