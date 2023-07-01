const mongoose = require('mongoose');

const dietPlanSchema = new mongoose.Schema({
    user_id: {
        type: mongoose.Schema.types.objectId, 
        ref : 'user'
    },
    user_dietplan: {
        type: Array
    }
})

const dietPlan = mongoose.model('dietplan',dietPlanSchema);
module.exports = dietPlan;