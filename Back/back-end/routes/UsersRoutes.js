const express = require('express');
const { changeUserEmail, changeName, changeUsername, changeUserPhone, changeUserBirth, changeUserPassword, getUserData, getAllUsers, addUser, getUserName, getUserPass, editUser } = require('../controller/UsersController.js');
const router = express.Router();

router.route('/')
    .get(getAllUsers)
    .post(addUser);

router.route('/:userId')
    .get(getUserName)
    .patch(editUser);

router.route('/:userId/getPass')
    .get(getUserPass);

router.route('/userdata/:userId')
    .get(getUserData);

router.route('/:userId/email').put(changeUserEmail);
router.route('/:userId/name').put(changeName);
router.route('/:userId/birth').put(changeUserBirth);
router.route('/:userId/password').put(changeUserPassword);
router.route('/:userId/phone').put(changeUserPhone);
router.route('/:userId/username').put(changeUsername);

module.exports = router;
