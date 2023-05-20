import React, { useEffect, useState } from "react";
import { Link, Navigate, useNavigate } from "react-router-dom";
import * as Apis from "../../api_handller.js";
import AnimatedPage from "../../components/animatedPage/AnimatedPage";
import Food from "../../components/food/Food";
import { Nav } from "../../components/nav/Nav";
import styles from "./dietPlan.module.css";

export const DietPlan = ({
  currentPage,
  setcurrentPage,
  token,
  userData,
  setUserData,
  IP,
}) => {
  
  const [userInfo, setuserInfo] = useState(userData);
  setcurrentPage("dietplan");
  let navigate = useNavigate();
  useEffect(() => {
    // if (userData.calories < 200) {
    //   navigate("/");
    // }
  });

  const generateDietplanHandller = async () => {
    
      if(JSON.parse(localStorage.getItem("userData")).breakfast.length>=3 &&JSON.parse(localStorage.getItem("userData")).lunch.length>=3 &&JSON.parse(localStorage.getItem("userData")).dinner.length>=3){
        console.log('condition true')
        const res = await Apis.getData2(
          `http://localhost:5000/${userData._id}/dietplan`
        );
        console.log(await res)
        setUserData(await res); //to set the local storage
        setuserInfo(await res); // to set the state
      }else alert('you need atleast 3 food items in each category to be able to generate a diet plan')
  
    
  };

  return (
    <div>
      <Nav
        currentPage={currentPage}
        token={localStorage.getItem("token")}
        userData={
          localStorage.getItem("userData")
            ? JSON.parse(localStorage.getItem("userData"))
            : ""
        }
      />
      <AnimatedPage>
        <div className={styles.dietPlan_container}>
          {userData.calories > 100 ? (
            <div>
              {userInfo.dietplan.length > 0 ? (
                <div>
                  {" "}
                  <h2 className={styles.tcalories}>your total calories <span className={styles.ncalories}>{Math.round(userData.calories)}</span></h2>
                  <div className={styles.breakFast}>
                    <h1>BreakFast</h1>
                    {console.log(userInfo.dietplan[0].breakfast)}
                    {JSON.parse(localStorage.getItem("userData")).dietplan[0].breakfast.map((food, index) => (
                      <Food
                        setUserData={setUserData}
                        key={index}
                        userData={userData}
                        cardcategory={'breakfast'}
                        isliked={userData.favbreakfast.filter((favitem)=>food.food_item.Food_id===favitem.Food_id).length>0?true:false}
                        foodObject={{
                          id: food.food_item.Food_id,
                          name: food.food_item.Food_name,
                          serving: `${
                            food.food_item.preferred_serving * food.n
                          } ${food.food_item.measuring_unit}`,
                          calories:
                            food.food_item.food_calories_per_preferred_serving *
                            food.n,
                          url: food.food_item.image,
                          category: food.food_item.category,
                        }}
                      />
                    ))}
                  </div>
                  <div className={styles.lunch}>
                    <h1>Lunch</h1>
                    {JSON.parse(localStorage.getItem("userData")).dietplan[0].lunch.map((food, index) => (
                      <Food
                        setUserData={setUserData}
                        key={index}
                        userData={userData}
                        cardcategory={'lunch'}
                        isliked={userData.favlunch.filter((favitem)=>food.food_item.Food_id===favitem.Food_id).length>0?true:false}
                        foodObject={{
                          id: food.food_item.Food_id,
                          name: food.food_item.Food_name,
                          serving: `${
                            food.food_item.preferred_serving * food.n
                          } ${food.food_item.measuring_unit}`,
                          calories:
                            food.food_item.food_calories_per_preferred_serving *
                            food.n,
                          url: food.food_item.image,
                          category: food.food_item.category,
                        }}
                      />
                    ))}
                  </div>
                  <div className={styles.dinner}>
                    <h1>Dinner</h1>
                    {JSON.parse(localStorage.getItem("userData")).dietplan[0].dinner.map((food, index) => (
                      <Food
                        setUserData={setUserData}
                        key={index}
                        userData={userData}
                        cardcategory={'dinner'}
                        isliked={userData.favdinner.filter((favitem)=>food.food_item.Food_id===favitem.Food_id).length>0?true:false}
                        foodObject={{
                          id: food.food_item.Food_id,
                          name: food.food_item.Food_name,
                          serving: `${
                            food.food_item.preferred_serving * food.n
                          } ${food.food_item.measuring_unit}`,
                          calories:
                            food.food_item.food_calories_per_preferred_serving *
                            food.n,
                          url: food.food_item.image,
                          category: food.food_item.category,
                        }}
                      />
                    ))}
                  </div>
                  <h1>snack calories</h1>
                  <div className={styles.snack}>
                    {Math.round(userInfo.dietplan[0].reamaining)}
                  </div>
                </div>
              ) : (
                ""
              )}
              <div className={styles.gBtnContainer}>
                <button
                  className={styles.generateBtn}
                  onClick={generateDietplanHandller}
                >
                  {!userInfo.dietplan[0]
                    ? `Generate Diet Plan`
                    : `Don't like your diet plan ? Generate Another `}
                </button>
              </div>
            </div>
          ) : (
            <div className={styles.container_for_calc_calories}>
              <h2 className={styles.calc_calories_first}>
                We need to calculate your calories first before we could
                generate your dietplan
              </h2>{" "}
              <Link to={"../infoForm"}>
                <button>GET STARTED NOW</button>
              </Link>
            </div>
          )}
        </div>
      </AnimatedPage>
    </div>
  );
};

export default DietPlan;
