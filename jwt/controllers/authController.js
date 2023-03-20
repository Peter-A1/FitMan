const User = require("../models/User");
const Food = require("../models/Food");
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
  if (err.message === "Incorrect email") {
    errors.email = "That email is not registered";
  }

  // incorrect password
  if (err.message === "Incorrect password") {
    errors.password = "That password is not correct";
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
        var bmr = (10 * User.weight) + (6.25 * User.height) - (5 * User.age) + 5;
        
       } else{
         var bmr = (10 * User.weight) + (6.25 * User.height) - (5 * User.age) - 161;
         
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

module.exports.dietPlan = (req, res) => {
  var breakfast =[], lunch=[], dinner=[];
  User.findById({_id:req.params.id}, req.body).then(function(){
    User.findOneAndUpdate({_id: req.params.id}, req.body).then(function(User){
         breakfast = req.body.breakfast; lunch = req.body.lunch; dinner = req.body.dinner;
         updateUfood(breakfast, lunch, dinner);
         res.send(CreateDietPlan(User.calories, User.breakfast, User.lunch, User.dinner));
     });  
     function updateUfood(foodid){
      User.findOneAndUpdate({_id: req.params.id}, {breakfast: Array.from(breakfast), lunch: Array.from(lunch), dinner: Array.from(dinner)}).then(function(User){
        console.log(breakfast, lunch, dinner);
        console.log(User);
       });
     }
  });
};



let arr = "";

function CreateDietPlan(calories, arrfavbreakfast, arrfavlunch, arrfavdinner)  {
  
  var breakfastCalories = calories /3; 
  var lunchCalories = calories /3;
  var dinnerCalories = calories /3;
  
  let dietplan = {
    "breakfast": [],
    "lunch": [],
    "dinner": [],
    "snacks":[]
  };
  
  
  //BREAKFAST
  arrfavbreakfast.forEach((favbreakfastitem) => {
    
    Food.findOne({Food_id:favbreakfastitem}).then(async function(Food){
      if((breakfastCalories - Food.food_calories_per_preferred_serving) > 0){
        dietplan.breakfast.push(await Food);
        breakfastCalories = breakfastCalories - Food.food_calories_per_preferred_serving;
      }
    })
  }); 
  //LUNCH
  arrfavlunch.forEach((favlunchitem) => {
    Food.findOne({Food_id:favlunchitem}).then(async function(Food){
      if(lunchCalories - Food.food_calories_per_preferred_serving >= 0){ 
        dietplan.lunch.push(await Food);
        lunchCalories = lunchCalories - Food.food_calories_per_preferred_serving;
      }
    })
  });

  //DINNER
  arrfavdinner.forEach((favdinneritem) => {
    Food.findOne({Food_id:favdinneritem}).then(async function(Food){
      if(dinnerCalories - Food.food_calories_per_preferred_serving >= 0){ 
        dietplan.dinner.push(await Food);
        dinnerCalories = dinnerCalories - Food.food_calories_per_preferred_serving;
      }
    })
  });
  
  setTimeout(() => {
    const remainingcalories = breakfastCalories+lunchCalories+dinnerCalories;
  dietplan.snacks.push(`Snack: ${remainingcalories}`);
  console.log(dietplan, "----------204");
  },10000);
  
  return  dietplan;
  



  // User.findById({_id: req.params.id}).then(function(User){
  //   // console.info(User.breakfast);
  //   ;
  //   User.breakfast[1] = 1;
  //   Food.findOne({Food_id: User.breakfast[1]}, req.body).then(function(Food){
  //     console.log(Food);
  //   });
  //   //breakfast
  //   // var numberOffoods = User.breakfast.length; console.log(numberOffoods);
  //   // for(let i = 0; i<numberOffoods;i++){
  //   //   Food.findOne({food_id:User.breakfast[i]}, req.body).then(function(Food){
          
  //   //   });
  //  // }
  //})
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



module.exports.addfood = async (req, res) => {
  const { Food_id, Food_name, food_calories_per_min_servings, food_calories_per_preferred_serving, category, Main, preferred_serving, min_serving } = req.body;

  try {
    console.log('hello')
    const food = await Food.create({Food_id, Food_name, food_calories_per_min_servings, food_calories_per_preferred_serving, category, Main, preferred_serving, min_serving });
    res.status(201).json({food: food});
  } catch (err) {
    const errors = handleErrors(err);
    res.status(405).json({ err });
  }
};