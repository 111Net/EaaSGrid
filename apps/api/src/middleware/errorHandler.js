module.exports = (err, req, res, next) => {

  console.error({
    message: err.message,
    stack: err.stack,
    path: req.path,
    method: req.method
  });


  res.status(err.status || 500).json({

    success:false,

    error:{
      message:
        err.message || "Internal Server Error"
    },

    timestamp:new Date().toISOString()

  });

};
