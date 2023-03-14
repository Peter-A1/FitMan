const User = require("../models/User");
const jwt = require('jsonwebtoken');

const requireAuth = (req, res, next) => {
    const token = req.cookies.jwt;

    //check is token exists
    if(token){
        jwt.verify(token, 'top secret', (err, decodedtoken) => {
            if(err){
                console.log(err.message);
                res.redirect('/login');
            }
            else {
                console.log(decodedtoken);
                next();
            }
        })
    }
    else {
        res.redirect('/login');
    }
}

//check user
const checkUser = (req, res, next) => {
    const token = req.cookies.jwt;

    if(token){
        jwt.verify(token, 'top secret', async (err, decodedtoken) => {
            if(err){
                console.log(err.message);
                res.locals.user = null;
                next();
            }
            else {
                console.log(decodedtoken);
                let user = await User.findById(decodedtoken.id);
                res.locals.user = user;
                next();
            }
        })
    }
    else {
        res.locals.user = null;
        next();
    }
}

module.exports = { requireAuth, checkUser };