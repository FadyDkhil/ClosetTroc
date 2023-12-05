const express = require('express');
const app = express();
const connectDB = require('./db/connect.js')
const cors = require('cors');
require('dotenv').config()


//routes require
const products = require('./routes/ProductsRoutes.js')
const users = require('./routes/UsersRoutes.js')
const bag = require('./routes/BagRoutes.js')

//middleware
app.use(cors())
app.use(express.static('./public'))
app.use(express.json())

//using routes
app.use('/closettroc/products', products)
app.use('/closettroc/users', users)
app.use('/closettroc/bag', bag)

const port = 3000

const start = async () => {
    try{
        await connectDB(process.env.MONGO_URI)
        app.listen(port, console.log(`Server listening on port ${port}...`))
    }catch (error){
        console.log(error)
    }
}

start()

