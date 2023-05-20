import styles from "./LoginForm.module.css";
import "font-awesome/css/font-awesome.min.css";
import React, { useEffect, useState } from "react";
import * as Apis from "../../api_handller.js";
import { Link, useNavigate } from "react-router-dom";
import { Nav } from "../nav/Nav";
import AnimatedPage2 from "../animatedPage/AnimatedPage2";

export const LoginForm = ({
  IP,
  currentPage,
  setToken,
  setUserData,
  token,
  userData,
}) => {
  let navigate = useNavigate();
  useEffect(() => {
    if (token && userData) {
      navigate("/");
    }
  });

  const [LoginData, setLoginData] = useState({ email: "", password: "" });
  const [Errors, setErrors] = useState({ email_err: "", password_err: "" });
  const [showPass, setshowPass] = useState(false);

  const inputHandler = (e) => {
    const key = e.target.id;
    const value = e.target.value;
    setLoginData({ ...LoginData, [key]: value });
  };

  const submitHandler = async (e) => {
    e.preventDefault();
    const res = await Apis.login_post(`http://${IP}:5000/login`, LoginData);
    if (typeof res === "undefined") {
      alert(
        "there is something wrong with the back end or the ip configuration"
      );
    } else {
      handel_tokken_and_userData(await res);
    }
  };

  const handel_tokken_and_userData = (res) => {
    // console.log(res.errors.email);
    if (res.hasOwnProperty("errors")) {
      // console.log("log in failed");
      handel_errors_state(res.errors);
    } else {
      // console.log("log in succss!");
      setUserData(res);
      setToken(res.token);
      window.location.reload(false);
      navigate("/");
    }
  };

  const handel_errors_state = (err) => {
    if (err.email === "That email is not registered") {
      setErrors({ email_err: err.email, password_err: "" });
    } else if (err.password === "That password is not correct") {
      setErrors({ email_err: "", password_err: err.password });
    } else {
      alert("something went wrong please try again later");
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
            <i className="fa-solid fa-right-to-bracket"></i>
            <h2>Welcome!</h2>
            <span>Sign in to your account</span>
          </div>

          <form onSubmit={submitHandler}>
            <div className={styles.form_control}>
              <label htmlFor="email">
                Email <p className={styles.err}>{Errors.email_err}</p>{" "}
              </label>
              <input
                required
                type="email"
                id="email"
                name="email"
                value={LoginData.email}
                onChange={inputHandler}
              />
              <i className="fa-solid fa-user"></i>
            </div>

            <div className={styles.form_control}>
              <label htmlFor="password">
                Password <p className={styles.err}>{Errors.password_err}</p>
              </label>
              <input
                required
                type={showPass ? "text" : "password"}
                id="password"
                name="password"
                value={LoginData.password}
                onChange={inputHandler}
              />
              <i
                onClick={() => {
                  setshowPass(!showPass);
                }}
                className={`${styles.pass} ${
                  showPass
                    ? "fa-sharp fa-regular fa-eye-slash"
                    : "fa-solid fa-eye"
                }`}
              ></i>
            </div>

            <span className={styles.forgetpass}>
              <span>don't have an account?</span> <br />
              <Link to={"/register"}> register now!</Link>
              <br />
            </span>
            <button className={styles.button} type="submit">
              Login <i className="fa-sharp fa-solid fa-arrow-right"></i>
            </button>
          </form>
        </div>
      </AnimatedPage2>
    </div>
  );
};

export default LoginForm;
