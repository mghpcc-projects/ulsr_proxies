Once server is installed the client can be accessed through HTTPS ``GET`` and ``POST`` requests. Each instance of the server will have a different URL. The URL provides three endpoints, each with a different URL

   1. ``hello-world`` e.g. https://0e5f0zcx22.execute-api.us-east-2.amazonaws.com/e1TimTesting20180304/hello-world
   
   2. ``put`` e.g. https://0e5f0zcx22.execute-api.us-east-2.amazonaws.com/e1TimTesting20180304/ulsr-res-id
   
   3. ``get`` e.g. https://0e5f0zcx22.execute-api.us-east-2.amazonaws.com/e1TimTesting20180304/ulsr-res-id ``/RESERVATION_ID``
   
   Accessing any of the endpoints requires and API key that is passed in the x-api-key header field of the HTTP request.
   
   ### Endpoints
   
   * The ``hello-world`` endpoint [code](https://github.com/mghpcc-projects/ulsr_proxies/blob/c1c804632a59950c13faad1f227a4fc028fbc151/persistent_state_proxies/aws-dynamodb-client-and-server/serverless-aws-code/nodejs-form/handler.js#L6) provides a simple test of the Lambda function. It can be invoked by e.g.
   
      ```
      curl -H "X-Api-Key: KKKKKKKKKKKKKKKK" https://0e5f0zcx22.execute-api.us-east-2.amazonaws.com/e1TimTesting20180304/hello-world
      ```
   
      where ```KKKKKKKKKKKKKKKK``` is the API key secret. The ``hello-world`` endpoint returns information on the query received by the Lambda function. It does not interact with DynamoDB.
      
   * The ``put`` endpoint [code](https://github.com/mghpcc-projects/ulsr_proxies/blob/c1c804632a59950c13faad1f227a4fc028fbc151/persistent_state_proxies/aws-dynamodb-client-and-server/serverless-aws-code/nodejs-form/handler.js#L21) stores an item in the DynamoDB NoSQL database. The item is described in JSON included in the HTTP call. The key for the item is taken from the ``resid`` variable in the JSON. The values in the JSON variable ``ib_splist`` are stored with the key. For ``ULSR`` the ``resid`` variable is envisioned to be some unique Slurm reservation id (the reservation name string for example). The ``ib_splist`` JSON is envisioned to be an array of ``GUID``, ``port number`` pairs, corresponding to the ports whose state is managed by ``ULSR``. An exmple invocation of the ``put`` endpoint is e.g.
   
      ```
    curl -H "Content-Type: application/json" -H "X-Api-Key: KKKKKKKKKKKKKKKK" -d '{"resid":"flexalloc_moc_20170410_rack7_8","ib_splist":[{"0xE108ABG":"9"},{"0xE108ABG":"12"},{"0xE108ABF":"3"}]}' -X POST https://0e5f0zcx22.execute-api.us-east-2.amazonaws.com/e1TimTesting20180304/ulsr-res-id
      ```
    
