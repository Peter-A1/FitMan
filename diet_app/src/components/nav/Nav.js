import styles from "./nav.module.css";
import React from "react";
import { Link, useNavigate } from "react-router-dom";
import * as Apis from "../../api_handller.js";

export const Nav = ({ currentPage, token, userData }) => {
  let navigate = useNavigate();

  const logoutHandller = () => {
    localStorage.setItem("token", "");
    localStorage.setItem("userData", "");
    Apis.getData("http://localhost:5000/logout");
    navigate("/");
    window.location.reload(false);
  };
  const logout_btn = <button onClick={logoutHandller}>Logout</button>;
  return (
    <div className={styles.nav_body}>
      <Link
        to="/"
        className={`${styles.navLink} ${
          currentPage === "home" ? `${styles.active}` : ""
        }`}
      >
        Home
      </Link>

      {userData ? (
        <Link
          to="/profile"
          className={`${styles.navLink} ${
            currentPage === "profile" ? `${styles.active}` : ""
          }`}
        >
          {userData.name}
        </Link>
      ) : (
        ""
      )}
      {currentPage === "home" ? (
        <a className={styles.navLink} href="#faq">
          Faq
        </a>
      ) : (
        ""
      )}
      <div className={styles.getstarted}>
        {userData ? (
          <Link className={styles.login_logout} to="/profile">
            {logout_btn}
          </Link>
        ) : (
          <Link className={styles.login_logout} to="/profile">
            Login
          </Link>
        )}
      </div>
    </div>
  );
};
