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
  User.findByIdAndUpdate(
    { _id: req.params.id },
    {
      gender: req.body.gender,
      age: req.body.age,
      activity_level: req.body.activity_level,
      weight: req.body.weight,
      height: req.body.height,
      goal: req.body.goal,
    },
    { new: true }
  ).then(async function (user) {
    //caluclating calories algorithm
    if (req.body.gender === "Male") {
      var bmr =
        655.1 +
        9.563 * parseInt(req.body.weight) +
        1.85 * parseInt(req.body.height) -
        4.676 * parseInt(req.body.age);
      console.log(
        `gender:${req.body.gender} weight:${parseInt(
          req.body.weight
        )} height:${parseInt(req.body.height)} age:${parseInt(req.body.age)}`
      );
    } else {
      var bmr =
        66.47 +
        13.75 * parseInt(req.body.weight) +
        5.003 * parseInt(req.body.height) -
        6.755 * parseInt(req.body.age);
      console.log(
        `gender:${req.body.gender} weight:${parseInt(
          req.body.weight
        )} height:${parseInt(req.body.height)} age:${parseInt(req.body.age)}`
      );
    }
    var rawcal = bmr * req.body.activity_level;
    if (req.body.goal === "1") {
      ucalories = rawcal - 500;
      const temp = ucalories;
      await updateCal(user, temp);

      return temp;
    } else if (req.body.goal === "2") {
      ucalories = rawcal + 500;
      const temp = ucalories;
      await updateCal(user, temp);

      return temp;
    }
  });
  async function updateCal(user, temp) {
    User.findByIdAndUpdate(
      { _id: req.params.id },
      { calories: await temp },
      { new: true }
    ).then(function (user) {
      res.send(user);
    });
  }
};

module.exports.DietPlan = async (req, res) => {
  var breakfast = [],
    lunch = [],
    dinner = [];
  // User.findById({ _id: req.params.id }, req.body).then(function () {
  User.findById({ _id: req.params.id }).then(
    async function (User) {
      breakfast = User.breakfast;
      lunch = User.lunch;
      dinner = User.dinner;
      // updateUfood(breakfast, lunch, dinner);
      CreateDietPlan(
        await User.calories,
        await User.breakfast,
        await User.lunch,
        await User.dinner,
        await User
      );
      //merge_dietPlan(User.dietplan);
    }
  );
  // function updateUfood(foodid) {
  //   User.findOneAndUpdate(
  //     { _id: req.params.id },
  //     {
  //       breakfast: Array.from(breakfast),
  //       lunch: Array.from(lunch),
  //       dinner: Array.from(dinner),
  //     },
  //     { new: true }
  //   );
  // }

  async function updateUdietplan(temp) {
    User.findOneAndUpdate(
      { _id: req.params.id },
      {
        dietplan: await temp,
      },
      { new: true }
    ).then(async function (User) {
      res.send(User);
      //console.log(User.dietplan, "---------------------------user diet plan");
    });
  }

  //--------------------------start of work ----------------------------------------------
  // {
  // breakfast:[1,1,2,2,2,3,3],
  // lunch:[1,3,4],
  // dinner:[2,3,4],
  // reamaining:int,
  //}

  // {
  // breakfast:[{food_obj:1,number_of_rep},{}],
  // lunch:[],
  // dinner:[],
  // reamaining:int,
  //}
  const merge_dietPlan = (dietPlan) => {
    let new_dietPlan = {
      breakfast: [],
      lunch: [],
      dinner: [],
      reamaining: 0,
    };

    const merge_breakfast = (new_dietPlan) => {
      let breakfast_ids = dietPlan.breakfast.map((breakfast_item) => {
        return breakfast_item.Food_id;
      });
      breakfast_ids.map(() => {});
      let breakfast_uniqe_objects = [];
      let unique_breakfast_ids = [...new Set(breakfast_ids)];
      unique_breakfast_ids.map((unique_breakfast_id) => {
        let food_counter = 0;

        dietPlan.breakfast.map((breakfast_item) => {
          if (unique_breakfast_id === breakfast_item.Food_id) {
            food_counter++;
          }
        });
        let new_dietPlan_food = {
          food_item: dietPlan.breakfast.find(
            (breakfast_item) => breakfast_item.Food_id === unique_breakfast_id
          ),
          n: food_counter,
        };

        // let new_dietPlan_food = {...dietPlan.breakfast.find((breakfast_item) => breakfast_item.Food_id === unique_breakfast_id),
        //   preferred_serving: "5", //dietPlan.breakfast.find((breakfast_item) => breakfast_item.Food_id === unique_breakfast_id).preferred_serving * food_counter, 
        //   food_calories_per_preferred_serving: dietPlan.breakfast.find((breakfast_item) => breakfast_item.Food_id === unique_breakfast_id).food_calories_per_preferred_serving * food_counter
        // } 
          
        

        new_dietPlan.breakfast.push(new_dietPlan_food);
        //unique_breakfast_item.Food_id
      });
    };

    const merge_lunch = (new_dietPlan) => {
      let lunch_ids = dietPlan.lunch.map((lunch_item) => {
        return lunch_item.Food_id;
      });
      lunch_ids.map(() => {});
      let lunch_uniqe_objects = [];
      let unique_lunch_ids = [...new Set(lunch_ids)];
      unique_lunch_ids.map((unique_lunch_id) => {
        let food_counter = 0;

        dietPlan.lunch.map((lunch_item) => {
          if (unique_lunch_id === lunch_item.Food_id) {
            food_counter++;
          }
        });
        let new_dietPlan_food = {
          food_item: dietPlan.lunch.find(
            (lunch_item) => lunch_item.Food_id === unique_lunch_id
          ),
          n: food_counter,
        };
        new_dietPlan.lunch.push(new_dietPlan_food);
        //unique_breakfast_item.Food_id
      });
    };
    
    const merge_dinner = (new_dietPlan) => {
      let dinner_ids = dietPlan.dinner.map((dinner_item) => {
        return dinner_item.Food_id;
      });
      dinner_ids.map(() => {});
      let dinner_uniqe_objects = [];
      let unique_dinner_ids = [...new Set(dinner_ids)];
      unique_dinner_ids.map((unique_dinner_id) => {
        let food_counter = 0;

        dietPlan.dinner.map((dinner_item) => {
          if (unique_dinner_id === dinner_item.Food_id) {
            food_counter++;
          }
        });
        let new_dietPlan_food = {
          food_item: dietPlan.dinner.find(
            (dinner_item) => dinner_item.Food_id === unique_dinner_id
          ),
          n: food_counter,
        };

        new_dietPlan.dinner.push(new_dietPlan_food);
        //unique_breakfast_item.Food_id
      });
    };
    
    merge_breakfast(new_dietPlan);
    merge_lunch(new_dietPlan);
    merge_dinner(new_dietPlan);
    new_dietPlan.reamaining=dietPlan.reamaining;
    
    return new_dietPlan;
  };

  function shuffle(array) {
    let currentIndex = array.length,  randomIndex;
  
    // While there remain elements to shuffle.
    while (currentIndex != 0) {
  
      // Pick a remaining element.
      randomIndex = Math.floor(Math.random() * currentIndex);
      currentIndex--;
  
      // And swap it with the current element.
      [array[currentIndex], array[randomIndex]] = [
        array[randomIndex], array[currentIndex]];
    }
  
    return array;
  }


  async function CreateDietPlan(
    calories,
    arrfavbreakfast,
    arrfavlunch,
    arrfavdinner,
    user
  ) {

    shuffle(arrfavbreakfast);
    arrfavbreakfast.length = 3;
    shuffle(arrfavlunch);
    arrfavlunch.length = 3;
    shuffle(arrfavdinner);
    arrfavdinner.length = 3;

    // const longest_array = (arr1, arr2, arr3) => {
    //   if (arr1.length >= arr2.length && arr1.length >= arr3.length)
    //     return arr1.length;
    //   if (arr2.length >= arr1.length && arr2.length >= arr3.length)
    //     return arr2.length;
    //   if (arr3.length >= arr1.length && arr3.length >= arr2.length)
    //     return arr3.length;
    // };

    var breakfastCalories = calories * 0.3;
    var lunchCalories = calories * 0.5;
    var dinnerCalories = calories * 0.2;
    // const max_arr_lenth = longest_array(
    //   arrfavbreakfast,
    //   arrfavlunch,
    //   arrfavdinner
    // );
    const max_arr_lenth = 3;

    //BREAKFAST
    arrfavbreakfast.forEach((favbreakfastitem, index) => {
      Food.findOne({ Food_id: favbreakfastitem })
        .then(async function (Food) {
          if (
            breakfastCalories - Food.food_calories_per_preferred_serving >
            0
          ) {
            dietplan.breakfast.push(await Food);
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
              // await updateUdietplan(await temp);
              let merged = merge_dietPlan(temp);
              await updateUdietplan(merged);
                return merged;
            }
          }
        });
    });
    //LUNCH
    arrfavlunch.forEach((favlunchitem, index) => {
      Food.findOne({ Food_id: favlunchitem })
        .then(async function (Food) {
          if (lunchCalories - Food.food_calories_per_preferred_serving >= 0) {
            dietplan.lunch.push(await Food);
            lunchCalories =
              lunchCalories - Food.food_calories_per_preferred_serving;
          }
        })
        .then(async () => {
          if (
            index === max_arr_lenth - 1 &&
            index !== arrfavdinner.length - 1
          ) {
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
              let merged = merge_dietPlan(temp);
              await updateUdietplan(merged);
                return merged;
            }
          }
        });
    });

    //DINNER
    arrfavdinner.forEach((favdinneritem, index) => {
      Food.findOne({ Food_id: favdinneritem })
        .then(async function (Food) {
          if (dinnerCalories - Food.food_calories_per_preferred_serving >= 0) {
            dietplan.dinner.push(await Food);
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
              
              // console.log(merge_dietPlan(temp),"---------------------------460");
              let merged = merge_dietPlan(temp);
              await updateUdietplan(merged);
                return merged;
            }
          }
        });
    });
    
    return dietplan;
  }
};
//-----------------end of work

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
    //console.log("hello");
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

module.exports.foodData = async (req, res) => {
  Food.findOne({ Food_id: req.params.id }).then(function (food) {
    res.send(food);
  });
};


module.exports.search = async (req, res) => {
  let data = await Food.find({
    "$or":[
      {Food_name:{$regex:req.params.key}}
    ]
  });
  // data.length = 100;
  res.send(data);
};


// module.exports.favfood = async (req, res) => {
//   let favlist= {food: []};
//   User.findById({_id: req.params.id}).then(async function (user) {
//     favfood = user.breakfast.concat(user.lunch, user.dinner);
//     for(let i = 0; i <= favfood.length;i++){
//       Food.findOne({Food_id: favfood[i]}).then(function (Food) {
//         favlist.food.push(Food);
//         return favlist;
//       }).then(function(favlist){
//         if(i === favfood.length-1){
//           User.findByIdAndUpdate({_id:req.params.id},{favfood: favlist}, {new: true}).then(function(user){
//             res.send(user.favfood);
//           })
//         }
//       })  
//     }
//   })
// }


module.exports.pickfood = (req, res) => {
  let favlist= [];
  // let favfood = [];
    let breakfastpick=0;
    let lunchpick=0;
    let dinnerpick=0;
  User.findById({_id: req.params.id}).then(function(user){
    breakfastpick = user.breakfast.concat(req.body.breakfast);
    lunchpick = user.lunch.concat(req.body.lunch);
    dinnerpick = user.dinner.concat(req.body.dinner);
  }).then(async function(){
    User.findByIdAndUpdate({_id: req.params.id},{breakfast: breakfastpick, lunch: lunchpick, dinner: dinnerpick}, {new: true}).then(function(user){
      favlist = user.favfood;
       if(req.body.breakfast.length > 0){
        Food.findOne({Food_id: req.body.breakfast}).then(function (Food) {
          favlist.push(Food);
          
        }).then(function(user){
          User.findByIdAndUpdate({_id:req.params.id},{favfood: favlist}, {new: true}).then(function(user){
            res.send(user);
          })
        })
       }else if(req.body.lunch.length > 0){
        Food.findOne({Food_id: req.body.lunch}).then(function (Food) {
          favlist.push(Food);
        }).then(function(user){
          User.findByIdAndUpdate({_id:req.params.id},{favfood: favlist}, {new: true}).then(function(user){
            res.send(user);
          })
        })
       }else if(req.body.dinner.length > 0){
        Food.findOne({Food_id: req.body.dinner}).then(function (Food) {
          favlist.push(Food);
        }).then(function(user){
          User.findByIdAndUpdate({_id:req.params.id},{favfood: favlist}, {new: true}).then(function(user){
            res.send(user);
          })
        })
       }
    })
  })
}

// favfood = favfood.concat(user.breakfast, user.lunch, user.dinner);
//        favfood.forEach((id, idx)=>{
//         Food.findOne({Food_id: id}).then(function (Food) {
//           favlist.push(Food);
//         }).then(function(){
//           if(idx === favfood.length-1){
//                   User.findByIdAndUpdate({_id:req.params.id},{favfood: favlist}, {new: true}).then(function(user){
//                     res.send(user);
//                   })
//                 }
//         })
//       })

module.exports.removefood = (req, res) => {
        User.findByIdAndUpdate({_id: req.params.id},{$pull: {breakfast:req.body.breakfast, lunch:req.body.lunch, dinner:req.body.dinner}}, {new: true}).then(function(user){
            let arr= user.favfood;
            let del;
            
            if(req.body.hasOwnProperty('breakfast')){
              del = arr.filter(obj => obj.Food_id !== req.body.breakfast);
              User.findByIdAndUpdate({_id: req.params.id},{favfood: del},{new:true}).then(function(user){
                res.send(user);
              })
            } else if(req.body.hasOwnProperty('lunch')){
              del = arr.filter(obj => obj.Food_id !== req.body.lunch);
              User.findByIdAndUpdate({_id: req.params.id},{favfood: del},{new:true}).then(function(user){
                res.send(user);
              })
            } else if(req.body.hasOwnProperty('dinner')){
              del = arr.filter(obj => obj.Food_id !== req.body.dinner);
              User.findByIdAndUpdate({_id: req.params.id},{favfood: del},{new:true}).then(function(user){
                res.send(user);
              })
            }
          })
      }
    
