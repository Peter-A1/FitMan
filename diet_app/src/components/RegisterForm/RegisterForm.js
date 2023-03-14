import styles from "./RegisterForm.module.css";
import React, { useEffect, useState } from "react";
import * as Apis from "../../api_handller.js";
import { Link, useNavigate } from "react-router-dom";

export const RegisterForm = ({ token, userData }) => {
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
        const res = Apis.postData(
          "http://localhost:5000/register",
          RegisterData
        );
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
            type="password"
            id="password"
            name="password"
            value={RegisterData.password}
            onChange={inputHandler}
          />
          <i className="fa-solid fa-lock"></i>
        </div>

        <div className={styles.form_control}>
          <label htmlFor="password2">
            ConfirmPassword <p className={styles.err}>{Errors.password2}</p>
          </label>
          <input
            required
            type="password"
            id="password2"
            name="password2"
            value={RegisterData.password2}
            onChange={inputHandler}
          />
          <i className="fa-solid fa-lock"></i>
        </div>
        <span className={styles.login_now}>
          already a member?
          <Link to={"/login"}>login now</Link>
        </span>
        <button className={styles.button} type="submit">
          Create <i className="fa-sharp fa-solid fa-arrow-right"></i>
        </button>
      </form>
    </div>
  );
};
export default RegisterForm;
