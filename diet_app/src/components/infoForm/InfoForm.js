import React, { useState } from "react";
import styles from "./infoForm.module.css";
// to do re direct to login if not login
export const InfoForm = () => {
  const [step, setstep] = useState(0);
  return <div className={styles.form_body}>InfoForm</div>;
};

export default InfoForm;
