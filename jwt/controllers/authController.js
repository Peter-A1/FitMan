const User = require("../models/User");
const Food = require("../models/Food");
//const dietPlan = require("../models/dietPlan");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
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

module.exports.getstarted_put = async (req, res) => {
    User.findByIdAndUpdate({_id: req.params.id},{gender:req.body.gender, age:req.body.age, activity_level:req.body.activity_level, weight:req.body.weight, height:req.body.height, goal: req.body.goal},{ new: true } )
    .then(async function (user) {
      
      //caluclating calories algorithm
      if (req.body.gender === "Male") {
        var bmr = 655.1 + 9.563 * parseInt(req.body.weight) + 1.85 * parseInt(req.body.height) - 4.676 * parseInt(req.body.age);
        console.log(`gender:${req.body.gender} weight:${parseInt( req.body.weight)} height:${parseInt(req.body.height)} age:${parseInt(req.body.age)}`);
      } else {
        var bmr = 66.47 + 13.75 * parseInt(req.body.weight) + 5.003 * parseInt(req.body.height) - 6.755 * parseInt(req.body.age);
        console.log(`gender:${req.body.gender} weight:${parseInt(req.body.weight)} height:${parseInt(req.body.height)} age:${parseInt(req.body.age)}`);
      }
      var rawcal = bmr * req.body.activity_level;
      if (req.body.goal === "1") {
        ucalories = rawcal - 500;
        const temp = ucalories;
         await updateCal( user,  temp);
      
        return temp;
      } else if(req.body.goal === "2"){
        ucalories = rawcal + 500;
        const temp = ucalories;
         await updateCal( user, temp);
        

        return temp;
      }
      
    })
    async function updateCal(user, temp){
      User.findByIdAndUpdate({_id: req.params.id},{calories: await temp},{ new: true }).then(function(user){
        res.send(user);
      })
    }


}
    
  

module.exports.DietPlan = async (req, res) => {
  var breakfast = [],
    lunch = [],
    dinner = [];
  // User.findById({ _id: req.params.id }, req.body).then(function () {
    User.findOneAndUpdate({ _id: req.params.id }, req.body,{ new: true }).then(
      async function (User) {
        breakfast = req.body.breakfast;
        lunch = req.body.lunch;
        dinner = req.body.dinner;
         updateUfood(breakfast, lunch, dinner);
         CreateDietPlan(await User.calories,await User.breakfast,await User.lunch,await User.dinner,await User);
          //updateUdietplan(CreateDietPlan(User.calories,User.breakfast, User.lunch, User.dinner, User)); 
      }
    );
    function updateUfood(foodid) {
      User.findOneAndUpdate(
        { _id: req.params.id },
        {
          breakfast: Array.from(breakfast),
          lunch: Array.from(lunch),
          dinner: Array.from(dinner),
        },{ new: true }
      )
    }
    
    async function updateUdietplan(temp) {
      User.findOneAndUpdate(
        { _id: req.params.id },
        {
          dietplan: await temp
        },{ new: true }
      ).then(async function (User) {
        res.send(User);
        //console.log(User.dietplan, "---------------------------user diet plan");
      });
    };




    async function CreateDietPlan(calories, arrfavbreakfast, arrfavlunch, arrfavdinner, user) {
      const longest_array = (arr1, arr2, arr3) => {
        if (arr1.length >= arr2.length && arr1.length >= arr3.length)
          return arr1.length;
        if (arr2.length >= arr1.length && arr2.length >= arr3.length)
          return arr2.length;
        if (arr3.length >= arr1.length && arr3.length >= arr2.length)
          return arr3.length;
      };
    
      var breakfastCalories = calories * 0.3;
      var lunchCalories = calories * 0.5;
      var dinnerCalories = calories * 0.2;
      const max_arr_lenth = longest_array(
        arrfavbreakfast,
        arrfavlunch,
        arrfavdinner
      );
     
    
      //BREAKFAST
      arrfavbreakfast.forEach((favbreakfastitem, index) => {
        Food.findOne({ Food_id: favbreakfastitem })
          .then(async function (Food) {
            if (breakfastCalories - Food.food_calories_per_preferred_serving > 0) {
              dietplan.breakfast.push(await Food.Food_id);
              breakfastCalories =
                breakfastCalories - Food.food_calories_per_preferred_serving;
            }
          })
          .then(async () => {
            if (
              index === max_arr_lenth - 1 &&
              index !== arrfavlunch.length - 1 &&
              index !== arrfavdinner.length - 1
            ) {
              dietplan.reamaining =
                breakfastCalories + lunchCalories + dinnerCalories;
              //console.log("-----------diet plan from breakfast----------");
              if (dietplan.reamaining >= 300) {
                CreateDietPlan(
                  dietplan.reamaining,
                  arrfavbreakfast,
                  arrfavlunch,
                  arrfavdinner
                );
              } else {
                const temp = await dietplan;
                // updateUdietplan(temp);
                //console.log(await dietplan, '---------dietplan');
                //console.log(user.dietplan,'----------------------user plan');
                //console.log(temp);
                dietplan = {
                  breakfast: [],
                  lunch: [],
                  dinner: [],
                  reamaining: 0,
                };
               await updateUdietplan(await temp);
                return temp;
              }
            }
          });
      });
      //LUNCH
      arrfavlunch.forEach((favlunchitem, index) => {
        Food.findOne({ Food_id: favlunchitem })
          .then(async function (Food) {
            if (lunchCalories - Food.food_calories_per_preferred_serving >= 0) {
              dietplan.lunch.push(await Food.Food_id);
              lunchCalories =
                lunchCalories - Food.food_calories_per_preferred_serving;
            }
          })
          .then(async () => {
            if (index === max_arr_lenth - 1 && index !== arrfavdinner.length - 1) {
              dietplan.reamaining =
                breakfastCalories + lunchCalories + dinnerCalories;
              //console.log("-----------diet plan from lunch----------");
              if (dietplan.reamaining >= 300) {
                CreateDietPlan(
                  dietplan.reamaining,
                  arrfavbreakfast,
                  arrfavlunch,
                  arrfavdinner
                );
              } else {
                const temp = dietplan;
                //updateUdietplan(dietplan);
                //console.log(await dietplan, '---------dietplan');
                //console.log(temp);
                dietplan = {
                  breakfast: [],
                  lunch: [],
                  dinner: [],
                  reamaining: 0,
                };
                await updateUdietplan(await temp);
                return temp;
              }
            }
            
          });
         
      });
    
      //DINNER
      arrfavdinner.forEach((favdinneritem, index) => {
        Food.findOne({ Food_id: favdinneritem })
          .then(async function (Food) {
            if (dinnerCalories - Food.food_calories_per_preferred_serving >= 0) {
              dietplan.dinner.push(await Food.Food_id);
              dinnerCalories =
                dinnerCalories - Food.food_calories_per_preferred_serving;
            }
          })
          .then(async () => {
            if (index === max_arr_lenth - 1) {
              dietplan.reamaining =
                breakfastCalories + lunchCalories + dinnerCalories;
              //console.log("-----------diet plan from dinner----------");
              if (dietplan.reamaining >= 300) {
                CreateDietPlan(
                  dietplan.reamaining,
                  arrfavbreakfast,
                  arrfavlunch,
                  arrfavdinner
                );
              } else {
                const temp = dietplan;
                
                //console.log(await dietplan, '---------dietplan');
                //console.log(temp);
                dietplan = {
                  breakfast: [],
                  lunch: [],
                  dinner: [],
                  reamaining: 0,
                };
                await updateUdietplan(await temp);
                return temp;
              }
            }
          });
      });
      
      
      return dietplan;
    }
};

let dietplan = {
  breakfast: [],
  lunch: [],
  dinner: [],
  reamaining: 0,
};







module.exports.forgetpassword_post = async (req, res) => {
  const email = req.body.email;
  const tuser = await User.findOne({ email });
  if (!tuser) {
    return res.status(400).json({ error: "User not found" });
  }
  const secret = tuser.password + "fdhfgsfjsdgfvbhajsk1342178";
  const link = jwt.sign({ id: tuser._id, email: tuser.email }, secret, {
    expiresIn: "15m",
  });

  var transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: "fitmantest123@gmail.com",
      pass: "vjuedmjajmlilxfg",
    },
  });
  const setPassLink = `http://localhost:5000/reset-password/${tuser._id}/${link}`;
  const data = {
    from: "fitmantest123@gmail.com",
    to: tuser.email,
    subject: "Reset password link",
    text: setPassLink,
  };

  return User.updateOne({ resetLink: link }, (err, User) => {
    if (err) {
      return res.status(400).json({ error: "reset link error" });
    } else {
      transporter.sendMail(data, function (error, info) {
        if (error) {
          console.log(error);
        } else {
          return res.status(200).json({ message: "reset link sent" });
        }
      });
    }
  });
};

module.exports.resetpassword_put = async (req, res) => {
  const { id, token } = req.params;
  const { password } = req.body;

  const oldUser = await User.findOne({ _id: id });
  if (!oldUser) {
    return res.json({ status: "User Not Exists!!" });
  }
  const secret = oldUser.password + "fdhfgsfjsdgfvbhajsk1342178";
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
  User.findOne({ _id: req.params.id }).then(function (User) {
    res.send(User);
  });
};

module.exports.addfood = async (req, res) => {
  const {
    Food_id,
    Food_name,
    food_calories_per_min_servings,
    food_calories_per_preferred_serving,
    category,
    Main,
    preferred_serving,
    min_serving,
  } = req.body;

  try {
    console.log("hello");
    const food = await Food.create({
      Food_id,
      Food_name,
      food_calories_per_min_servings,
      food_calories_per_preferred_serving,
      category,
      Main,
      preferred_serving,
      min_serving,
    });
    res.status(201).json({ food: food });
  } catch (err) {
    const errors = handleErrors(err);
    res.status(405).json({ err });
  }
};
