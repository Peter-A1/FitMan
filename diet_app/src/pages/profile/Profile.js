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
                  {Math.round(userData.calories>10?userData.calories:'')}
                </div>
              </div>

              <div className={styles.field}>
                <span>GOAL</span>
                <div className={styles.value_container}>
                {console.log(userData.goal)}
                  {userData.goal === 1 ? "Lose weight": userData.goal === 2 ? "Gain weight" : ""}
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
