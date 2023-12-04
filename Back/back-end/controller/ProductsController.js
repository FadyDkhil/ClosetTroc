const Products = require('../models/Products.js')

const getAllProducts = async (req, res) => {
    try {
        let filter = {};
        if (req.query.location) {
            filter = { location: req.query.location };
        } else if (req.query.name) {
            filter = { name: { $regex: new RegExp(req.query.name, 'i') } };
        }
        const products = await Products.find(filter);
        res.status(200).json({ products });
    } catch (err) {
        res.status(500).json({ msg: err });
    }
}
// }
const addOneProduct = async (req,res) => {
    try{
        const product = await Products.create(req.body)
        res.status(201).json({ product })
    }catch (err){
        res.status(500).json({msg: err})
    }
}


const editOneProduct = async (req,res) => {
    try{
        const {id:productID} = req.params
        const updatedProduct = await Event.findOneAndUpdate({_id: productID}, req.body,{ new: true, runValidators: true})
        if(!updatedProduct){
            return res.status(404).json({msg: 'no Product with the ID: ${productID}'})
        }
        res.status(202).json({updatedProduct})
    }catch(err){
        res.status(500).json({msg: err})
    }
}
const deleteOneProduct = async (req,res) => {
    try{
        const {id : productID} = req.params;
        const product = await Products.findOneAndDelete({_id: productID})
        res.status(203).json({product})
    }catch(err){
        res.status(500).json({msg: err})
    }
}
const deleteAllProducts = async (req, res) => {
    try{
        const deletedProducts = await Products.deleteMany({})
        res.status(203).json({ deletedProducts })
    }catch(err)
    {
        res.status(500).json({msg: err})
    }

}
module.exports = { 
getAllProducts,
addOneProduct,
editOneProduct,
deleteAllProducts,
deleteOneProduct,
}
