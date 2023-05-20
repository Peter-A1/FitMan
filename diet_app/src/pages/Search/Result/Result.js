import React from 'react'
import Food from '../../../components/food/Food';

export const Result = ({foodcategory,searchResult,searchCategory,userData,setUserData}) => {
    return (
    <>
        {searchResult
                ? searchResult.map((fooditem, index) => {
                    return (
                      <div>
                        {searchCategory === "breakfast" ? (
                          <Food
                            key={index}
                            userData={userData}
                            setUserData={setUserData}
                            cardcategory={searchCategory}
                            isliked={userData? 
                              userData.favbreakfast.filter(
                                (favitem) =>
                                  fooditem.Food_id === favitem.Food_id
                              ).length > 0
                                ? true
                                : false:false
                            }
                            foodObject={{
                              id: fooditem.Food_id,
                              name: fooditem.Food_name,
                              serving: `${fooditem.preferred_serving} ${fooditem.measuring_unit}`,
                              calories:
                                fooditem.food_calories_per_preferred_serving,
                              url: fooditem.image,
                              category: fooditem.category,
                            }}
                          />
                        ) : (
                          ""
                        )}

                        {searchCategory === "lunch" ? (
                          <Food
                            key={index}
                            userData={userData}
                            setUserData={setUserData}
                            cardcategory={searchCategory}
                            isliked={
                              userData.favlunch.filter(
                                (favitem) =>
                                  fooditem.Food_id === favitem.Food_id
                              ).length > 0
                                ? true
                                : false
                            }
                            foodObject={{
                              id: fooditem.Food_id,
                              name: fooditem.Food_name,
                              serving: `${fooditem.preferred_serving} ${fooditem.measuring_unit}`,
                              calories:
                                fooditem.food_calories_per_preferred_serving,
                              url: fooditem.image,
                              category: fooditem.category,
                            }}
                          />
                        ) : (
                          ""
                        )}

                        {searchCategory === "dinner" ? (
                          <Food
                            key={index}
                            userData={userData}
                            setUserData={setUserData}
                            cardcategory={searchCategory}
                            isliked={
                              userData.favdinner.filter(
                                (favitem) =>
                                  fooditem.Food_id === favitem.Food_id
                              ).length > 0
                                ? true
                                : false
                            }
                            foodObject={{
                              id: fooditem.Food_id,
                              name: fooditem.Food_name,
                              serving: `${fooditem.preferred_serving} ${fooditem.measuring_unit}`,
                              calories:
                                fooditem.food_calories_per_preferred_serving,
                              url: fooditem.image,
                            }}
                          />
                        ) : (
                          ""
                        )}
                      </div>
                    );
                  })
                : ""}
    </>
  )
}
