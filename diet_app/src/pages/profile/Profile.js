import { React, useEffect } from "react";
import styles from "./profile.module.css";
import { Link, useNavigate } from "react-router-dom";
import { Nav } from "../../components/nav/Nav";
import AnimatedPage from "../../components/animatedPage/AnimatedPage";
import Food from "../../components/food/Food";

export const Profile = ({ currentPage, setcurrentPage, token, userData }) => {
  setcurrentPage("profile");
  let navigate = useNavigate();

  useEffect(() => {
    console.log(userData._id);
    if (!token && !userData) {
      navigate("/login");
    }
  });

  const calculate_calories = () => {
    let calories = 0;
    //caluclating calories algorithm
    if (userData.gender == "Male") {
      var bmr =
        655.1 +
        9.563 * userData.weight +
        1.85 * userData.height -
        4.676 * userData.age;
    } else {
      var bmr =
        66.47 +
        13.75 * userData.weight +
        5.003 * userData.height -
        6.755 * userData.age;
    }
    var rawcal = bmr * userData.activity_level;
    if (userData.goal == "1") {
       calories = rawcal - 500;
    } else if (userData.goal == "2") {
       calories = rawcal + 500;
    }
    return calories;
  };


  return (
    <div className={styles.test}>
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
        <div className={styles.profile_container}>
          <div className={styles.left}>
            <img src="https://picsum.photos/200/200" alt="" />
            <Link to={'/dietPlan'}><button>Get your diet plan</button></Link>
            <div className={styles.edit}>
              <i class="fa-solid fa-pen-to-square"></i>
              <p>Edit</p>
            </div>
          </div>

          <div className={styles.right}>
            <h1>My Profile</h1>

            <div className={styles.row}>
              <div className={styles.field}>
                <span>NAME</span>
                <div className={styles.value_container}>{userData.name}</div>
              </div>
              <div className={styles.field}>
                <span>AGE</span>
                <div className={styles.value_container}>{userData.age}</div>
              </div>
            </div>

            <div className={styles.row}>
              <div className={styles.field}>
                <span>HEIGHT (CM)</span>
                <div className={styles.value_container}>{userData.height}</div>
              </div>

              <div className={styles.field}>
                <span>WEIGHT (KG)</span>
                <div className={styles.value_container}>{userData.weight}</div>
              </div>
            </div>
            <div className={styles.row}>
              <div className={styles.field}>
                <span>GENDER</span>
                <div className={styles.value_container}>{userData.gender}</div>
              </div>
              <div className={styles.field}>
                <span>EMAIL</span>
                <div className={styles.value_container}>{userData.email}</div>
              </div>
            </div>

            <h1>Nutrition Data</h1>

            <div className={styles.row}>
              <div className={styles.field}>
                <span>CALORIES</span>
                <div className={styles.value_container}>
                  {Math.round(calculate_calories())}
                </div>
              </div>

              <div className={styles.field}>
                <span>GOAL</span>
                <div className={styles.value_container}>
                  {userData.goal === 1 ? "Lose weight" : "Gain weight"}
                </div>
              </div>
            </div>
          </div>
        </div>
      </AnimatedPage>
    </div>
  );
};

export default Profile;
