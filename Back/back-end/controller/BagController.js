const Bag = require('../models/Bag.js')

const getAllInBag = async (req, res) => {
    try {
        const bag = await Bag.find({});
        res.status(200).json({ bag });
    } catch (err) {
        res.status(500).json({ msg: err });
    }
}

const addOneInBag = async (req,res) => {
    try{
        const bag = await Bag.create(req.body)
        res.status(201).json({ bag })
    }catch (err){
        res.status(500).json({msg: err})
    }
}

const deleteOneFromBag = async (req,res) => {
    try{
        const {id : bagID} = req.params;
        const bag = await Bag.findOneAndDelete({_id: bagID})
        res.status(203).json({bag})
    }catch(err){
        res.status(500).json({msg: err})
    }
}
const deleteAllProducts = async (req, res) => {
    try{
        const deletedProducts = await Bag.deleteMany({})
        res.status(203).json({ deletedProducts })
    }catch(err)
    {
        res.status(500).json({msg: err})
    }

}
module.exports = { 
getAllInBag,
addOneInBag,
deleteAllProducts,
deleteOneFromBag,
}
