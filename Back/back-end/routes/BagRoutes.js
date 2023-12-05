const express = require('express');
//const { model } = require('mongoose');
const { getAllInBag, addOneInBag, deleteOneFromBag, deleteAllProducts } = require('../controller/BagController.js')
const router = express.Router();

router.route('/')
.get(getAllInBag)
.post(addOneInBag)
.delete(deleteAllProducts)

router.route('/:id')
.delete(deleteOneFromBag)

module.exports = router