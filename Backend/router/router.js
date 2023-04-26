const express = require("express");
const mongoose = require('mongoose')
const Model = require('../model/dbModel')
const router = express.Router()

router.post('/add',async function (req,res){
    const {relay1, relay2,relay3,relay4,humidity,temperature} = req.body

    try{
        const data = await Model.create({relay1, relay2,relay3,relay4,humidity,temperature})
        res.status(200).json(data)
    }
    catch(error){
        res.status(400).json({error : error.message})
    }

})


router.put('/updateSensor', async function (req,res){
    const id = "64492803b65e48b1237504f0";
    if (!mongoose.Types.ObjectId.isValid(id)) {
        return res.status(400).json({error: 'No such Id found'})
      }
      try{const data = await Model.findOneAndUpdate({_id: id}, {
        ...req.body
      })
       if (!data) {
        return res.status(400).json({error: 'No such Sensor'})
      }
    
      res.status(200).json({"temperature":data.temperature,"humidity" : data.humidity})
    }
    catch(error){
        res.status(400).json({error : error.message})
    }

})


router.get("/relayData", async function (req,res){
    const id = "64492803b65e48b1237504f0";
    if (!mongoose.Types.ObjectId.isValid(id)) {
        return res.status(400).json({error: 'No such Id found'})
    }
    try{
        const data = await Model.findById({_id : id})
        if (!data) {
            return res.status(400).json({error: 'No such Sensor'})
        }
        res.status(200).json({
            "relay1" : data.relay1,
            "relay2" : data.relay2,
            "relay3" : data.relay3,
            "relay4" : data.relay4,
        })

    }
    catch (error){
        res.status(400).json({error : error.message})
    }

})



module.exports = router;