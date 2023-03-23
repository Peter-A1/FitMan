import React from "react";
import { motion } from "framer-motion";

const animations = {
  initial: { opacity: 0, x: 100, y: 350 },
  animate: { opacity: 1, x: 0 },
  exit: { opacity: 0, x: -100, y: 350 },
};

export const AnimatedPage2 = ({ children }) => {
  return (
    <motion.div
      variants={animations}
      initial="initial"
      animate="animate"
      exit="exit"
      transition={{ duration: 0.6 }}
    >
      {children}
    </motion.div>
  );
};

export default AnimatedPage2;
