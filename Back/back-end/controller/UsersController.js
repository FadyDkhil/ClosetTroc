const User = require('../models/Users.js');

const getAllUsers = async (req, res) => {
    try {
        const users = await User.find({});
        res.status(200).json({ users });
    } catch (err) {
        res.status(500).json({ msg: err });
    }
};

const addUser = async (req, res) => {
    try {
        const user = await User.create(req.body);
        res.status(201).json({ user });
    } catch (err) {
        res.status(500).json({ msg: err });
    }
};

const getUserName = async (req, res) => {
    try {
        // Assuming you have the user ID in the request params
        const userId = req.params.userId; // Replace with your actual way of getting the user ID

        // Query the database to get the user by ID
        const user = await User.findById(userId);

        if (user) {
            // Send the user's name as JSON response
            res.json({ userName: user.name });
        } else {
            res.status(404).json({ error: 'User not found' });
        }
    } catch (error) {
        console.error(error); // Log the error to the console
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
const getUserPass = async (req, res) => {
    try {
        const userId = req.params.userId;
        const user = await User.findById(userId);

        if (user) {
            res.json({ userPass: user.password });
        } else {
            res.status(404).json({ error: 'User not found' });
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
// //getPass
// const getUserPass = async (req, res) => {
//     try {
//         // Assuming you have the user ID in the request params
//         const userId = req.params.userId; // Replace with your actual way of getting the user ID

//         // Query the database to get the user by ID
//         const user = await User.findById(userId);

//         if (user) {
//             // Send the user's name as JSON response
//             res.json({ userPass: user.password });
//         } else {
//             res.status(404).json({ error: 'User not found' });
//         }
//     } catch (error) {
//         console.error(error); // Log the error to the console
//         res.status(500).json({ error: 'Internal Server Error' });
//     }
// };
const editUser = async (req,res) => {
    try{
        const {id:userID} = req.params
        const updatedUser = await Event.findOneAndUpdate({_id: userID}, req.body,{ new: true, runValidators: true})
        if(!updatedUser){
            return res.status(404).json({msg: 'no User with the ID: ${eventID}'})
        }
        res.status(202).json({updatedUser})
    }catch(err){
        res.status(500).json({msg: err})
    }
}
const getUserData = async (req, res) => {
    try {
      const userId = req.params.userId; // Assuming you have the user ID in the request params
  
      // Query the database to get the user by ID
      const user = await User.findById(userId);
      console.log('All Request Params:', req.params);
      console.log('Received User ID:', userId);
  
      if (user) {
        // Send the user's data as JSON response
        res.json({
          name: user.name,
          username: user.username,
          email: user.email,
          birth: user.birth,
          phone: user.phone,
        });
      } else {
        res.status(404).json({ error: 'User not found' });
      }
    } catch (error) {
      console.error(error); // Log the error to the console
      res.status(500).json({ error: 'Internal Server Error' });
    }
  };
  

//specefic
const changeName = async (req, res) => {
  try {
    const userId = req.params.userId;
    const { newName } = req.body;

    // Validate input
    if (!newName) {
      return res.status(400).json({ error: 'New name is required' });
    }

    // Find the user by ID and update the name
    const updatedUser = await User.findByIdAndUpdate(
      userId,
      { name: newName },
      { new: true }
    );

    if (!updatedUser) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Send the updated user data as a response
    res.json(updatedUser);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
};

const changeUserEmail = async (req, res) => {
    try {
      const userId = req.params.userId;
      const { newEmail } = req.body;
  
      // Validate input
      if (!newEmail) {
        return res.status(400).json({ error: 'New email is required' });
      }
  
      // Find the user by ID and update the name
      const updatedUser = await User.findByIdAndUpdate(
        userId,
        { email: newEmail },
        { new: true }
      );
  
      if (!updatedUser) {
        return res.status(404).json({ error: 'User not found' });
      }
  
      // Send the updated user data as a response
      res.json(updatedUser);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  };
  
  const changeUserPassword = async (req, res) => {
    try {
      const userId = req.params.userId;
      const { newPassword } = req.body;
  
      // Validate input
      if (!newPassword) {
        return res.status(400).json({ error: 'New password is required' });
      }
  
      // Find the user by ID and update the name
      const updatedUser = await User.findByIdAndUpdate(
        userId,
        { password: newPassword },
        { new: true }
      );
  
      if (!updatedUser) {
        return res.status(404).json({ error: 'User not found' });
      }
  
      // Send the updated user data as a response
      res.json(updatedUser);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  };

  const changeUserPhone = async (req, res) => {
    try {
      const userId = req.params.userId;
      const { newPhoneNumber } = req.body;
  
      // Validate input
      if (!newPhoneNumber) {
        return res.status(400).json({ error: 'New phone is required' });
      }
  
      // Find the user by ID and update the name
      const updatedUser = await User.findByIdAndUpdate(
        userId,
        { phone: newPhoneNumber },
        { new: true }
      );
  
      if (!updatedUser) {
        return res.status(404).json({ error: 'User not found' });
      }
  
      // Send the updated user data as a response
      res.json(updatedUser);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  };

  const changeUserBirth = async (req, res) => {
    try {
      const userId = req.params.userId;
      const { newDOB } = req.body;
  
      // Validate input
      if (!newDOB) {
        return res.status(400).json({ error: 'New birth is required' });
      }
  
      // Find the user by ID and update the name
      const updatedUser = await User.findByIdAndUpdate(
        userId,
        { birth: newDOB },
        { new: true }
      );
  
      if (!updatedUser) {
        return res.status(404).json({ error: 'User not found' });
      }
  
      // Send the updated user data as a response
      res.json(updatedUser);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  };
  
  const changeUsername = async (req, res) => {
    try {
      const userId = req.params.userId;
      const { newUsername } = req.body;
  
      // Validate input
      if (!newUsername) {
        return res.status(400).json({ error: 'New username is required' });
      }
  
      // Find the user by ID and update the name
      const updatedUser = await User.findByIdAndUpdate(
        userId,
        { username: newUsername },
        { new: true }
      );
  
      if (!updatedUser) {
        return res.status(404).json({ error: 'User not found' });
      }
  
      // Send the updated user data as a response
      res.json(updatedUser);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  };

module.exports = {
    getAllUsers,
    addUser,
    getUserName,
    editUser,
    getUserData,
    changeName,
    changeUserEmail,
    changeUserBirth,
    changeUserPassword,
    changeUserPhone,
    changeUsername,
    getUserPass
};
