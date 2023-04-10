const mongoose = require('mongoose');
const { db } = require('./User');

const FoodSchema = new mongoose.Schema({
    Food_id :{
        type : Number,
        unique : true
    },
    Food_name :{
        type : String
    },
    food_calories_per_preferred_serving :{
        type : Number
    },
    food_calories_per_min_serving :{
        type : Number
    },
    category :{
        type : String,
        enum :["breakfast","Lunch","Dinner"]
    },
    Main :{
        type : String,
        enum :["fats","protien","carb"]
    },
    sodium :{
        type : Number
    },
    fiber :{
        type : Number
    },
    cholestrol :{
        type : Number
    },
    carbs :{
        type : Number
    },
    fats :{
        type : Number
    },
    preferred_serving :{
        type : Number
    },
    min_serving :{
        type : Number
    },
    measuring_unit :{
        type : String
    }
})

const Food = mongoose.model("food",FoodSchema);
module.exports= Food;