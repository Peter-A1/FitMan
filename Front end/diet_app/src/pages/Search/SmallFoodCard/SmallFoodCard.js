import React from 'react';
import styles from "./SmallFoodCard.module.css";
import * as Apis from "../../../api_handller"

const SmallFoodCard = ({foodcategory,imageurl,name,id,setUserData,userData}) => {
    const removeHnadller= async()=>{
        if (foodcategory === "breakfast") {
            const temp_userInfo = await Apis.put(
              `http://localhost:5000/${userData._id}/removefood`,
              {
                breakfast: id,
              }
            );
            setUserData(temp_userInfo); //set and update the data in the local storage
            // setuserInfo(temp_userInfo); 
          } else if (foodcategory === "lunch") {
            const temp_userInfo = await Apis.put(
              `http://localhost:5000/${userData._id}/removefood`,
              {
                lunch: id,
              }
            );
            setUserData(temp_userInfo);
            // setuserInfo(temp_userInfo);
          } else if (foodcategory === "dinner") {
            const temp_userInfo = await Apis.put(
              `http://localhost:5000/${userData._id}/removefood`,
              {
                dinner: id,
              }
            );
            setUserData(temp_userInfo);
            // setuserInfo(temp_userInfo);
          } else {
            console.log("something went wrong");
          }
    }
    return (
        <div className={styles.card}>
            <img src={imageurl} alt="food" />
            <div className={styles.name}>{name}</div>
            <button onClick={removeHnadller} className={styles.removeBtn}>remove</button>
        </div>
    );
}

export default SmallFoodCard;
