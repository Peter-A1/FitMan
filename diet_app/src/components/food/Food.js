import React from "react";
import styles from "./food.module.css";

export const Food = ({ foodObject }) => {
  return (
    <div className={styles.food_container}>
      <img src="https://picsum.photos/100/100" alt="" />
      <p className={styles.name_text}>{foodObject.name}</p>
      <p className={styles.serving_text}>serving: {foodObject.serving}</p>
      <p className={styles.calories_text}> calories {foodObject.calories}</p>
    </div>
  );
};

export default Food;
