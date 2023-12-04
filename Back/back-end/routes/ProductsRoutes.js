const express = require('express');
//const { model } = require('mongoose');
const { getAllProducts, addOneProduct, editOneProduct, deleteOneProduct, deleteAllProducts } = require('../controller/ProductsController.js')
const router = express.Router();

router.route('/')
.get(getAllProducts)
.post(addOneProduct)
.delete(deleteAllProducts)

router.route('/:id')
.patch(editOneProduct)
.delete(deleteOneProduct)

module.exports = router