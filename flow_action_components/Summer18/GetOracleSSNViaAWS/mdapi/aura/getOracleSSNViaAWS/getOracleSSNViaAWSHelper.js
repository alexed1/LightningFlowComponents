/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * Licensed under the BSD 3-Clause license.
 * For full license text, see LICENSE.txt file in the repo root  or https://opensource.org/licenses/BSD-3-Clause
 */
 ({
    fetchSSN : function(userId, cancelToken) {
        return new Promise(function(resolve, reject) {
            var xhttp = new XMLHttpRequest();
            xhttp.onreadystatechange = $A.getCallback(function() {
              if (this.readyState === this.DONE) {
                if (this.status >= 200 && this.status < 300) {
                    var result = JSON.parse(xhttp.responseText);
                    resolve(result);
                } else {
                     var errorText = this.status === 0 ?
                      'Request has been terminated\nPossible causes: the network is offline, Origin is not allowed by Access-Control-Allow-Origin, the page is being unloaded, etc.':
                      this.statusText || this.status;
                     reject(new Error(errorText));
                }
              }

              // Gracelly abort the Promise if it times out
              cancelToken && cancelToken.promise.then(function(error) {
                xhttp.abort();
                reject(new Error(error + " Promise has been cancelled."));
              });

            });
            xhttp.open("GET", "https://e45sfxhtub.execute-api.eu-west-1.amazonaws.com/demo/ssn?userid=" + userId, true);
            xhttp.send(null);
           });
        }
})