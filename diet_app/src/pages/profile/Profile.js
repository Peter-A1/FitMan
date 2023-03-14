import { React, useEffect } from "react";
import styles from "./profile.module.css";
import { useNavigate } from "react-router-dom";
import { Nav } from "../../components/nav/Nav";

export const Profile = ({ currentPage,setcurrentPage, token, userData }) => {
  setcurrentPage('profile')
  let navigate = useNavigate();

  useEffect(() => {
    if (!token && !userData) {
      navigate("/login");
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
      <div>Profile</div>
      <p>name: {userData.name}</p>
      <p>email: {userData.email}</p>
    </div>
  );
};

export default Profile;
