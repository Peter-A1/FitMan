import React, { useState } from "react";
import styles from "./food.module.css";
import * as Apis from "../../api_handller.js";

export const Food = ({
  userData,
  setUserData,
  foodObject,
  cardcategory,
  isliked,
}) => {
  const [userInfo, setuserInfo] = useState(userData); //for re rendernig
  const [isLiked, setisLiked] = useState(isliked);
  const [cardCategory, setcardCategory] = useState(cardcategory);
  const likeClickHandller = async () => {
    if (cardCategory === "breakfast") {
      const temp_userInfo = await Apis.put(
        `http://localhost:5000/${userData._id}/pickfood`,
        {
          breakfast: [foodObject.id],
          lunch: [],
          dinner: [],
        }
      );
      console.log(await temp_userInfo);
      setisLiked(true);
      setUserData(temp_userInfo); //set and update the data in the local storage
      setuserInfo(temp_userInfo); // set and update user data in state to triger re render
    } else if (cardCategory === "lunch") {
      const temp_userInfo = await Apis.put(
        `http://localhost:5000/${userData._id}/pickfood`,
        {
          breakfast: [],
          lunch: [foodObject.id],
          dinner: [],
        }
      );
      console.log(await temp_userInfo);
      setisLiked(true);
      setUserData(temp_userInfo);
      setuserInfo(temp_userInfo);
    } else if (cardCategory === "dinner") {
      const temp_userInfo = await Apis.put(
        `http://localhost:5000/${userData._id}/pickfood`,
        {
          breakfast: [],
          lunch: [],
          dinner: [foodObject.id],
        }
      );
      console.log(await temp_userInfo);
      setisLiked(true);
      setUserData(temp_userInfo);
      setuserInfo(temp_userInfo);
    } else {
      console.log("something went wrong");
    }
  };

  const dislikeClickHandller = async () => {
    if (cardCategory === "breakfast") {
      const temp_userInfo = await Apis.put(
        `http://localhost:5000/${userData._id}/removefood`,
        {
          breakfast: foodObject.id,
        }
      );
      console.log(await temp_userInfo);
      setisLiked(false);
      setUserData(temp_userInfo); //set and update the data in the local storage
      setuserInfo(temp_userInfo); // set and update user data in state to triger re render
    } else if (cardCategory === "lunch") {
      const temp_userInfo = await Apis.put(
        `http://localhost:5000/${userData._id}/removefood`,
        {
          lunch: foodObject.id,
        }
      );
      console.log(await temp_userInfo);
      setisLiked(false);
      setUserData(temp_userInfo);
      setuserInfo(temp_userInfo);
    } else if (cardCategory === "dinner") {
      const temp_userInfo = await Apis.put(
        `http://localhost:5000/${userData._id}/removefood`,
        {
          dinner: foodObject.id,
        }
      );
      console.log(await temp_userInfo);
      setisLiked(false);
      setUserData(temp_userInfo);
      setuserInfo(temp_userInfo);
    } else {
      console.log("something went wrong");
    }
  };
  return (
    <div className={styles.food_container}>
      <img src={`${foodObject.url}`} alt="" />
      <p className={styles.name_text}>{foodObject.name}</p>
      <p className={styles.serving_text}>serving: {foodObject.serving}</p>
      {/* <p className={styles.category_text}>category: {cardCategory.category}</p> */}
      <p className={styles.calories_text}> calories {foodObject.calories}</p>

      {userData ?  cardCategory === "breakfast"?(
        <div>
          {" "}
          {
            userData.favbreakfast.filter(
              (favitem) => foodObject.id === favitem.Food_id
            ).length >0?(
              <div
                className={styles.like_container}
                onClick={dislikeClickHandller}
              >
                <div className={styles.like_text}>Delete</div>
                <i className="fa-solid fa-heart"></i>
              </div>
            
          ) : (
            <div className={styles.like_container} onClick={likeClickHandller}>
              <div className={styles.like_text}>Add</div>
              <i className="fa-regular fa-heart"></i>
            </div>
          )}
        </div>
      ):cardCategory === "lunch"?(
        <div>
          {" "}
          {
            userData.favlunch.filter(
              (favitem) => foodObject.id === favitem.Food_id
            ).length >0?(
              <div
                className={styles.like_container}
                onClick={dislikeClickHandller}
              >
                <div className={styles.like_text}>Delete</div>
                <i className="fa-solid fa-heart"></i>
              </div>
            
          ) : (
            <div className={styles.like_container} onClick={likeClickHandller}>
              <div className={styles.like_text}>Add</div>
              <i className="fa-regular fa-heart"></i>
            </div>
          )}
        </div>
      ):cardCategory === "dinner"?(
        <div>
          {" "}
          {
            userData.favdinner.filter(
              (favitem) => foodObject.id === favitem.Food_id
            ).length >0?(
              <div
                className={styles.like_container}
                onClick={dislikeClickHandller}
              >
                <div className={styles.like_text}>Delete</div>
                <i className="fa-solid fa-heart"></i>
              </div>
            
          ) : (
            <div className={styles.like_container} onClick={likeClickHandller}>
              <div className={styles.like_text}>Add</div>
              <i className="fa-regular fa-heart"></i>
            </div>
          )}
        </div>
      ):``
       : (
        ""
      )}
    </div>
  );
};

export default Food;
