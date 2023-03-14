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
    .then((data) => console.log(data));
};
