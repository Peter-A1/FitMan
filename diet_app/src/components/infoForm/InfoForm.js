import React, { useEffect, useState } from "react";
import styles from "./infoForm.module.css";
import * as Apis from "../../api_handller.js";
import { useNavigate } from "react-router-dom";
import { Nav } from "../nav/Nav";
import AnimatedPage2 from "../animatedPage/AnimatedPage2";
// to do re direct to login if not login
export const InfoForm = ({
  IP,
  currentPage,
  token,
  userData,
  setUserData,
  setcurrentPage,
}) => {
  const navigate = useNavigate();

  useEffect(() => {
    if (!token && !userData) {
      navigate("/login");
    }
  });

  const [step, setstep] = useState(0);
  const [info, setinfo] = useState({
    gender: "",
    age: "",
    activity_level: "",
    weight: "",
    height: "",
    goal: "",
  });

  const submitHandller = async (e) => {
    e.preventDefault();
    if (
      info.activity_level &&
      info.age &&
      info.gender &&
      info.goal &&
      info.height &&
      info.weight
    ) {
      const user_data = JSON.parse(localStorage.getItem("userData"));
      await Apis.put(`http://${IP}:5000/${user_data._id}/getstarted`, info)
        .then(async () => {
          const temp_data = await Apis.getData2(
            `http://${IP}:5000/${user_data._id}/userData`
          );
          setUserData(await temp_data);
        })
        .then(() => {
          setcurrentPage("profile");
          navigate("/profile");
          window.location.reload(false);
        });
    } else {
      alert(
        "please make sure you filled out the whole form before submitting "
      );
    }
  };

  const inputHandler = (e) => {
    e.preventDefault();
    const key = e.target.id;
    const value = e.target.value;
    setinfo({ ...info, [key]: value });
    console.log(info);
  };
  const next_step_handller = (e) => {
    e.preventDefault();
    if (step === 4) {
    } else {
      setstep(step + 1);
    }
  };

  const previous_step_handller = (e) => {
    e.preventDefault();
    setstep(step - 1);
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
      <AnimatedPage2>
        <div className={styles.form_body}>
          <div
            className={`${styles.progress_bar} ${
              step === 1 ? styles.one : ""
            } ${step === 2 ? styles.two : ""} ${
              step === 3 ? styles.three : ""
            } ${step === 4 ? styles.four : ""}`}
          ></div>
          <div className={` ${styles.progress_bar_shadow}`}> </div>

          <div
            className={`${styles.step1} ${
              step === 0 ? styles.show1 : styles.hide
            }`}
          >
            <h1>
              Welcome! Let's customize Personal Diet Planner for your goals
            </h1>
            <button onClick={next_step_handller}>CONTINUE</button>
          </div>

          <form onSubmit={submitHandller}>
            <div
              className={`${styles.form_control} ${
                step === 1 ? styles.show2 : styles.hide
              }`}
            >
              <h3>What is your Gender?</h3>
              <div className={styles.options_container}>
                <button
                  className={` ${info.gender === "Male" ? styles.chosen : ""}`}
                  onClick={(e) => {
                    e.preventDefault();
                    setinfo({ ...info, gender: "Male" });
                  }}
                >
                  Male
                </button>
                <button
                  className={` ${
                    info.gender === "Female" ? styles.chosen : ""
                  }`}
                  onClick={(e) => {
                    e.preventDefault();
                    setinfo({ ...info, gender: "Female" });
                  }}
                >
                  Female
                </button>
              </div>
            </div>

            <div className={` ${step === 2 ? styles.show2 : styles.hide}`}>
              <h3>What is your activity level?</h3>
              <div className={`${styles.options_container}`}>
                <button
                  className={` ${
                    info.activity_level === 1.2 ? styles.chosen : ""
                  }`}
                  onClick={(e) => {
                    e.preventDefault();
                    setinfo({ ...info, activity_level: 1.2 });
                  }}
                >
                  Sedentary (Little to no exercise )
                </button>
                <button
                  className={` ${
                    info.activity_level === 1.3 ? styles.chosen : ""
                  }`}
                  onClick={(e) => {
                    e.preventDefault();
                    setinfo({ ...info, activity_level: 1.3 });
                  }}
                >
                  Light exercise (1-3 days per week)
                </button>
                <button
                  className={` ${
                    info.activity_level === 1.5 ? styles.chosen : ""
                  }`}
                  onClick={(e) => {
                    e.preventDefault();
                    setinfo({ ...info, activity_level: 1.5 });
                  }}
                >
                  Moderate exercise (3-5 days per week)
                </button>
                <button
                  className={` ${
                    info.activity_level === 1.7 ? styles.chosen : ""
                  }`}
                  onClick={(e) => {
                    e.preventDefault();
                    setinfo({ ...info, activity_level: 1.7 });
                  }}
                >
                  Heavy exercise (6-7 days per week)
                </button>
                <button
                  className={` ${
                    info.activity_level === 1.9 ? styles.chosen : ""
                  }`}
                  onClick={(e) => {
                    e.preventDefault();
                    setinfo({ ...info, activity_level: 1.9 });
                  }}
                >
                  Very heavy exercise (twice per day, extra heavy workouts)
                </button>
              </div>
            </div>

            <div
              className={`${styles.form_control} ${
                step === 3 ? styles.show2 : styles.hide
              }`}
            >
              <label htmlFor="age">Age</label>
              <input
                required
                type="number"
                id="age"
                name="age"
                value={info.age}
                onChange={inputHandler}
              />
            </div>
            <div
              className={`${styles.form_control} ${
                step === 3 ? styles.show2 : styles.hide
              }`}
            >
              <label htmlFor="weight">Weight (KG)</label>
              <input
                required
                type="number"
                id="weight"
                name="weight"
                value={info.weight}
                onChange={inputHandler}
              />
            </div>

            <div
              className={`${styles.form_control} ${
                step === 3 ? styles.show2 : styles.hide
              }`}
            >
              <label htmlFor="height">Height (CM)</label>
              <input
                required
                type="number"
                id="height"
                name="height"
                value={info.height}
                onChange={inputHandler}
              />
            </div>

            <div className={` ${step === 4 ? styles.show2 : styles.hide}`}>
              <h3>What is your goal?</h3>
              <div className={styles.options_container}>
                <button
                  className={` ${info.goal === 1 ? styles.chosen : ""}`}
                  onClick={(e) => {
                    e.preventDefault();
                    setinfo({ ...info, goal: 1 });
                  }}
                >
                  Lose weight
                </button>
                <button
                  className={` ${info.goal === 2 ? styles.chosen : ""}`}
                  onClick={(e) => {
                    e.preventDefault();
                    setinfo({ ...info, goal: 2 });
                  }}
                >
                  Gain Weight
                </button>
              </div>
            </div>

            <div className={styles.buttons_container}>
              <button
                className={`${styles.btn} ${styles.pbtn} ${
                  step !== 0 ? styles.show2 : styles.hide
                }`}
                onClick={previous_step_handller}
              >
                BACK
              </button>
              <button
                type={step === 4 ? "submit" : ""}
                className={`${styles.btn} ${styles.nbtn} ${
                  step !== 0 ? styles.show2 : styles.hide
                }`}
                onClick={step === 4 ? submitHandller : next_step_handller}
              >
                {step === 4 ? "SUBMIT" : " NEXT"}
              </button>
            </div>
          </form>
        </div>
      </AnimatedPage2>
    </div>
  );
};

export default InfoForm;
