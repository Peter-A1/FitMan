import styles from "./RegisterForm.module.css";
import React, { useEffect, useState } from "react";
import * as Apis from "../../api_handller.js";
import { Link, useNavigate } from "react-router-dom";
import { Nav } from "../nav/Nav";
import AnimatedPage2 from "../animatedPage/AnimatedPage2";

export const RegisterForm = ({ IP, currentPage, token, userData }) => {
  let navigate = useNavigate();
  useEffect(() => {
    if (token && userData) {
      navigate("/");
    }
  });
  const [RegisterData, setRegisterData] = useState({
    name: "",
    email: "",
    password: "",
    password2: "",
  });

  const [Errors, setErrors] = useState({
    name: "",
    email: "",
    password: "",
    password2: "",
  });

  const [showPass1, setshowPass1] = useState(false);
  const [showPass2, setshowPass2] = useState(false);

  const inputHandler = (e) => {
    const key = e.target.id;
    const value = e.target.value;
    setRegisterData({ ...RegisterData, [key]: value });
  };

  const submitHandler = async (e) => {
    e.preventDefault();
    //console.log(RegisterData); // debug line
    if (RegisterData.password === RegisterData.password2) {
      if (check_strong_pass()) {
        const res = Apis.postData(`http://${IP}:5000/register`, RegisterData);
        handel_err_success(await res);
      } else {
        setErrors({
          password:
            "your passsword should contain Minimum eight characters, at least one letter and one number",
        });
      }
    } else {
      setErrors({
        password2: "the two passwords you entered does't match",
      });
    }
  };

  const check_strong_pass = () => {
    const strong_pass_regex = new RegExp(
      /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/
    );
    if (strong_pass_regex.test(RegisterData.password)) return true;
    else return false;
  };

  const handel_err_success = (res) => {
    if (res.hasOwnProperty("errors")) {
      setErrors({ ...res.errors });
      // console.log("registration in failed");
    } else {
      // console.log("registration in succss!");
      navigate("/login");
      window.location.reload(false);
    }
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
        <div className={styles.Form_container}>
          <div className={styles.header_container}>
            <i className="fa-solid fa-user"></i>
            <h2>Create account!</h2>
          </div>

          <form onSubmit={submitHandler}>
            <div className={styles.form_control}>
              <label htmlFor="name">
                Name <p className={styles.err}>{Errors.name}</p>
              </label>
              <input
                required
                type="text"
                id="name"
                name="name"
                value={RegisterData.name}
                onChange={inputHandler}
              />
              <i className="fa-solid fa-user"></i>
            </div>

            <div className={styles.form_control}>
              <label htmlFor="email">
                Email <p className={styles.err}>{Errors.email}</p>
              </label>
              <input
                required
                type="email"
                id="email"
                name="email"
                value={RegisterData.email}
                onChange={inputHandler}
              />
              <i className="fa-solid fa-envelope"></i>
            </div>

            <div className={styles.form_control}>
              <label htmlFor="password">
                Password <p className={styles.err}>{Errors.password}</p>
              </label>
              <input
                required
                type={showPass1 ? "text" : "password"}
                id="password"
                name="password"
                value={RegisterData.password}
                onChange={inputHandler}
              />
              <i
                onClick={() => {
                  setshowPass1(!showPass1);
                }}
                className={`${styles.pass} ${
                  showPass1
                    ? "fa-sharp fa-regular fa-eye-slash"
                    : "fa-solid fa-eye"
                }`}
              ></i>
            </div>

            <div className={styles.form_control}>
              <label htmlFor="password2">
                ConfirmPassword <p className={styles.err}>{Errors.password2}</p>
              </label>
              <input
                required
                type={showPass2 ? "text" : "password"}
                id="password2"
                name="password2"
                value={RegisterData.password2}
                onChange={inputHandler}
              />
              <i
                onClick={() => {
                  setshowPass2(!showPass2);
                }}
                className={`${styles.pass} ${
                  showPass2
                    ? "fa-sharp fa-regular fa-eye-slash"
                    : "fa-solid fa-eye"
                }`}
              ></i>
            </div>
            <span className={styles.login_now}>
              already a member?
              <br />
              <Link to={"/login"}>login now</Link>
            </span>
            <button className={styles.button} type="submit">
              Create <i className="fa-sharp fa-solid fa-arrow-right"></i>
            </button>
          </form>
        </div>
      </AnimatedPage2>
    </div>
  );
};
export default RegisterForm;
