const { Router } = require('express');
const authController = require('../controllers/authController');

const router = Router();

//router.get('/register', authController.register_get);
router.post('/register', authController.register_post);
//router.get('/login', authController.login_get);
router.post('/login', authController.login_post);
router.get('/logout', authController.logout_get);
router.put('/:id/getstarted', authController.getstarted_put);
router.post('/forget-password', authController.forgetpassword_post); 
router.post('/reset-password/:id/:token', authController.resetpassword_put);
router.get('/ip', authController.ip);
router.get('/:id/userData', authController.userData);
router.get('/:id/Dietplan', authController.DietPlan);
//router.get('/:id/plandata', authController.plandata);
router.get('/fooddata/:id', authController.foodData);
router.get('/search/:key', authController.search);
// router.get('/:id/favfood', authController.favfood);
router.post('/addfood', authController.addfood);
router.put('/:id/pickfood', authController.pickfood);
router.put('/:id/removefood', authController.removefood);

module.exports = router;