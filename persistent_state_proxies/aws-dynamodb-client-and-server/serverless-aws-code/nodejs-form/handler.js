'use strict';
const AWS = require('aws-sdk');
const ULSRRESINFO_TABLE = process.env.ULSRRESINFO_TABLE;
const dynamoDb = new AWS.DynamoDB.DocumentClient();

module.exports.helloWorld = (event, context, callback) => {
  const response = {
    statusCode: 200,
    headers: {
      'Access-Control-Allow-Origin': '*', // Required for CORS support to work
    },
    body: JSON.stringify({
      message: 'Go Serverless v1.0! Your function executed successfully!',
      input: event,
    }),
  };

  callback(null, response);
};

module.exports.putUlsrResInfo = (event, context, callback) =>{
 console.log('putUlsrResInfo: starting');
 // Body is transferred as a string so need to convert to JSON
 const bdy = JSON.parse(event.body);
 // bdy is expected to contain the following JSON
 // 1. resid     - a text string that is a unique reservation ID
 //                e.g.  "resid":"flexalloc_moc_20170410_rack7_8"
 // 2. ib_splist - an array of key, value pairs with GUID as key and port number as value.
 //                e.g. "ib_splist":[{"0xE108ABG":"9"},{"0xE108ABG":"12"},{"0xE108ABF":"3"}]
 // resid is used as the primary key in the DynamoDB (NoSQL) database
 //  ib_splist is a field associated with the key that holds the GUID, port array blob for 
 //  the reservation.
 // Build DB put request
 const params = {
   TableName:process.env.ULSRRESINFO_TABLE,
   Item: {
    resId: bdy.resid,
    "foo":"bar4",
    "ibSplist": JSON.stringify(bdy.ib_splist),
   },
 };
    // ibSplist: bdy.id_splist

 dynamoDb.put(params, (error) => {
  // handle potential errors
  if (error) {
    console.error(error);
    callback(null, {
      statusCode: error.statusCode || 501,
      headers: { 'Content-Type': 'text/plain' },
      body: 'Couldn\'t create the user level Slurm reservation info item.',
    });
    return;
  }
 });

 let response = {
  statusCode:200,
  headers: {
      'Access-Control-Allow-Origin': '*',
      'Content-Type': 'application/json',
    }
 };
 response.statusCode=200;
 response.body=JSON.stringify({"func":
                                "putUlsrResInfo",
                               "thbody": 
                                bdy,
                              });
 console.log('putUlsrResInfo: exiting');
 callback(null, response);
};

module.exports.getUlsrResInfo = (event, context, callback) =>{
 console.log('getUlsrResInfo: starting');
 let response = {
  statusCode:200,
  headers: {
      'Access-Control-Allow-Origin': '*',
    }
 };
 const params = {
  TableName:process.env.ULSRRESINFO_TABLE,
  Key:{
   resId: event.pathParameters.resid
  },
 };

  dynamoDb.get(params, function (error, result) {
    // handle potential errors
    console.log('read record',JSON.stringify(result))
    if (error) {
      console.error(error);
      callback(null, {
        statusCode: error.statusCode || 501,
        headers: { 'Content-Type': 'text/plain' },
        body: 'Couldn\'t fetch the todo item.',
      });
      return;
    }
    const response = {
      headers: {
      'Access-Control-Allow-Origin': '*',
      },
      statusCode: 200,
      body: JSON.stringify(result.Item),
    };
    callback(null, response);
    return;
  });


 // response.statusCode=200;
 // response.body=JSON.stringify([{"func":"getUlsrResInfo"},params]);
 // console.log('getUlsrResInfo: exiting');
 // callback(null, response);
};
