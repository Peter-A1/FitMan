const User = require("../models/User");
const jwt = require("jsonwebtoken");
const bcrypt = require('bcrypt');
var nodemailer = require("nodemailer");
const localIpAddress = require("local-ip-address");
const { db } = require("../models/User");


let ucalories = 1;

//err handler
const handleErrors = (err) => {
  console.log(err.message, err.code);
  let errors = { name: "", email: "", password: "" };

  // incorrect email
  if (err.message === "Incorrect Email") {
    errors.email = "That email is not registered";
  }

  // incorrect password
  if (err.message === "Incorrect password") {
    errors.email = "That password is not correct";
  }

  //dublicate err code
  if (err.code === 11000) {
    errors.email = "Email already registered";
    return errors;
  }

  //validation
  if (err.message.includes("user validation failed")) {
    // console.log(err);
    Object.values(err.errors).forEach(({ properties }) => {
      // console.log(val);
      // console.log(properties);
      errors[properties.path] = properties.message;
    });
  }

  return errors;
};

const maxAge = 3 * 24 * 60 * 60;

const createToken = (id) => {
  return jwt.sign({ id }, "top secret", {
    expiresIn: maxAge,
  });
};

module.exports.ip = (req, res) => {
  res.send(localIpAddress());
  };


// controller actions

module.exports.register_post = async (req, res) => {
  const { name, email, password } = req.body;

  try {
    const user = await User.create({ name, email, password });
    const token = createToken(user._id);
    res.cookie("jwt", token, { httpOnly: true, maxAge: maxAge * 1000 });
    res.status(201).json({ user: user._id });
  } catch (err) {
    const errors = handleErrors(err);
    res.status(400).json({ errors });
  }
};

module.exports.login_post = async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await User.login(email, password);
    const token = createToken(user._id);
    res.cookie("jwt", token, { httpOnly: true, maxAge: maxAge * 1000 });
    res.status(200).json({ user: user, token: token });
  } catch (err) {
    const errors = handleErrors(err);
    res.status(400).json({ errors });
  }
};

module.exports.logout_get = (req, res) => {
  res.cookie("jwt", "", { maxAge: 1 });
  res.redirect("/");
};

 

module.exports.getstarted_put = (req, res) => {
  var ucalories;
  User.findById({_id:req.params.id}, req.body).then(function(){
    User.findOneAndUpdate({_id: req.params.id}, req.body).then(function(User){
        
      //caluclating calories algorithm
      if(User.gender == 'Male'){
        var bmr = 655.1 + (9.563 * User.weight) + (1.850 * User.height) - (4.676 * User.age);
        
       } else{
         var bmr = 66.47 + (13.75 * User.weight) + (5.003 * User.height) - (6.755 * User.age);
         
       }
       var rawcal = bmr * User.activity_level;
       if(User.goal == "1"){
        ucalories = rawcal - 500;
        updateCal(ucalories);
        
       }else {
        ucalories = rawcal + 500;
        updateCal(ucalories);
      };
     });  
     
     async function updateCal(ucalories){
      User.findOneAndUpdate({_id: req.params.id}, {calories:await ucalories}).then(function(User){
        console.log("done");
        res.send(User);
        console.log(ucalories);
       });
     }
     
  });
  
};



module.exports.forgetpassword_post = async (req, res) => {
  const email = req.body.email;
  const tuser = await User.findOne({email});
  if(!tuser){
    return res.status(400).json({error:'User not found'});
  }
    const secret = tuser.password + "fdhfgsfjsdgfvbhajsk1342178";
    const link = jwt.sign({id: tuser._id, email: tuser.email}, secret, {expiresIn: '15m'});

    var transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: 'fitmantest123@gmail.com',
        pass:'vjuedmjajmlilxfg'
      }
    });
    const setPassLink = `http://localhost:5000/reset-password/${tuser._id}/${link}`;
    const data = {
      from:'fitmantest123@gmail.com',
      to:tuser.email,
      subject: 'Reset password link',
      text: setPassLink
    }

    return User.updateOne({resetLink: link}, (err, User) => {
      if(err){
        return res.status(400).json({error:'reset link error'});
      }
      else {
        transporter.sendMail(data, function (error, info) {
          if (error) {
            console.log(error);
          } else {
            return res.status(200).json({message:'reset link sent'});
          }
        })
        
      }
    })

  };

module.exports.resetpassword_put = async (req, res) => {
  const { id, token } = req.params;
  const { password } = req.body;

  const oldUser = await User.findOne({ _id: id });
  if (!oldUser) {
    return res.json({ status: "User Not Exists!!" });
  }
  const secret =  oldUser.password + "fdhfgsfjsdgfvbhajsk1342178";
  try {
    const verify = jwt.verify(token, secret);
    const encryptedPassword = await bcrypt.hash(password, 10);
    await User.updateOne(
      {
        _id: id,
      },
      {
        $set: {
          password: encryptedPassword,
        },
      }
    );

    res.render("/", { email: verify.email, status: "verified" });
  } catch (error) {
    console.log(error);
    res.json({ status: "Something Went Wrong" });
}
};

module.exports.userData = (req, res) => {
  User.findOne({_id: req.params.id}, req.body).then(function(User){
    
    res.send(User);
    console.log(User.calories);
  });


};