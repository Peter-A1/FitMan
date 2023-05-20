import React, { useEffect } from "react";
import Food from "../../components/food/Food";
import styles from "./favorite.module.css";
import AnimatedPage from "../../components/animatedPage/AnimatedPage";
import { Link, Navigate, useNavigate } from "react-router-dom";
import { Nav } from "../../components/nav/Nav";

const Favorite = ({
  currentPage,
  setcurrentPage,
  token,
  userData,
  IP,
  setUserData,
}) => {
  setcurrentPage("favorite");
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
        <div className={styles.container}>
          {userData.favbreakfast.length === 0 &&
          userData.favlunch.length === 0 &&
          userData.favdinner.length === 0 ? (
            <div className={styles.empty_fav_food_container}>
              <h2 className={styles.text}>
                ops it looks like you haven't added any food yet !
              </h2>
              <Link to={"../search"}>
                <button className={styles.btnnnn}>ADD FOOD NOW</button>
              </Link>
            </div>
          ) : <div className={styles.favfood_container}>
            <h2>your favorite breakfast food</h2>
            <div className={styles.b_l_c_container}>
              {userData.favbreakfast.map((fooditem, index) => {
                return fooditem ? (
                  <Food
                    setUserData={setUserData}
                    key={index}
                    userData={userData}
                    cardcategory={'breakfast'}
                    isliked={userData.favbreakfast.filter((favitem)=>fooditem.Food_id===favitem.Food_id).length>0?true:false}
                    foodObject={{
                      id: fooditem.Food_id,
                      name: fooditem.Food_name,
                      serving: `${fooditem.preferred_serving} ${fooditem.measuring_unit}`,
                      calories: fooditem.food_calories_per_preferred_serving,
                      url: fooditem.image,
                      category: fooditem.category,
                    }}
                  />
                ) : (
                  ""
                );
              })}
            </div>
            <h2>your favorite lunch food</h2>
            <div className={styles.b_l_c_container}>
              {userData.favlunch.map((fooditem, index) => {
                return fooditem ? (
                  <Food
                    key={index}
                    userData={userData}
                    setUserData={setUserData}
                    cardcategory={'lunch'}
                    isliked={userData.favlunch.filter((favitem)=>fooditem.Food_id===favitem.Food_id).length>0?true:false}
                    foodObject={{
                      id: fooditem.Food_id,
                      name: fooditem.Food_name,
                      serving: `${fooditem.preferred_serving} ${fooditem.measuring_unit}`,
                      calories: fooditem.food_calories_per_preferred_serving,
                      url: fooditem.image,
                      category: fooditem.category,
                    }}
                  />
                ) : (
                  ""
                );
              })}
            </div>
            <h2>your favorite dinner food</h2>
            <div className={styles.b_l_c_container}>
              {userData.favdinner.map((fooditem, index) => {
                return fooditem ? (
                  <Food
                    setUserData={setUserData}
                    key={index}
                    userData={userData}
                    cardcategory={'dinner'}
                    isliked={userData.favdinner.filter((favitem)=>fooditem.Food_id===favitem.Food_id).length>0?true:false}
                    foodObject={{
                      id: fooditem.Food_id,
                      name: fooditem.Food_name,
                      serving: `${fooditem.preferred_serving} ${fooditem.measuring_unit}`,
                      calories: fooditem.food_calories_per_preferred_serving,
                      url: fooditem.image,
                      category: fooditem.category,
                    }}
                  />
                ) : (
                  ""
                );
              })}
            </div>
          </div>}
          
        </div>
      </AnimatedPage>
    </div>
  );
};

export default Favorite;
