const mongoose = require('mongoose');


const MealSchema = new mongoose.Schema({
    meal_id :{
        type: Number,
        required: [true],
        unique: true
    },
    total_carbs:{
        type: Number,
        required: [true],
    },
    total_protien:{
        type: Number,
        required: [true],
    },
    total_fats:{
        type: Number,
        required: [true],
    },
    meal_calories:{
        type: Number,
        required: [true],
    },
    meal_category:{
        type: String,
        required: [true]
    }


})
const Meal = mongoose.model('meal', MealSchema);

module.exports = Meal;