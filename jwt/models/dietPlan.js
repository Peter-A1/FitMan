const mongoose = require('mongoose');

const dietPlanSchema = new mongoose.Schema({
    user_id: {
        type: Number
    },
    user_breakfast: {
        type: Array
    },
    user_lunch: {
        type: Array
    },
    user_dinner: {
        type: Array
    }
})

const dietPlan = mongoose.model('dietPlan',dietPlanSchema);
module.export = dietPlan;