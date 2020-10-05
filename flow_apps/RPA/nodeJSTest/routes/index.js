var express = require('express');
var router = express.Router();

const { exec } = require('child_process');

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});
router.post('/', function (req, res) {

  let codeToRun = req.body.scriptName;;
  exec(codeToRun, (err, stdout, stderr) => {
    if (err) {
      console.log(`node couldn't execute the command`);
      return;
    }
    console.log(stdout);
  });
  console.log(codeToRun);
  // setInterval(()=>{
  //   console.log(new Date().toLocaleString());

    // exec(codeToRun2, (err, stdout, stderr) => {
    //   if (err) {
    //     console.log(`node couldn't execute the command`);
    //     return;
    //   }
    //   console.log(stdout);
    // });

  // },60 * 60 * 1000)

  res.send('POST request to the homepage')
})

module.exports = router;
