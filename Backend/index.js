var express = require('express')
var mongoose = require('mongoose')
const route = require('./router/router')
var app = express()

app.use(express.json())
const uri = "mongodb+srv://rajritik200177:7s8BJdKOtwj2ItWc@intellihouse.mbsmbe2.mongodb.net/?retryWrites=true&w=majority";
mongoose.connect(uri)
.then(()=>{
    console.log('Connected to DB');
app.listen(5000,()=>{
    console.log("server is running on 5000")
    console.log("http://localhost:5000/")
})
}).catch((err) => {
    console.log(err)
  })
app.get('/',(req,res)=>{
    res.send("<h1>Hello ! This is API of Intellihouse</h1>")
})

app.use("/api/v1",route)

