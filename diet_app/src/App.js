import "./App.module.css";
import LoginForm from "./components/LoginForm/LoginForm";
import RegisterForm from "./components/RegisterForm/RegisterForm";
import { Home } from "./pages/Home/Home";
import { Route, Routes } from "react-router-dom";
import NotFound from "./pages/notFound/NotFound";
import { Profile } from "./pages/profile/Profile";
import * as Apis from "./api_handller";
import { useState } from "react";
import InfoForm from "./components/infoForm/InfoForm";

function App() {
  const [currentPage, setcurrentPage] = useState("");

  //clearing the token and user data after 30 min
  setTimeout(() => {
    localStorage.setItem("token", "");
    localStorage.setItem("userData", "");
    Apis.getData("http://localhost:5000/logout"); // test later
  }, 1000 * 60 * 30);

  const setToken = (received_token) => {
    localStorage.setItem("token", received_token);
  };
  const setUserData = async (received_user_data) => {
    localStorage.setItem("userData", JSON.stringify(received_user_data));
  };
  return (
    <div>
      <Routes>
        <Route
          exact
          path="/"
          element={
            <Home currentPage={currentPage} setcurrentPage={setcurrentPage} />
          }
        />
        <Route
          exact
          path="profile"
          element={
            <Profile
              currentPage={currentPage}
              setcurrentPage={setcurrentPage}
              token={localStorage.getItem("token")}
              userData={
                localStorage.getItem("userData")
                  ? JSON.parse(localStorage.getItem("userData"))
                  : ""
              }
            />
          }
        />
        <Route
          exact
          path="login"
          element={
            <LoginForm
              currentPage={currentPage}
              setcurrentPage={setcurrentPage}
              setToken={setToken}
              setUserData={setUserData}
              token={localStorage.getItem("token")}
              userData={
                localStorage.getItem("userData")
                  ? JSON.parse(localStorage.getItem("userData"))
                  : ""
              }
            />
          }
        />
        <Route
          exact
          path="register"
          element={
            <RegisterForm
              currentPage={currentPage}
              setcurrentPage={setcurrentPage}
              token={localStorage.getItem("token")}
              userData={
                localStorage.getItem("userData")
                  ? JSON.parse(localStorage.getItem("userData"))
                  : ""
              }
            />
          }
        />
        <Route path="*" element={<NotFound />} />
        <Route path="infoForm" element={<InfoForm />} />
      </Routes>
    </div>
  );
}

export default App;
