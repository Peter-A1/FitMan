const express = require("express");
const mongoose = require("mongoose");
const authRoutes = require("./routes/authRoutes");
const cookieParser = require("cookie-parser");
const { requireAuth, checkUser } = require("./middleware/authmw");
const cors = require("cors");

const app = express();
// cors
app.use(cors());
app.use(express.json());

// middleware
app.use(express.static("public"));
app.use(express.json());
app.use(cookieParser());

// view engine
app.set("view engine", "ejs");

//db config
const db = require("./config/keys").MongoURI;

//mongo connect
mongoose
  .connect(db, { useNewUrlParser: true })
  .then(() => console.log("MongoBD connected... <3"))
  .catch((err) => console.log(err));
mongoose.set('useFindAndModify', false);

//Bodyparser
const bodyParser = require("body-parser");

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// routes
app.get("*", checkUser);
app.get("/", (req, res) => res.render("home"));
app.get("/:id", requireAuth, (req, res) => res.render(":id"));
app.use(authRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, console.log("Server started on port ${PORT}"));
