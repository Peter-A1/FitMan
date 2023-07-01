import React, { useState } from "react";
import { Link } from "react-router-dom";
import { Nav } from "../../components/nav/Nav";
import styles from "./home.module.css";
import * as Apis from "../../api_handller";
import AnimatedPage from "../../components/animatedPage/AnimatedPage";
export const Home = ({ IP, token, userData, currentPage, setcurrentPage }) => {
  setcurrentPage("home");
  const [active_qs, setactive_qs] = useState([false, false, false, false]);
  const QA = [
    {
      q: "How does the meal planner work?",
      a: "Each diet plan selected can be customised according to things such as your personal statistics, current physical condition, activity levels and whether you want to lose fat, stay in shape, or gain muscle. It can be personalised to whether you are a vegan or not, if you have any allergies such as gluten, also including the option for halal and kosher recipes only. You can even tell the planner that you prefer to only drink smoothies in the morning. Once your diet plan is set up, the meal planner automatically finds recipes to match the diet plan criteria. Have a look at the suggested recipes that are produced for you automatically and adjust until you get what is right for you.",
    },
    {
      q: "Will I need to update my diet meal plan often?",
      a: "This depends mainly on how fast your weight loss is. If you notice that your weight loss has started to stall you made need to set up a new plan with a lower calorie requirement (or increase your daily activity instead and stick with the same plan).",
    },
    {
      q: "How many meals a day should I eat?",
      a: "We suggest that you eat the number of meals that you are comfortable eating and that fits into your daily schedule. Normally, we recommended 3 meals a day and a healthy snack or two. If you are an athlete it may be worth paying a bit more attention to the timing of your nutrition before and after training sessions.",
    },
    {
      q: "How much exercise should I do?",
      a: "To lose weight you don’t necessarily have to go to the gym but we would recommend at least trying to be more active during the day and increasing the amount of walking you do. Best results tend to come from people who also undertake a basic weight training and cardiovascular exercise programme. The main point to take away here though is that you don’t need to exercise excessively to get results!",
    },
  ];

  const section3_ps = [
    "We take the hard work out of setting up your nutritional targets but in some cases you may want to make some adjustments.Once your diet is set up you may edit the nutritional targets for each individual day.Adjust a huge amount of criteria from calories, protein, fats, carbohydrates, sugar, fibre and much more.",
    "Does your meal plan need to be Vegan, Gluten-free, Halal or is subject to any other form of dietary restriction?When setting up your meal plan you can program the meal planner to only find foods suitable for your personal needs.",
    "Would you rather have your breakfast to be a meal replacement drink because you don’t have much time in the morning?You can adapt our recipe finder settings to ensure that we find the most appropriate recipes.",
  ];
  const section4_ps = [
    "This is where we make things much easier for you...Calorie counting or setting yourself any other nutritional targets is no use if you don’t know what to eat.Our meal planner takes this issue away by doing all the calculations for you and provides you with a full week’s worth of recipes tailored to both your nutritional and personal needs!",
    "Instead of using our automatic recipe finder you may wish to enter recipes manually.We allow you to do this with the help of our powerful recipe search tool.You can set the criteria to return any type of recipe you wish, including only returning recipes that do or don’t contain a particular ingredient we also let you search recipes by all their nutritional values.",
    "After your meal plan has been created you can check out the grocery list function, which lets you know all the ingredients you need to make the recipes. Make use of the pantry function if you would like the grocery list to recognise when you already have certain ingredients stocked at home. Once you are happy with the list and have removed any ingredients you don’t need you can then export the shopping list to a PDF for you to either print off or have on your phone when you go to do your shopping.",
  ];

  const qa_handller = (index) => {
    let temp = active_qs;

    if (temp[index] === true) {
      temp[index] = false;
    } else {
      temp[index] = true;
    }
    setactive_qs({ ...temp });
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
      <AnimatedPage>
        <section id="section1" className={styles.section1}>
          <div className={styles.s1_content}>
            <h1>Your Personal Diet Planner</h1>
            <p>
              Calorie and Macro Meal Planner. Serve up recipes for your
              personalized meal plan automatically. Calculate your nutritional
              needs and generate custom diet plans for weight loss, bodybuilding
              and much more!
            </p>

            {userData && token ? (
              <Link className={styles.LINK} to={"infoForm"}>
                <button>GET STARTED NOW</button>
              </Link>
            ) : (
              <Link className={styles.LINK} to={"login"}>
                <button>GET STARTED NOW</button>
              </Link>
            )}
          </div>
          <img
            src={require("../../images/home/home_pic.png")}
            alt="home_image"
          />
        </section>

        <section id="section3" className={styles.section3}>
          <h3>Custom Diet Plans For Your Needs</h3>
          <p>Personalize the meal plan to meet your needs</p>

          <div className={styles.container}>
            <div className={styles.small_container}>
              <img
                src={
                  require("../../images/home/section3/custom-nutritional-targets.svg")
                    .default
                }
                alt="custom-nutritional-targets"
              />
              <h4>Custom Nutritional Targets</h4>
              <p>{section3_ps[0]}</p>
            </div>
            <div className={styles.small_container}>
              <img
                src={
                  require("../../images/home/section3/dietary-needs.svg")
                    .default
                }
                alt="dietary-needs"
              />
              <h4>Dietary Needs</h4>
              <p>{section3_ps[1]}</p>
            </div>
            <div className={styles.small_container}>
              <img
                src={
                  require("../../images/home/section3/adjust-meal-preferences.svg")
                    .default
                }
                alt="adjust-meal-preferences"
              />
              <h4>Adjust Meal Preferences</h4>
              <p>{section3_ps[2]}</p>
            </div>
          </div>
        </section>

        <section id="section4" className={styles.section4}>
          <h3>Save Time & Eat Better</h3>
          <p>Take the stress out of meal planning and stick to your plan.</p>

          <div className={styles.container}>
            <div className={styles.small_container}>
              <img
                src={
                  require("../../images/home/section4/meal-plan-generator.svg")
                    .default
                }
                alt="meal-plan-generator"
              />
              <h4>Meal Plan Generator</h4>
              <p>{section4_ps[0]}</p>
            </div>
            <div className={styles.small_container}>
              <img
                src={
                  require("../../images/home/section4/powerful-secipe-search.svg")
                    .default
                }
                alt="powerful-secipe-search"
              />
              <h4>Powerful Recipe Search</h4>
              <p>{section4_ps[1]}</p>
            </div>
            <div className={styles.small_container}>
              <img
                src={
                  require("../../images/home/section4/grocery-list.svg").default
                }
                alt="grocery-list"
              />
              <h4>Grocery List</h4>
              <p>{section4_ps[2]}</p>
            </div>
          </div>
        </section>

        <section id="faq" className={styles.section_faq}>
          <h3>Frequently Asked Questions</h3>
          <div
            className={`${styles.txt_container} ${
              active_qs[0] ? styles.active : " "
            }`}
            onClick={() => qa_handller(0)}
          >
            <p className={styles.q}>{QA[0].q}</p>
            <p className={styles.a}>{QA[0].a}</p>
          </div>
          <div
            className={`${styles.txt_container} ${
              active_qs[1] ? styles.active : " "
            }`}
            onClick={() => qa_handller(1)}
          >
            <p className={styles.q}>{QA[1].q}</p>
            <p className={styles.a}>{QA[1].a}</p>
          </div>
          <div
            className={`${styles.txt_container} ${
              active_qs[2] ? styles.active : " "
            }`}
            onClick={() => qa_handller(2)}
          >
            <p className={styles.q}>{QA[2].q}</p>
            <p className={styles.a}>{QA[2].a}</p>
          </div>
          <div
            className={`${styles.txt_container} ${
              active_qs[3] ? styles.active : " "
            }`}
            onClick={() => qa_handller(3)}
          >
            <p className={styles.q}>{QA[3].q}</p>
            <p className={styles.a}>{QA[3].a}</p>
          </div>
        </section>
      </AnimatedPage>
    </div>
  );
};
