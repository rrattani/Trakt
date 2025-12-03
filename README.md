# create a .env file
API_KEY=your_trakt_client_id
client_id=your_trakt_client_id
client_secret=your_trakt_client_secret
tmdb=your_tmdb_api_key_here
PORT=63355
BASE_URL=http://127.0.0.1:63355

Update client_id in UX
1. Modify vue/src/App.vue 
2. Search for https://trakt.tv/oauth/authorize?
3. Update the client_id query parameter value to your_trakt_client_id
4. This change is needed to two places in the file.

npm install
npm run Build
npm start