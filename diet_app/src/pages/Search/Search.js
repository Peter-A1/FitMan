import React, { useState } from "react";
import styles from "./search.module.css";
import { Nav } from "../../components/nav/Nav";
import Food from "../../components/food/Food";
import AnimatedPage from "../../components/animatedPage/AnimatedPage";
import * as Apis from "../../api_handller.js";
import SmallFoodCard from "./SmallFoodCard/SmallFoodCard";
import { Result } from "./Result/Result";
const Search = ({
  currentPage,
  setcurrentPage,
  token,
  userData,
  setUserData,
  IP,
}) => {
  setcurrentPage("search");
  const [input, setinput] = useState("");
  const [searchResult, setsearchResult] = useState([]);
  const [searchCategory, setsearchCategory] = useState("breakfast");

  const inputHandller = async (e) => {
    e.preventDefault();
    setinput(e.target.value);
    const result = await Apis.getData2(
      `http://localhost:5000/search/${e.target.value}`
    );
    // console.log(e.target.value)
    // console.log('--------------')
    // console.log(await result)
    setsearchResult(await result);
  };
  const changeSearchCategory_to_breakfast_Handller = () => {
    setsearchCategory("breakfast");
    setinput("");
    setsearchResult([]);
  };
  const changeSearchCategory_to_lunch_Handller = () => {
    setsearchCategory("lunch");
    setinput("");
    setsearchResult([]);
  };
  const changeSearchCategory_to_dinner_Handller = () => {
    setsearchCategory("dinner");
    setinput("");
    setsearchResult([]);
  };

  return (
    <div className={styles.container}>
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
        <div className={styles.pageBody}>
          <div className={styles.mainContent}>
            <h2>start adding your favorite food now !</h2>
            <div className={styles.formController}>
              {" "}
              <input
                autoFocus
                required
                className={styles.search_bar}
                value={input}
                placeholder="Search For Food..."
                type="text"
                onChange={inputHandller}
              ></input>
              <i className="fa-solid fa-magnifying-glass"></i>
            </div>
           {userData?<div> <h2 className={styles.text1}>where would you like to add your food to?</h2>
            <div className={styles.btns_container}>
              <button
                className={`${styles.btn} ${
                  searchCategory === "breakfast" ? styles.chosen : ""
                }`}
                onClick={changeSearchCategory_to_breakfast_Handller}
              >
                breakfast
              </button>
              <button
                className={`${styles.btn} ${
                  searchCategory === "lunch" ? styles.chosen : ""
                }`}
                onClick={changeSearchCategory_to_lunch_Handller}
              >
                lunch
              </button>
              <button
                className={`${styles.btn} ${
                  searchCategory === "dinner" ? styles.chosen : ""
                }`}
                onClick={changeSearchCategory_to_dinner_Handller}
              >
                dinner
              </button>
            </div></div>:''}
            <p className={styles.note}>
              note make sure you are logged in so you can add or remove food
            </p>
            <div className={styles.search_Result_Container}>
              {searchResult?searchResult.length > 0 ? (
                <Result
                  searchResult={searchResult}
                  searchCategory={searchCategory}
                  userData={userData}
                  setUserData={setUserData}
                />
              ) : (
                ""
              ):""}
            </div>
          </div>
         {userData? <div className={styles.rSlider}>
            {searchCategory === "breakfast" ? (
              <h3 className={styles.favheadder}>
                your favorite breakfast food
              </h3>
            ) : (
              ""
            )}
            {searchCategory === "breakfast"
              ? userData
                ? userData.favbreakfast.map((fooditem, idx) => (
                    <SmallFoodCard
                      key={idx}
                      userData={userData}
                      foodcategory={searchCategory}
                      imageurl={fooditem.image}
                      name={fooditem.Food_name}
                      id={fooditem.Food_id}
                      setUserData={setUserData}
                    />
                  ))
                : ""
              : ""}

            {searchCategory === "lunch" ? (
              <h3 className={styles.favheadder}>your favorite lunch food</h3>
            ) : (
              ""
            )}
            {searchCategory === "lunch"
              ? userData
                ? userData.favlunch.map((fooditem, idx) => (
                    <SmallFoodCard
                      key={idx}
                      userData={userData}
                      foodcategory={searchCategory}
                      imageurl={fooditem.image}
                      name={fooditem.Food_name}
                      id={fooditem.Food_id}
                      setUserData={setUserData}
                    />
                  ))
                : ""
              : ""}

            {searchCategory === "dinner" ? (
              <h3 className={styles.favheadder}>your favorite dinner food</h3>
            ) : (
              ""
            )}
            {searchCategory === "dinner"
              ? userData
                ? userData.favdinner.map((fooditem, idx) => (
                    <SmallFoodCard
                      key={idx}
                      userData={userData}
                      foodcategory={searchCategory}
                      imageurl={fooditem.image}
                      name={fooditem.Food_name}
                      id={fooditem.Food_id}
                      setUserData={setUserData}
                    />
                  ))
                : ""
              : ""}
          </div>:""}
        </div>
      </AnimatedPage>
    </div>
  );
};

export default Search;
