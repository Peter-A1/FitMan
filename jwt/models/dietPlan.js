const mongoose = require('mongoose');

const dietPlanSchema = new mongoose.Schema({
    plan_id:{
        type: Number,
        required:[true],
        unique: true
    },

    tot_fats:{
        type: Number,
        required:[true]
    },

    tot_protein:{
        type: Number,
        required:[true]
    },

    tot_carbs:{
        type: Number,
        required:[true]

    },
    tot_calories:{
        type: Number,
        required:[true]
    },
    number_of_meals:{
        type: Number,
        required:[true]
    }



})

const dietPlan = mongoose.model('dietPlan',dietPlanSchema);
module.export = dietPlan;