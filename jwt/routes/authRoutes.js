const { Router } = require('express');
const authController = require('../controllers/authController');

const router = Router();

router.get('/register', authController.register_get);
router.post('/register', authController.register_post);
router.get('/login', authController.login_get);
router.post('/login', authController.login_post);
router.get('/logout', authController.logout_get);
router.put('/:id/getstarted', authController.getstarted_put);
router.post('/forget-password', authController.forgetpassword_post); 
router.post('/reset-password/:id/:token', authController.resetpassword_put);


module.exports = router;