var mongoose = require('mongoose')
const Schema  = mongoose.Schema;

const model = new Schema(
    {
        relay1 : {
            type: String,
            require : true
        },
        relay2 : {
            type: String,
            require : true
        },
        relay3 : {
            type: String,
            require : true
        },
        relay4 : {
            type: String,
            require : true
        },
        humidity: {
            type :String,
            require : true
        },
        temperature : {
            type : String,
            require : true
        }
    }
)



module.exports = mongoose.model('Data',model);