import styles from "./nav.module.css";
import React, { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import * as Apis from "../../api_handller.js";
import { animateScroll as scroll } from "react-scroll";

export const Nav = ({ currentPage, token, userData }) => {
  let navigate = useNavigate();

  const [show_nav_on_mobile, setshow_nav_on_mobile] = useState(false);

  const logoutHandller = () => {
    localStorage.setItem("token", "");
    localStorage.setItem("userData", "");
    Apis.getData("http://localhost:5000/logout");
    navigate("/");
    window.location.reload(false);
  };
  const logout_btn = <button onClick={logoutHandller}>Logout</button>;
  return (
    <div
      className={`${styles.nav_body} ${
        show_nav_on_mobile ? styles.expand : ""
      }`}
    >
      <i
        className={`${
          show_nav_on_mobile ? "fa-solid fa-xmark" : "fa-solid fa-bars"
        } ${styles.expand_icon}`}
        onClick={() => {
          setshow_nav_on_mobile(!show_nav_on_mobile);
        }}
      ></i>

      <Link
        to="/"
        className={`${styles.navLink} ${
          currentPage === "home" ? `${styles.active}` : ""
        } ${show_nav_on_mobile ? styles.show : ""}`}
      >
        Home
      </Link>

      {userData ? (
        <Link
          to="/profile"
          className={`${styles.navLink} ${
            currentPage === "profile" ? `${styles.active}` : ""
          } ${show_nav_on_mobile ? styles.show : ""}`}
        >
          {userData.name}
        </Link>
      ) : (
        ""
      )}

        {userData?<Link
          to="/dietplan"
          className={`${styles.navLink} ${
            currentPage === "dietplan" ? `${styles.active}` : ""
          } ${show_nav_on_mobile ? styles.show : ""}`}
        >
         Diet Plan
        </Link>:''}
      

      {userData ? (
        <Link
          to="/favorite"
          className={`${styles.navLink} ${
            currentPage === "favorite" ? `${styles.active}` : ""
          } ${show_nav_on_mobile ? styles.show : ""}`}
        >
          My Favorite Food
        </Link>
      ) : (
        ""
      )}

      
        <Link
          to="/search"
          className={`${styles.navLink} ${
            currentPage === "search" ? `${styles.active}` : ""
          } ${show_nav_on_mobile ? styles.show : ""}`}
        >
         Search
        </Link>
   

      {/* {currentPage === "home" ? (
        <a
          className={`${styles.small_navLink} ${styles.navLink} ${
            show_nav_on_mobile ? styles.show : ""
          }`}
          href="#section1"
        >
          section 1
        </a>
        
      ) : (
        ""
      )}
   
      {currentPage === "home" ? (
        <a
          className={`${styles.small_navLink} ${styles.navLink} ${
            show_nav_on_mobile ? styles.show : ""
          }`}
          href="#section3"
        >
          section 2
        </a>
        
      ) : (
        ""
      )}

      {currentPage === "home" ? (
        <a
          className={` ${styles.small_navLink} ${styles.navLink} ${
            show_nav_on_mobile ? styles.show : ""
          }`}
          href="#section4"
        >
          section 3
        </a>
        
      ) : (
        ""
      )}

      {currentPage === "home" ? (
        <a
          className={`${styles.small_navLink} ${styles.navLink} ${
            show_nav_on_mobile ? styles.show : ""
          }`}
          href="#faq"
        >
          Faq
        </a>
        
      ) : (
        ""
      )} */}

      {/* {currentPage === "home" ? (
        <a
          className={`${styles.small_navLink} ${styles.navLink} ${
            show_nav_on_mobile ? styles.show : ""
          }`}
          href="#about"
        >
          about
        </a>
        
      ) : (
        ""
      )} */}

      <div className={styles.getstarted}>
        {userData ? (
          <Link
            className={`${styles.login_logout} ${
              show_nav_on_mobile ? styles.show : ""
            }`}
            to="/profile"
          >
            {logout_btn}
          </Link>
        ) : (
          <Link
            className={`${styles.login_logout} ${
              show_nav_on_mobile ? styles.show : ""
            }`}
            to="/profile"
          >
            Login
          </Link>
        )}
      </div>
    </div>
  );
};
