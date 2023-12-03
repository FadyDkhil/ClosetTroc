const mongoose = require('mongoose');

const UsersSchema = new mongoose.Schema({
    name:{
        type: String,
        required:[true, 'Must provide a name!'],
        trim: true
    },
    username:{
        type: String,
    },
    password:{
        type: String
    },
    email:{
        type: String
    },
    birth:{
        type: String
    },
    phone:{
        type: String
    },
})

module.exports = mongoose.model('User', UsersSchema)