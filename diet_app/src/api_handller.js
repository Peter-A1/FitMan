export const postData = async (url = "", data = {}) => {
  const response = await fetch(url, {
    method: "POST",
    credentials: "same-origin",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(data),
  });

  try {
    const newData = await response.json();
    console.log(await newData); //debug code
    return newData;
  } catch (error) {
    console.log("error", error);
  }
};

export const login_post = async (url, { email, password }) => {
  try {
    const res = await fetch(url, {
      method: "POST",
      body: JSON.stringify({ email, password }),
      headers: { "Content-Type": "application/json" },
    });
    const data = await res.json();
    return data;
  } catch (err) {
    return err;
  }
};

export const getData = (url) => {
  fetch(url)
    .then((res) => res.json())
    .then((data) => data);
};

export const getData2 = async (url) => {
  try {
    const response = await fetch(url);
    const json = await response.json();
    //  console.log('from api func',url);
    return await json
  } catch (error) {
    console.log("error", error);
  }
};

export const put = async (url, data) => {
  // Awaiting fetch which contains method,
  // headers and content-type and body
  const response = await fetch(url, {
    method: "PUT",
    headers: {
      "Content-type": "application/json",
    },
    body: JSON.stringify(data),
  }
  
  );

  console.log('test2')
  // Awaiting response.json()
  const resData = await response.json();
  console.log('testeeeeeeeeee');
  console.log(await resData);
  // Return response data
  return resData;
};

export const GetIp = async () => {
  return getData2("https://api.ipify.org/?format=json");
};
