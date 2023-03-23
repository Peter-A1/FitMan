const mongoose = require('mongoose');
const {isEmail} = require('validator');
const bcrypt = require('bcrypt');


const userSchema = new mongoose.Schema({
    name: {
        type: String,
        required: [true, 'Please enter your name']
    },
    email: {
        type: String,
        required: [true, 'Please enter an email'],
        unique: true,
        lowercase: true,
        validate: [isEmail, 'Please enter a valid Email']
    },
    password: {
        type: String,
        required: [true, 'Please enter a password'],
        minLength: [6, 'Password should be atleast 6 characters long']

    },
    
    date: {
        type: Date,
        default: Date.now
    },
    gender:{
        type: String,
        enum: ["Male","Female"]
    },
    activity_level: {
        type: String,
        enum: ["1.2","1.3","1.4","1.7","1.9"]
    },
    age: {
        type: Number
    },
    weight: {
        type: Number
    },
    height: {
        type: Number
    },
    goal: {
        //1= lose weight 2= gain weight
        type: Number
    },
    calories: {
        type: Number,
        default: 100
        
    },
    resetLink: {
        data: String,
        default: ''
    },
    breakfast: {
        type: Array
    },
    lunch: {
        type: Array
    },
    dinner: {
        type: Array
    }

}); 


userSchema.statics.login = async function(email, password) {
    const user = await this.findOne({ email });
    if(user){
        const auth = await bcrypt.compare(password, user.password);
        if(auth){
            return user;
        }
        throw Error('Incorrect password');
    }
    throw Error('Incorrect email');
}


userSchema.post('save', function(doc,next){
    console.log('new user created', doc);
    next();
});

userSchema.pre('save',async function(next){
    const salt = await bcrypt.genSalt();
    this.password = await bcrypt.hash(this.password, salt);
    next();
});

const User = mongoose.model('user', userSchema);

module.exports = User;