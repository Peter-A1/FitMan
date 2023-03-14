const User = require("../models/User");
const jwt = require("jsonwebtoken");

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

// controller actions
module.exports.register_get = (req, res) => {
  res.render("register");
};

module.exports.login_get = (req, res) => {
  res.render("login");
};

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

 

module.exports.getstarted_put = (req, res, next) => {
  User.findByIdAndUpdate({_id:req.params.id}, req.body).then(function(){
    User.findOne({_id: req.params.id}, req.body).then(function(User){
      if(User.gender == 'Male'){
        var bmr = 655.1 + (9.563 * User.weight) + (1.850 * User.height) - (4.676 * User.age);
        
       } else{
         var bmr = 66.47 + (13.75 * User.weight) + (5.003 * User.height) - (6.755 * User.age);
         
       }
       var rawcal = bmr * User.activity_level;
       if(User.goal == "1"){
        User.calories = rawcal - 500;
       }else if(User.goal == "2"){
        User.calories = rawcal + 500;
       }
      res.send(User);
    });
  });
};

