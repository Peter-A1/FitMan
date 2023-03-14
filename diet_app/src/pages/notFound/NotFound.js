import React from "react";
import { Link } from "react-router-dom";

export const NotFound = () => {
  return (
    <div style={{ textAlign: "center" }}>
      <i
        style={{
          width: "200px",
          height: "200px",
          color: "#00ADB5",
          fontSize: "200px",
        }}
        className="fa-sharp fa-solid fa-triangle-exclamation"
      ></i>
      <h1>Oops! You seem to be lost.</h1>
      <p>back home?</p>
      <Link to="/">Home</Link>
    </div>
  );
};

export default NotFound;
