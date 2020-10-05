In nodeJSTest there is a node.js project, which can must be launched on local machine. There are a lot of not required components in there, it needs to be cleaned by a person who is familiar with node.js, but it still does what is required.

After the server is run, it will start listening to port 3002, this can be configured in nodeJSTest\bin\www, line 15;
In order to send the request you need to copy the following method in your lwc and then call it


`httpGet(aUrl, aCallback)
 {
     let anHttpRequest = new XMLHttpRequest();
     anHttpRequest.onreadystatechange = function () {
         if (anHttpRequest.readyState === 4 && anHttpRequest.status === 200) {
             aCallback(anHttpRequest.responseText);
         } else {
             console.log("Error", anHttpRequest.statusText);
         }
     }
     anHttpRequest.open("POST", aUrl, true);
     anHttpRequest.setRequestHeader("Content-type", "application/json");
     let postBody = {scriptName: "\"C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe\" --profile-directory=\"Default\""};
     anHttpRequest.send(JSON.stringify(postBody));
 }`
    
	
Here is the method call example

`this.httpGet('http://localhost:3002', (responseText)=>{
            debugger;
        });`
		
		
		
What it will do is: it will launch the program, which you specify in the "scriptName" param, in this particular example it will launch chrome browser from your program files directory.
		