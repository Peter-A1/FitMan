import React, { useEffect } from "react";
import { Navigate, useNavigate } from "react-router-dom";
import AnimatedPage from "../../components/animatedPage/AnimatedPage";
import Food from "../../components/food/Food";
import { Nav } from "../../components/nav/Nav";
import styles from "./dietPlan.module.css";
export const DietPlan = ({ currentPage, setcurrentPage, token, userData }) => {
  setcurrentPage("dietplan");
  let navigate = useNavigate();
  useEffect(() => {
    console.log(userData._id);
    if (userData.calories<200) {
      navigate("/");
    }
  });
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
          <div className={styles.breakFast}>
            <h1>BreakFast</h1>
            <Food
              foodObject={{
                name: "egg",
                serving: "one hole egg",
                calories: "200",
              }}
            />
            <Food
              foodObject={{
                name: "oats (raw)",
                serving: "100gram",
                calories: "380",
              }}
            />
            <Food
              foodObject={{
                name: "banana",
                serving: "1piece",
                calories: "100",
              }}
            />
          </div>
          <div className={styles.lunch}>
            <h1>Lunch</h1>
            <Food
              foodObject={{
                name: "rice(cooked)",
                serving: "100gram",
                calories: "130",
              }}
            />{" "}
            <Food
              foodObject={{
                name: "rice(cooked)",
                serving: "100gram",
                calories: "130",
              }}
            />{" "}
            <Food
              foodObject={{
                name: "chicken(breast)",
                serving: "100gram",
                calories: "165",
              }}
            />{" "}
            <Food
              foodObject={{
                name: "mashed potatoes",
                serving: "100gram",
                calories: "88",
              }}
            />
          </div>
          <div className={styles.dinner}>
            <h1>Dinner</h1>
            <Food
              foodObject={{
                name: "brown toast",
                serving: "2 piece",
                calories: "50",
              }}
            />{" "}
            <Food
              foodObject={{ name: "foul", serving: "100gram", calories: "83" }}
            />
          </div>
        </div>
      </AnimatedPage>
    </div>
  );
};

export default DietPlan;
