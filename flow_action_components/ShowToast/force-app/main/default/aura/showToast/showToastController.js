/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * Licensed under the BSD 3-Clause license.
 * For full license text, see LICENSE.txt file in the repo root  or https://opensource.org/licenses/BSD-3-Clause
 */
 ({
    invoke : function(component, event, helper) {

        var type = component.get("v.type").toLowerCase(); //force user entered attribute to all lowercase
        var title = component.get("v.title");
        var message = component.get("v.message");
        var duration = component.get("v.duration")+"000"; //convert duration value from seconds to milliseconds
        var mode = component.get("v.mode").toLowerCase(); //force user entered attribute to all lowercase
        var key = component.get("v.key").toLowerCase();   //force user entered attribute to all lowercase

        var isURL = message.toLowerCase().includes('{url}');  //Did the user include '{url}' in their message?

        if(!isURL){
            helper.showToast(type, title, message, duration, mode, key);
        }

        if(isURL){
          var messageUrl = message.replace('{url}', '{1}');
          var urlLink = component.get("v.urlLink")
          var urlLabel = component.get("v.urlLabel");
          //Add 'http://' to the URL if it is not already included
          if(urlLink.toLowerCase().indexOf('http') == -1){
              urlLink = 'http://' + urlLink;  
          }
          helper.showToastUrl(type, title, messageUrl, urlLink, urlLabel, duration, mode, key);
        }
        
    }
})
