import { api, LightningElement } from 'lwc';
import gapi from '@salesforce/resourceUrl/gapi';
import gsi from '@salesforce/resourceUrl/gsi';
import { loadScript } from 'lightning/platformResourceLoader';

export default class Alerter extends LightningElement {

      /* exported gapiLoaded */
      /* exported gisLoaded */
      /* exported handleAuthClick */
      /* exported handleSignoutClick */
 

      // TODO(developer): Set to client ID and API key from the Developer Console
      CLIENT_ID = '103975973590908856473';
      API_KEY = 'AIzaSyASmhaizFZ2oYvIzVgGb0q4BgnoEBel8mc';

      // Discovery doc URL for APIs used by the quickstart
      DISCOVERY_DOC = 'https://www.googleapis.com/discovery/v1/apis/calendar/v3/rest';

      // Authorization scopes required by the API; multiple scopes can be
      // included, separated by spaces.
      SCOPES = 'https://www.googleapis.com/auth/calendar.readonly';

    @api
    foo;


    connectedCallback() {

        let tokenClient;
        let gapiInited = false;
        let gisInited = false;
 
        //document.getElementById('authorize_button').style.visibility = 'hidden'; //these generate a null error. probably not loaded fast enough.
        //document.getElementById('signout_button').style.visibility = 'hidden';
        console.log('entering connected callback');
        Promise.all([
            console.log('entering promise'),
            //loadStyle(this, gapi + '/leaflet.css'),
            loadScript(this, gapi ),
            loadScript(this, gsi ),
        ]).then(() => {
            console.log('made it to then in promise');
            gapiLoaded();
            gisLoaded();
            console.log('inside connected callback and scripts have been loaded');
        }).catch((error) => {
            // If the promise rejects, we enter this code block
            console.log('made it to catch block. error is: ' + error); // TestError;
        })
     }

     async intializeGapiClient() {
        await gapi.client.init({
          apiKey: API_KEY,
          discoveryDocs: [DISCOVERY_DOC],
        });
        gapiInited = true;
        maybeEnableButtons();
      }

      /**
       * Callback after api.js is loaded.
       */
      gapiLoaded() {
        gapi.load('client', intializeGapiClient);
      }

      /**
       * Callback after the API client is loaded. Loads the
       * discovery doc to initialize the API.
       */
     

      /**
       * Callback after Google Identity Services are loaded.
       */
       gisLoaded() {
        tokenClient = google.accounts.oauth2.initTokenClient({
          client_id: CLIENT_ID,
          scope: SCOPES,
          callback: '', // defined later
        });
        gisInited = true;
        maybeEnableButtons();
      }

      /**
       * Enables user interaction after all libraries are loaded.
       */
       maybeEnableButtons() {
        if (gapiInited && gisInited) {
          document.getElementById('authorize_button').style.visibility = 'visible';
        }
      }

      /**
       *  Sign in the user upon button click.
       */
       handleAuthClick() {
        tokenClient.callback = async (resp) => {
          if (resp.error !== undefined) {
            throw (resp);
          }
          document.getElementById('signout_button').style.visibility = 'visible';
          document.getElementById('authorize_button').innerText = 'Refresh';
          await listUpcomingEvents();
        };

        if (gapi.client.getToken() === null) {
          // Prompt the user to select a Google Account and ask for consent to share their data
          // when establishing a new session.
          tokenClient.requestAccessToken({prompt: 'consent'});
        } else {
          // Skip display of account chooser and consent dialog for an existing session.
          tokenClient.requestAccessToken({prompt: ''});
        }
      }

      /**
       *  Sign out the user upon button click.
       */
       handleSignoutClick() {
        const token = gapi.client.getToken();
        if (token !== null) {
          google.accounts.oauth2.revoke(token.access_token);
          gapi.client.setToken('');
          document.getElementById('content').innerText = '';
          document.getElementById('authorize_button').innerText = 'Authorize';
          document.getElementById('signout_button').style.visibility = 'hidden';
        }
      }

      /**
       * Print the summary and start datetime/date of the next ten events in
       * the authorized user's calendar. If no events are found an
       * appropriate message is printed.
       */
      async  listUpcomingEvents() {
        let response;
        try {
          const request = {
            'calendarId': 'primary',
            'timeMin': (new Date()).toISOString(),
            'showDeleted': false,
            'singleEvents': true,
            'maxResults': 10,
            'orderBy': 'startTime',
          };
          response = await gapi.client.calendar.events.list(request);
        } catch (err) {
          document.getElementById('content').innerText = err.message;
          return;
        }

        const events = response.result.items;
        if (!events || events.length == 0) {
          document.getElementById('content').innerText = 'No events found.';
          return;
        }
        // Flatten to string to display
        const output = events.reduce(
            (str, event) => `${str}${event.summary} (${event.start.dateTime || event.start.date})\n`,
            'Events:\n');
        document.getElementById('content').innerText = output;
      }
   // </script>
   // <script async defer src="https://apis.google.com/js/api.js" onload="gapiLoaded()"></script>
   // <script async defer src="https://accounts.google.com/gsi/client" onload="gisLoaded()"></script>




}